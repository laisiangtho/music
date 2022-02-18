part of 'main.dart';

class TrackListItem extends StatelessWidget {
  const TrackListItem({Key? key, required this.context, required this.track}) : super(key: key);

  final BuildContext context;
  final AudioMetaType track;

  Core get core => context.read<Core>();
  Audio get audio => core.audio;
  AudioBucketType get cache => core.collection.cacheBucket;

  Preference get preference => core.preference;

  void showPlaylistEditor(BuildContext context) {
    // showBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) => const PlaylistEditor(),
    //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //   elevation: 10,
    // );
    // final abc = SystemUiOverlayStyle.light;
    showModalBottomSheet(
      context: context,
      // builder: (BuildContext context) => TrackOption(
      //   trackId: track.trackInfo.id,
      // ),
      builder: (BuildContext context) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          // value: SystemUiOverlayStyle.light.copyWith(
          //   systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          //   systemNavigationBarDividerColor: Theme.of(context).focusColor,
          // ),
          value: SystemUiOverlayStyle(
            // systemNavigationBarColor: Theme.of(context).primaryColor,
            systemNavigationBarDividerColor: Theme.of(context).focusColor,
            // systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: TrackOption(
            trackId: track.trackInfo.id,
          ),
        );
      },
      barrierColor: Theme.of(context).shadowColor.withOpacity(0.6),
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      elevation: 10,
      useRootNavigator: true,
    ).whenComplete(
      () => Future.delayed(
        const Duration(milliseconds: 300),
        () => {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AudioMediaStateType>(
      stream: audio.mediaState(track.trackInfo.id.toString()),
      builder: (context, snap) {
        // final state = snap.data ?? AudioQueueStateType.empty;

        final state = snap.data;

        if (snap.hasData) {
          return _container(
            queued: state!.queued,
            playing: state.playing,
            index: state.index,
          );
        }
        return _container(
          queued: false,
          playing: false,
        );
      },
    );
  }

  Widget _container({
    bool queued = false,
    bool playing = false,
    int? index,
  }) {
    return ListTile(
      key: key,
      minVerticalPadding: 0,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: queued ? Theme.of(context).highlightColor : Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            playing
                ? Icons.pause_rounded
                : queued
                    ? Icons.play_arrow_rounded
                    : Icons.playlist_add_rounded,
            // color: queued?Theme.of(context).highlightColor:null,
          ),
        ),
      ),
      title: Text(
        track.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        track.artist,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Text(
        cache.duration(track.trackInfo.duration),
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: () {
        audio.addQueueItem(audio.generateMediaItem(track.trackInfo.id));
      },
      onLongPress: () => showPlaylistEditor(context),
    );
  }
}

class TrackListItemHolder extends StatelessWidget {
  const TrackListItemHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(7.0),
          child: Icon(
            Icons.playlist_add,
          ),
        ),
      ),
      title: SizedBox(
        height: 19.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
        ),
      ),
      subtitle: SizedBox(
        height: 12.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor.withOpacity(0.7),
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
        ),
      ),
    );
  }
}
