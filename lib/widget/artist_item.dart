part of 'main.dart';

class ArtistListItem extends StatelessWidget {
  final BuildContext context;
  final AudioArtistType artist;

  const ArtistListItem({Key? key, required this.context, required this.artist}) : super(key: key);

  Core get core => context.read<Core>();
  // Audio get audio => core.audio;
  AudioBucketType get cache => core.collection.cacheBucket;
  // List<AudioTrackType> get track => cache.track;

  AudioArtistType get meta => cache.artistRefresh(artist);
  String get name => meta.name;
  String get aka => meta.aka;
  int get plays => meta.plays;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Padding(
          padding: EdgeInsets.all(7.0),
          child: Icon(
            LideaIcon.artist,
            size: 25,
          ),
        ),
      ),
      title: Text.rich(
        TextSpan(
          text: name,
          children: <TextSpan>[
            if (aka.isNotEmpty)
              TextSpan(
                text: ' ($aka)',
                style: Theme.of(context).textTheme.labelMedium,
              ),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          // Icon(LideaIcon.listen),
          // Icon(LideaIcon.time),
          // Icon(LideaIcon.music),
          // Icon(LideaIcon.album),
          badage(context, LideaIcon.time, cache.duration(meta.duration)),
          badage(context, LideaIcon.music, meta.track.toString()),
          badage(context, LideaIcon.album, meta.album.toString())
        ],
      ),
      trailing: Text(
        intl.NumberFormat.compact().format(plays),
        // strutStyle: const StrutStyle(height: 1.5),
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: () => core.navigate(to: '/artist-info', args: meta, routePush: false),
    );
  }

  Widget badage(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    return WidgetLabel(
      icon: icon,
      iconColor: Theme.of(context).focusColor,
      iconSize: 15,
      label: label,
      labelStyle: Theme.of(context).textTheme.bodySmall,
    );
    // return Row(
    //   children: [
    //     Icon(
    //       icon,
    //       size: 15,
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 3),
    //       child: Text(
    //         label,
    //         // strutStyle: const StrutStyle(height: 1.2),
    //         style: Theme.of(context).textTheme.bodySmall,
    //       ),
    //     ),
    //   ],
    // );
  }
}

class ArtistListItemHolder extends StatelessWidget {
  const ArtistListItemHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          // color: Color(0xFFe6e7e8),
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(7.0),
          child: Icon(
            LideaIcon.artist,
            size: 25,
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

class ArtistWrapItem extends StatelessWidget {
  final BuildContext context;
  final AudioArtistType artist;
  final bool routePush;

  // final FutureOr<T> Function<T>()? whenNavigate;
  final FutureOr Function()? whenNavigate;

  const ArtistWrapItem({
    Key? key,
    required this.context,
    required this.artist,
    this.routePush = true,
    this.whenNavigate,
    // this.whenComplete,
    // this.whenNavigate,
  }) : super(key: key);

  Core get core => context.read<Core>();

  @override
  Widget build(BuildContext context) {
    return WidgetButton(
      key: key,
      margin: const EdgeInsets.only(right: 2, bottom: 1, top: 1),
      child: WidgetLabel(
        // alignment: Alignment.centerLeft,
        label: artist.name,
        message: '(*) (??)'
            .replaceFirst('(*)', artist.name)
            .replaceFirst('??', artist.aka)
            .replaceFirst(' ()', ''),
      ),
      // color: Theme.of(context).shadowColor,
      // borderRadius: const BorderRadius.all(Radius.circular(100.0)),
      // padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 13),
      // color: Theme.of(context).shadowColor,
      // borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor,
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        shape: BoxShape.rectangle,
      ),
      onPressed: () {
        // core.navigate(to: '/artist-info', args: artist, routePush: routePush);
        // Navigator.of(context).maybePop().whenComplete(() {
        //   Future.delayed(const Duration(milliseconds: 200), () {
        //     if (Navigator.of(context).canPop()) Navigator.pop(context);
        //   }).whenComplete(() {
        //     core.navigate(
        //       to: '/artist-info',
        //       args: artist,
        //       routePush: routePush,
        //     );
        //   });
        // });

        Future.microtask(() async {
          await whenNavigate?.call();
        }).whenComplete(() {
          core.navigate(
            to: '/artist-info',
            args: artist,
            routePush: routePush,
          );
        });
      },
    );
  }
}

class ArtistWrapMore extends StatelessWidget {
  const ArtistWrapMore({
    Key? key,
    this.onPressed,
    this.more = '* / ?',
    this.total = 0,
    this.count = 0,
  }) : super(key: key);

  final void Function()? onPressed;
  final String more;
  final int total;
  final int count;

  @override
  Widget build(BuildContext context) {
    return WidgetButton(
      key: key,
      child: WidgetLabel(
        label: more.replaceFirst('*', count.toString()).replaceFirst('?', total.toString()),
      ),

      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor.withOpacity(0.3),
        borderRadius: const BorderRadius.all(Radius.circular(100.0)),
      ),
      // minSize: 35,
      onPressed: onPressed,
    );
  }
}
