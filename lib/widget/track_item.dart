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
    return Selector<Core, bool>(
      key: key,
      selector: (_, _e) => track.trackInfo.queued,
      builder: (_, isQueued, child) {
        if (isQueued) {
          // debugPrint('isQueued ${track.trackInfo.id}');
          return Selector<Core, bool>(
            selector: (_, _e) => track.trackInfo.playing,
            builder: (context, isPlaying, child) {
              // debugPrint('isPlaying ${track.trackInfo.id}');
              if (isPlaying) {
                return container(
                  context: context,
                  queued: true,
                  playing: true,
                  onPress: audio.player.pause,
                );
              }
              return child!;
            },
            child: container(
              context: context,
              queued: true,
              onPress: () {
                debugPrint('??? queuePlayAtId');
                audio.queuePlayAtId(track.trackInfo.id);
              },
            ),
          );
        }
        return child!;
      },
      child: container(
        context: context,
        onPress: () {
          debugPrint('??? queuefromTrack');
          audio.queuefromTrack([track.trackInfo.id]);
        },
      ),
    );
  }

  Widget container({
    required BuildContext context,
    bool queued = false,
    bool playing = false,
    void Function()? onPress,
  }) {
    return ListTile(
      key: key,
      minVerticalPadding: 0,
      leading: WidgetButton(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: queued ? Theme.of(context).highlightColor : Theme.of(context).backgroundColor,
          // color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          // playing?ZaideihIcon.pause:ZaideihIcon.play,
          playing
              ? Icons.pause_rounded
              : queued
                  ? Icons.play_arrow_rounded
                  : Icons.playlist_add_rounded,
          // color: queued?Theme.of(context).highlightColor:null,
        ),
        onPressed: onPress,
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
      onTap: onPress,
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
