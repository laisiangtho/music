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
          // color: Theme.of(context).backgroundColor,
          // borderRadius: BorderRadius.circular(3),
          borderRadius: BorderRadius.circular(8),
          // borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(7.0),
          child: Icon(
            // playing?LideaIcon.pause:LideaIcon.play,
            LideaIcon.artist,
            // color: queued?Theme.of(context).highlightColor:null,
            // color: Theme.of(context).primaryColor,
            size: 25,
          ),
        ),
      ),
      // title: Text('meta.title',
      //   strutStyle: const StrutStyle(
      //     height: 1.0
      //   ),
      // ),
      title: RichText(
        // textAlign: TextAlign.center,
        strutStyle: const StrutStyle(height: 1.0),
        text: TextSpan(
          text: name,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1.3),
          children: <TextSpan>[
            if (aka.isNotEmpty)
              TextSpan(
                text: ' ($aka)',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(height: 1.3),
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
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              // fontSize: 13,
              fontFamily: 'Lato',
              // fontWeight: FontWeight.normal,
            ),
      ),
      onTap: () => core.navigate(to: '/artist-info', args: meta, routePush: false),
    );
  }

  Widget badage(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    // return Chip(
    //   padding: EdgeInsets.zero,
    //   // labelPadding: EdgeInsets.zero,
    //   // avatar: CircleAvatar(
    //   //   backgroundColor: Colors.grey.shade800,
    //   //   child: const Text('AB'),
    //   // ),
    //   avatar: Icon(icon,size: 14,),
    //   label: Text(label.toString()),
    // );
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          // color: Theme.of(context).textTheme.caption!.color!.withOpacity(0.5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            label,
            // strutStyle: const StrutStyle(height: 1.2),
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 13,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
      ],
    );
  }
}

class ArtistListItemHolder extends StatelessWidget {
  const ArtistListItemHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      minVerticalPadding: 0,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFe6e7e8),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: EdgeInsets.all(7.0),
          child: Icon(
            LideaIcon.artist,
            size: 25,
          ),
        ),
      ),
      title: SizedBox(
        height: 18.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFFe6e7e8),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
        ),
      ),
      subtitle: SizedBox(
        height: 10.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFFe6e7e8),
            borderRadius: BorderRadius.all(Radius.circular(100)),
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

  const ArtistWrapItem(
      {Key? key, required this.context, required this.artist, this.routePush = true})
      : super(key: key);

  Core get core => context.read<Core>();

  @override
  Widget build(BuildContext context) {
    return WidgetButton(
      key: key,
      child: WidgetLabel(
        label: artist.name,
        labelStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              fontSize: 15,
            ),
        message: '* (??)'
            .replaceFirst('*', artist.name)
            .replaceFirst('??', artist.aka)
            .replaceFirst(' ()', ''),
      ),
      color: Theme.of(context).shadowColor,
      borderRadius: const BorderRadius.all(Radius.circular(100.0)),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 13),
      // minSize: 35,
      onPressed: () => core.navigate(to: '/artist-info', args: artist, routePush: routePush),
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
        labelStyle: Theme.of(context).textTheme.subtitle1,
      ),
      color: Theme.of(context).shadowColor,
      borderRadius: const BorderRadius.all(Radius.circular(100.0)),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 17),
      // minSize: 35,
      onPressed: onPressed,
    );
    /*
    return CupertinoButton(
      key: key,
      child: Text(
        more.replaceFirst('*', count.toString()).replaceFirst('?', total.toString()),
        style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 15, height: 1),
        strutStyle: const StrutStyle(height: 1.3),
      ),
      color: Theme.of(context).shadowColor,
      borderRadius: const BorderRadius.all(Radius.circular(100.0)),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 17),
      minSize: 35,
      onPressed: onPressed,
    );
    */
  }
}
