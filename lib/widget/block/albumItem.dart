part of 'album.dart';

const genreColorList = [
  Color(0xFFd9dadb),
  Colors.grey,
  Color(0xFFfff0de), //gospel
  Color(0xFFe6e6e6), //classical
  Color(0xFFb0b0b0), //alternative
  Color(0xFFccffff), //christian
  Color(0xFFf3f3d4), //country
  Color(0xFFededc0), //pop
  Color(0xFF007FFF), //tribal
  Color(0xFFfdfdf8), //classic
  Color(0xFFc8e6c9),
  Color(0xFFef5f9e),
  Color(0xFFfff8e1),
  Color(0xFFe0f7fa),
  Color(0xFFede7f8),
  Color(0xFFfff3e0),
];

class AlbumListItem extends StatelessWidget {
  const AlbumListItem({Key? key, required this.core, required this.album,}): super(key: key);

  final Core core;
  final AudioAlbumType album;

  AudioBucketType get cache => core.collection.cacheBucket;

  Audio  get audio => core.audio;
  String get name => album.name;
  // String get genre => album.genre.join(',');
  String get genre => cache.genreList(album.genre).map((e) => e.name).join(', ');
  String get track => album.track.toString();
  String get year => album.year.join(', ');
  String get duration => cache.duration(album.duration);
  String get artists => cache.trackByUid([album.uid]).map((e) => e.artists).expand((e) => e).toSet().map((e) => cache.artistById(e).name).join(', ');

  Color get genreColor => album.genre.length > 0 && genreColorList.length > album.genre.first? genreColorList[album.genre.first]:Colors.grey;

  void play(){
    audio.queuefromAlbum([album.uid]);
  }

  void navigate(){
    core.navigate(to: '/album/id', args: album);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0,0),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  clipBehavior:Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: buttonArt(context)
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0,-1),
            child: Container(
              height: 100,
              alignment: const Alignment(0,0),
              child: buttonTitle(context)
            ),
          ),
        ],
      )
    );
  }

  Widget buttonArt(BuildContext context) {

    return TextButton(
      child: Stack(
        alignment: const Alignment(0,0),
        children: [
          Align(
            alignment: const Alignment(0,0),
            child: Icon(ZaideihIcon.cd,
              size: 75,//95
              color: genreColor.withAlpha(255)
            )
          ),
          Align(
            // alignment: const Alignment(.035,-.01),
            alignment: const Alignment(.07,.0),
            child: Container(
              child: Icon(ZaideihIcon.play,
                size: 40,
                color: Theme.of(context).shadowColor,
              ),
            )
          ),
          Align(
            alignment: const Alignment(0,-1),
            child: Text(year,style: Theme.of(context).textTheme.headline4)
          ),
          Align(
            alignment: const Alignment(-1,1),
            child: Text(duration, style: Theme.of(context).textTheme.bodyText2),
          ),
          Align(
            alignment: const Alignment(1,1),
            child: Text(track, style: Theme.of(context).textTheme.bodyText2),
          ),
        ]
      ),
      onPressed: play
    );
  }

  Widget buttonTitle(BuildContext context) {
    return Tooltip(
      message: name,
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 15),
          padding: const EdgeInsets.symmetric(horizontal:0, vertical: 0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(name,
              textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1!.copyWith( fontWeight: FontWeight.normal),
              strutStyle: const StrutStyle(
                height: 1.6
              ),
            ),
            // Text(genre, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2),
            Text(artists,
              textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline5!.copyWith( fontWeight: FontWeight.normal, height: 1.3),
              strutStyle: const StrutStyle(
                height: 1.3
              ),
            )
          ],
        ),
        onPressed: navigate
      ),
    );
  }
}

class AlbumListItemHolder extends StatelessWidget {
  const AlbumListItemHolder({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0,0),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  clipBehavior:Clip.hardEdge,
                  decoration: const BoxDecoration(
                    color: const Color(0xFFe6e7e8),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Stack(
                    alignment: const Alignment(0,0),
                    children: [
                      const Align(
                        alignment: const Alignment(0,0),
                        child: const Icon(ZaideihIcon.cd,
                          size: 75,
                          color: const Color(0xFFd9dadb),
                        )
                      ),
                    ]
                  )
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0,-1),
            child: Container(
              height: 100,
              alignment: const Alignment(0,0),
              child: buttonTitle(context)
            ),
          ),
        ],
      )
    );
  }

  Widget buttonTitle(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // const DecoratedBox(
        //   decoration: const BoxDecoration(
        //     color: const Color(0xFFe6e7e8),
        //     borderRadius: const BorderRadius.all(Radius.circular(100)),
        //   ),
        //   // child: buttonArt(context)
        //   child: Text('')
        // ),
        Container(
          width: double.infinity,
          height: 21,
          decoration: const BoxDecoration(
            color: const Color(0xFFe6e7e8),
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
        ),
        Container(
          width: double.infinity,
          height: 18,
          decoration: const BoxDecoration(
            color: const Color(0xFFe6e7e8),
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
        )
      ],
    );
  }

}

class AlbumPickItem extends StatelessWidget {
  const AlbumPickItem({Key? key, required this.core, required this.album,}): super(key: key);

  final Core core;
  final AudioAlbumType album;

  AudioBucketType get cache => core.collection.cacheBucket;

  Audio  get audio => core.audio;
  String get name => album.name;
  // String get genre => album.genre.join(',');
  String get genre => cache.genreList(album.genre).map((e) => e.name).join(', ');
  String get track => album.track.toString();
  String get year => album.year.join(', ');
  String get duration => cache.duration(album.duration);

  Color get genreColor => album.genre.length > 0 && genreColorList.length > album.genre.first? genreColorList[album.genre.first]:Colors.grey;

  void play(){
    audio.queuefromAlbum([album.uid]);
  }

  void navigate(){
    core.navigate(to: '/album/id', args: album);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      clipBehavior:Clip.hardEdge,
      margin: const EdgeInsets.all(3),
      width: 170,
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColor.withOpacity(0.3),
        // color: Theme.of(context).chipTheme.backgroundColor,
        // color: Theme.of(context).backgroundColor,
        // color: Theme.of(context).buttonColor,
        color: Theme.of(context).shadowColor,
        borderRadius: const BorderRadius.all(const Radius.circular(5)),
        // boxShadow: [
        //   BoxShadow(
        //     // color: Theme.of(context).shadowColor,
        //     color: Colors.grey.shade600,
        //     blurRadius: 0.0,
        //     spreadRadius: 0.1,
        //     offset: Offset(0, .1)
        //   )
        // ]
      ),

      child: Stack(
        alignment: Alignment.topCenter,
        // fit: StackFit.loose,
        children: [
          Align(
            alignment: const Alignment(0,-.40),
            child: Icon(ZaideihIcon.cd,
              size: 95,
              color: genreColor,
            )
          ),
          Align(
            alignment: const Alignment(.034,-.22),
            child: Icon(ZaideihIcon.play,
              size: 45,
              color: Theme.of(context).shadowColor,
            )
          ),
          Container(
            height: 125,
            // width: double.infinity,
            alignment: Alignment.topCenter,
            child: buttonArt(context)
          ),


          // Align(
          //   alignment: const Alignment(0,1.0),
          //   child: Container(
          //     height: 45,
          //     // alignment: Alignment.center,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       // color: Theme.of(context).primaryColor,
          //       // color: Colors.red,
          //       border: Border(
          //         top: BorderSide(
          //           width: 3.0,
          //           color: Theme.of(context).scaffoldBackgroundColor,
          //           // color: Color(0XFFfff0de)
          //         ),
          //       ),
          //     ),
          //     child: buttonTitle(context)
          //   ),
          // ),
          Align(
            alignment: const Alignment(0,1.0),
            child: SizedBox(
              height: 40.0,
              width: double.infinity,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  border: const Border(
                    top: const BorderSide(
                      width: 3.0,
                      // color: Theme.of(context).scaffoldBackgroundColor,
                      color: const Color(0XFFfff0de)
                    ),
                  ),
                ),
                child: buttonTitle(context)
              ),
            )
          ),
        ],
      )
    );
  }

  Widget buttonArt(BuildContext context) {
    return TextButton(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: const Alignment(0,-1),
            child: Text(genre, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2)
          ),
          Align(
            alignment: const Alignment(0,.7),
            child: Text(year)
          ),
          Align(
            alignment: const Alignment(-1,1),
            child: Text(duration, style: Theme.of(context).textTheme.bodyText2),
          ),
          Align(
            alignment: const Alignment(1,1),
            child: Text(track, style: Theme.of(context).textTheme.bodyText2),
          ),
        ]
      ),
      onPressed: play
    );
  }

  Widget buttonTitle(BuildContext context) {
    return Tooltip(
      message: name,
      child: TextButton(
        style: TextButton.styleFrom(
          alignment: const Alignment(0,0),
          textStyle: const TextStyle(fontSize: 15),
          padding: const EdgeInsets.symmetric(horizontal: 7)
          // backgroundColor: Colors.blue
        ),
        child: Text(name,
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline5!.copyWith( fontWeight: FontWeight.normal),
          strutStyle: const StrutStyle(
            height: 1.5
          ),
        ),
        onPressed: navigate
      ),
    );
  }
}

class AlbumPickItemHolder extends StatelessWidget {
  const AlbumPickItemHolder({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const SizedBox(
    //   height: 18.0,
    //   child: const DecoratedBox(
    //     decoration: const BoxDecoration(
    //       color: const Color(0xFFe6e7e8),
    //       borderRadius: const BorderRadius.all(Radius.circular(100)),
    //     ),
    //     child: Stack(
    //       children: [],
    //     ),
    //   ),
    // );
    return Container(
      // clipBehavior:Clip.hardEdge,
      margin: const EdgeInsets.all(3),
      width: 170,
      decoration: const BoxDecoration(
        color: const Color(0xFFe6e7e8),
        borderRadius: const BorderRadius.all(const Radius.circular(5)),
      ),

      child: Stack(
        alignment: Alignment.topCenter,
        // fit: StackFit.loose,
        children: [
          const Align(
            alignment: const Alignment(0,-.40),
            child: Icon(ZaideihIcon.cd,
              size: 95,
              color: const Color(0xFFd9dadb),
            )
          ),
          const Align(
            alignment: const Alignment(.035,-.21),
            child: Icon(ZaideihIcon.play,
              size: 30,
              color: const Color(0xFFe6e7e8),
            )
          ),
          // Align(
          //   alignment: const Alignment(0,1.0),
          //   child: Container(
          //     height: 45,
          //     // alignment: Alignment.center,
          //     width: double.infinity,
          //     decoration: const BoxDecoration(
          //       border: const Border(
          //         top: const BorderSide(
          //           width: 3.0,
          //           // color: Theme.of(context).scaffoldBackgroundColor,
          //           color: const Color(0XFFfff0de)
          //         ),
          //       ),
          //     ),
          //     child: buttonTitle()
          //   ),
          // ),
          const Align(
            alignment: const Alignment(0,1.0),
            child: const SizedBox(
              height: 40.0,
              width: double.infinity,
              child: const DecoratedBox(
                decoration: const BoxDecoration(
                  border: const Border(
                    top: const BorderSide(
                      width: 3.0,
                      // color: Theme.of(context).scaffoldBackgroundColor,
                      color: const Color(0XFFfff0de)
                    ),
                  ),
                ),
                // child: Text(''),
              ),
            )
          ),
        ],
      )
    );
  }

}