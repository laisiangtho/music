part of ui.widget;

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
      leading: SizedBox.square(
        dimension: 55,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Padding(
            padding: EdgeInsets.all(15),
            child: Icon(
              LideaIcon.artist,
              size: 25,
            ),
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
          badage(context, LideaIcon.time, cache.duration(meta.duration)),
          badage(context, LideaIcon.music, intl.NumberFormat.compact().format(meta.track)),
          const Divider(indent: 5),
          badage(context, LideaIcon.album, intl.NumberFormat.compact().format(meta.album)),
        ],
      ),
      trailing: Text(
        intl.NumberFormat.compact().format(plays),
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: () => core.navigate(to: '/artist-info', args: meta, routePush: false),
    );
  }

  Widget badage(BuildContext context, IconData icon, String label) {
    // return SizedBox(
    //   width: 60,
    //   child: Text(
    //     label,
    //     style:
    //         Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).dividerColor),
    //     softWrap: false,
    //     overflow: TextOverflow.fade,
    //   ),
    // );
    // return SizedBox(
    //   width: 50,
    //   child: Wrap(
    //     // mainAxisSize: MainAxisSize.max,
    //     // clipBehavior: Clip.hardEdge,
    //     children: [
    //       Icon(
    //         icon,
    //         color: Theme.of(context).focusColor,
    //         size: 18,
    //       ),
    //       Text(
    //         label,
    //         style: Theme.of(context)
    //             .textTheme
    //             .bodySmall!
    //             .copyWith(color: Theme.of(context).dividerColor),
    //         softWrap: false,
    //         overflow: TextOverflow.fade,
    //       )
    //     ],
    //   ),
    // );
    return WidgetMark(
      icon: icon,
      iconColor: Theme.of(context).focusColor,
      iconSize: 15,
      label: label,
      labelStyle: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(color: Theme.of(context).primaryColorDark),
      constraints: const BoxConstraints(maxHeight: 22, minHeight: 22),
    );
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

class ArtistBlockItem extends StatelessWidget {
  final BuildContext context;
  final AudioArtistType artist;
  final bool routePush;

  // final FutureOr<T> Function<T>()? whenNavigate;
  final FutureOr Function()? whenNavigate;

  const ArtistBlockItem({
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
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 2, bottom: 1, top: 1),
      message: '(*) (??)'
          .replaceFirst('(*)', artist.name)
          .replaceFirst('??', artist.aka)
          .replaceFirst(' ()', ''),
      // color: Theme.of(context).shadowColor,
      // borderRadius: const BorderRadius.all(Radius.circular(100.0)),
      // padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 13),
      // color: Theme.of(context).shadowColor,
      // borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
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
      child: WidgetLabel(
        // alignment: Alignment.centerLeft,
        label: artist.name,
      ),
    );
  }
}

class ArtistBlockMore extends StatelessWidget {
  const ArtistBlockMore({
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

      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor.withOpacity(0.3),
        borderRadius: const BorderRadius.all(Radius.circular(100.0)),
      ),
      // minSize: 35,
      onPressed: onPressed,
      child: WidgetLabel(
        label: more.replaceFirst('*', count.toString()).replaceFirst('?', total.toString()),
      ),
    );
  }
}
