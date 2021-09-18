part of 'track.dart';

class TrackListItem extends StatelessWidget {
  TrackListItem({Key? key, required this.core, required this.track}): super(key: key);

  final Core core;
  final AudioMetaType track;

  Audio get audio => core.audio;
  AudioBucketType get cache => core.collection.cacheBucket;

  @override
  Widget build(BuildContext context) {
    return Selector<Core, bool>(
      key: key,
      selector: (_, _e) => track.trackInfo.queued,
      builder: (_, isQueued, child) {
        if (isQueued){
          // debugPrint('isQueued ${track.trackInfo.id}');
          return Selector<Core, bool>(
            selector: (_, _e) => track.trackInfo.playing,
            builder: (context, isPlaying, child) {
              // debugPrint('isPlaying ${track.trackInfo.id}');
              if (isPlaying){
                return container(
                  context:context,
                  queued: true,
                  playing: true,
                  onPress: ()=> audio.player.pause()
                );
              }
              return child!;
            },
            child: container(
              context:context,
              queued: true,
              onPress: ()=> audio.queuePlayAtId(track.trackInfo.id)
            )
          );
        }
        return child!;
      },
      child: container(
        context:context,
        onPress: ()=> audio.queuefromTrack([track.trackInfo.id])
      )
    );
  }

  Widget container({required BuildContext context, bool queued=false, bool playing=false, void Function()? onPress}) {

    return ListTile(
      key: key,
      // contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: queued?Theme.of(context).highlightColor:Theme.of(context).backgroundColor,
          // color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Icon(
            // playing?ZaideihIcon.pause:ZaideihIcon.play,
            playing?ZaideihIcon.pause:queued?ZaideihIcon.play:Icons.playlist_add,
            // color: queued?Theme.of(context).highlightColor:null,
            // color: Theme.of(context).primaryColor,
            size: 25,
          ),
        ),
      ),
      title: Text(track.title,
        strutStyle: const StrutStyle(
          height: 1.0
        ),
      ),
      subtitle: Text(track.artist,
        strutStyle: const StrutStyle(
          height: 1.5
        ),
      ),
      trailing: Text(cache.duration(track.trackInfo.duration),
        strutStyle: const StrutStyle(
          height: 1.5
        ),
      ),
      onTap: onPress
    );
  }
}

class TrackListItemHolder extends StatelessWidget {
  const TrackListItemHolder({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      minVerticalPadding: 0,
      leading: const DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFe6e7e8),
          borderRadius: const BorderRadius.all(const Radius.circular(5)),
        ),
        child: const Padding(
          padding: const EdgeInsets.all(7.0),
          child: Icon(
            Icons.playlist_add,
            size: 25,
          ),
        ),
      ),
      title: const SizedBox(
        height: 18.0,
        child: const DecoratedBox(
          decoration: const BoxDecoration(
            color: const Color(0xFFe6e7e8),
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
        ),
      ),
      subtitle: const SizedBox(
        height: 18.0,
        child: const DecoratedBox(
          decoration: const BoxDecoration(
            color: const Color(0xFFe6e7e8),
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
        ),
      ),
    );
  }
}
