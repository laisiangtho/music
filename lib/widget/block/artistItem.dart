
part of 'artist.dart';

class ArtistListItem extends StatelessWidget {
  const ArtistListItem({Key? key, required this.core, required this.artist}): super(key: key);

  final Core core;
  final AudioArtistType artist;

  // Audio get audio => core.audio;
  AudioBucketType get cache => core.collection.cacheBucket;

  String get name => artist.name;
  String get aka => artist.aka;
  int get plays => artist.plays;

  @override
  Widget build(BuildContext context) {
    return ListTile(

      // leading: DecoratedBox(
      //   // padding: EdgeInsets.all(5),
      //   decoration: BoxDecoration(
      //     // color: queued?Theme.of(context).highlightColor:Theme.of(context).backgroundColor,
      //     color: Theme.of(context).backgroundColor,
      //     borderRadius: BorderRadius.circular(100),
      //   ),
      //   child: Padding(
      //     padding: const EdgeInsets.all(7),
      //     child: Icon(
      //       ZaideihIcon.artist,
      //       size: 20,
      //     ),
      //   ),
      // ),
      minVerticalPadding: 0,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          // color: Theme.of(context).backgroundColor,
          // borderRadius: BorderRadius.circular(3),
          borderRadius: BorderRadius.circular(8),
          // borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Icon(
            // playing?ZaideihIcon.pause:ZaideihIcon.play,
            ZaideihIcon.artist,
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
        strutStyle: StrutStyle(
          height: 1.0
        ),
        text: new TextSpan(
          text: name,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
            height: 1.3
          ),
          children: <TextSpan>[
            if (aka.isNotEmpty)new TextSpan(
              text: ' ($aka)',
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                height: 1.3
              ),
            )
          ]
        ),
      ),
      // subtitle: RichText(
      //   // textAlign: TextAlign.center,
      //   strutStyle: StrutStyle(
      //     height: 1.0
      //   ),
      //   text: new TextSpan(
      //     text: artist.track.toString(),
      //     style: Theme.of(context).textTheme.subtitle1!.copyWith(
      //       height: 1.3
      //     ),
      //     children: <TextSpan>[
      //       new TextSpan(
      //         text: artist.album.toString(),
      //         // style: Theme.of(context).textTheme.subtitle2!.copyWith(
      //         //   height: 1.3
      //         // ),
      //       )
      //     ]
      //   ),
      // ),
      subtitle: Row(
        children: [
          // Icon(ZaideihIcon.listen),
          // Icon(ZaideihIcon.time),
          // Icon(ZaideihIcon.music),
          // Icon(ZaideihIcon.album),
          badage(context, ZaideihIcon.time,cache.duration(artist.duration)),
          badage(context, ZaideihIcon.music,artist.track.toString()),
          badage(context, ZaideihIcon.album,artist.album.toString())
        ],
      ),
      trailing: Text(intl.NumberFormat.compact().format(plays),
        strutStyle: const StrutStyle(
          height: 1.5
        ),
      ),
      onTap: ()=> core.navigate(to: '/artist/id',args:artist, routePush: false)
    );
  }

  Widget badage(BuildContext context, IconData icon, String label, ){
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
        Icon(icon,size: 14, color: Theme.of(context).textTheme.caption!.color!.withOpacity(0.2),),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text(label,
            strutStyle: const StrutStyle(
              height: 1.2
            ),
          ),
        ),
      ],
    );
  }
}

class ArtistListItemHolder extends StatelessWidget {
  const ArtistListItemHolder({ Key? key }) : super(key: key);

  Widget build(BuildContext context) {
    return const ListTile(
      minVerticalPadding: 0,
      leading: const DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFe6e7e8),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: const Padding(
          padding: const EdgeInsets.all(7.0),
          child: Icon(
            ZaideihIcon.artist,
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
        height: 10.0,
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

class ArtistWrapItem extends StatelessWidget {
  const ArtistWrapItem({ Key? key, required this.core, required this.artist,this.routePush:true }) : super(key: key);

  final Core core;
  final AudioArtistType artist;
  final bool routePush;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      key: key,
      child: Text(artist.name,
        // style: TextStyle(fontSize:15, height: 1, color: Colors.black),
        style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize:15, height: 1),
        strutStyle: const StrutStyle(
          height: 1.3
        ),
      ),
      // color: Theme.of(context).buttonColor,
      // color: Theme.of(context).backgroundColor,
      // color: Theme.of(context).primaryColor.withOpacity(0.3),
      // color: Theme.of(context).chipTheme.backgroundColor,
      // color: Theme.of(context).backgroundColor,
      // color: Theme.of(context).buttonColor,
      color: Theme.of(context).shadowColor,
      // color: Theme.of(context).primaryColor.withOpacity(0.3),
      // color: Theme.of(context).bottomAppBarColor,//.withOpacity(0.5),
      borderRadius: const BorderRadius.all(Radius.circular(100.0)),
      padding: const EdgeInsets.symmetric(vertical:3, horizontal:17),
      minSize:35,
      // onPressed: ()=>core.navigate(to: '/artist/id',args: {"a":"true"})
      onPressed: ()=>core.navigate(to: '/artist/id',args:artist, routePush: routePush)
    );
  }
}

class ArtistWrapMore extends StatelessWidget {
  const ArtistWrapMore({ Key? key, this.more:'* / ?', this.total:0, this.count:0, this.onPressed }) : super(key: key);

  final String more;
  final int total;
  final int count;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      key: key,
      child: Text(
        more.replaceFirst('*', count.toString()).replaceFirst('?', total.toString()),
        style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize:15, height: 1),
        strutStyle: const StrutStyle(
          height: 1.3
        ),
      ),
      color: Theme.of(context).shadowColor,
      borderRadius: const BorderRadius.all(Radius.circular(100.0)),
      padding: const EdgeInsets.symmetric(vertical:3, horizontal:17),
      minSize:35,
      onPressed: onPressed
    );
  }
}