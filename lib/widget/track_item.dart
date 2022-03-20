part of 'main.dart';

class TrackListItem extends StatelessWidget {
  const TrackListItem({
    Key? key,
    required this.context,
    required this.index,
    required this.track,
    this.reorderable = false,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final AudioMetaType track;
  final bool reorderable;

  Core get core => context.read<Core>();
  Audio get audio => core.audio;
  AudioBucketType get _bucket => core.collection.cacheBucket;

  Preference get preference => core.preference;

  void showOption() {
    showModalBottomSheet(
      context: context,
      // builder: (BuildContext context) => TrackOption(
      //   trackId: track.trackInfo.id,
      // ),
      builder: (BuildContext context) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarDividerColor: Theme.of(context).focusColor,
          ),
          child: TrackOption(
            trackId: track.trackInfo.id,
          ),
        );
      },
      barrierColor: Theme.of(context).shadowColor.withOpacity(0.6),
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
      stream: audio.trackState(track.trackInfo.id),
      builder: (context, snap) {
        if (snap.hasData) {
          return _container(snap.data!);
        }
        return _container(const AudioMediaStateType());
      },
    );
  }

  Widget _container(AudioMediaStateType state) {
    final queued = state.queued;
    final playing = state.playing;
    final cache = state.cache;
    final cached = cache.caching == 1.0;
    return ListTile(
      minVerticalPadding: 0,
      leading: SizedBox(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: queued ? Theme.of(context).highlightColor : Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              fit: StackFit.loose,
              children: [
                if (cached)
                  Positioned(
                    bottom: 0,
                    right: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Icon(
                        Icons.cloud_done,
                        size: 15,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                Positioned(
                  child: SizedBox.square(
                    dimension: 30,
                    child: CircularProgressIndicator(
                      value: cached ? 0.0 : cache.caching,
                      color: Theme.of(context).focusColor,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    playing
                        ? Icons.pause_rounded
                        : queued
                            ? Icons.play_arrow_rounded
                            : Icons.playlist_add_rounded,
                    size: 32,
                  ),
                ),
              ],
            ),
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
      // trailing: Text(
      //   _bucket.duration(track.trackInfo.duration),
      //   style: Theme.of(context).textTheme.labelSmall,
      // ),
      trailing: reorderable
          ? ReorderableDragStartListener(
              index: index,
              child: const WidgetLabel(
                icon: Icons.drag_handle_rounded,
                // color: Theme.of(context).highlightColor,
              ),
            )
          : Text(
              _bucket.duration(track.trackInfo.duration),
              style: Theme.of(context).textTheme.labelSmall,
            ),
      onTap: () {
        audio.addQueueItem(audio.generateMediaItem(track.trackInfo.id));
      },
      onLongPress: showOption,
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
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.playlist_add_rounded,
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
