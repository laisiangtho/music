part of 'main.dart';

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
  final BuildContext context;
  final AudioAlbumType album;

  const AlbumListItem({
    Key? key,
    required this.context,
    required this.album,
  }) : super(key: key);

  Core get core => context.read<Core>();
  AudioBucketType get cache => core.collection.cacheBucket;

  Audio get audio => core.audio;
  String get name => album.name;
  // String get genre => album.genre.join(',');
  String get genre => cache.genreList(album.genre).map((e) => e.name).join(', ');
  String get track => album.track.toString();
  String get year => album.year.join(', ');
  String get duration => cache.duration(album.duration);
  String get artists => cache
      .trackByUid([album.uid])
      .map((e) => e.artists)
      .expand((e) => e)
      .toSet()
      .map((e) => cache.artistById(e).name)
      .join(', ');

  Color get genreColor => album.genre.isNotEmpty && genreColorList.length > album.genre.first
      ? genreColorList[album.genre.first]
      : Colors.grey;

  void play() {
    audio.queuefromAlbum([album.uid]);
  }

  void navigate() {
    core.navigate(to: '/album-info', args: album);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, 0),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: buttonArt(context),
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, -1),
            child: Container(
              height: 100,
              alignment: const Alignment(0, 0),
              child: buttonTitle(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonArt(BuildContext context) {
    return TextButton(
      child: Stack(
        alignment: const Alignment(0, 0),
        children: [
          Align(
            alignment: const Alignment(0, 0),
            child: Icon(
              LideaIcon.cd,
              size: 75, //95
              color: genreColor.withAlpha(255),
            ),
          ),
          Align(
            // alignment: const Alignment(.035,-.01),
            alignment: const Alignment(.0, .0),
            child: Icon(
              Icons.play_arrow_rounded,
              size: 45,
              color: Theme.of(context).shadowColor,
            ),
          ),
          Align(
            alignment: const Alignment(0, -1),
            child: Text(
              year,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontSize: 18,
                    fontFamily: 'Lato',
                  ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.8, 0.9),
            child: Text(
              duration,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
            ),
          ),
          Align(
            alignment: const Alignment(0.86, 0.9),
            child: Text(
              track,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
            ),
          ),
        ],
      ),
      onPressed: play,
    );
  }

  Widget buttonTitle(BuildContext context) {
    return Tooltip(
      message: name,
      child: TextButton(
        style: TextButton.styleFrom(
          // textStyle: const TextStyle(fontSize: 15),
          textStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                // fontSize: 16,
                fontFamily: 'Lato',
                fontWeight: FontWeight.normal,
              ),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              // style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.normal),
              // strutStyle: const StrutStyle(height: 1.6),
            ),
            // Text(genre, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2),
            Text(
              artists,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
              // style: Theme.of(context)
              //     .textTheme
              //     .headline5!
              //     .copyWith(fontWeight: FontWeight.normal, height: 1.3),
              // // strutStyle: const StrutStyle(height: 1.3),
            )
          ],
        ),
        onPressed: navigate,
      ),
    );
  }
}

class AlbumListItemHolder extends StatelessWidget {
  const AlbumListItemHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, 0),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    color: Color(0xFFe6e7e8),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Stack(
                    alignment: const Alignment(0, 0),
                    children: const [
                      Align(
                        alignment: Alignment(0, 0),
                        child: Icon(
                          LideaIcon.cd,
                          size: 75,
                          color: Color(0xFFd9dadb),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, -1),
            child: Container(
              height: 100,
              alignment: const Alignment(0, 0),
              child: buttonTitle(context),
            ),
          ),
        ],
      ),
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
            color: Color(0xFFe6e7e8),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
        ),
        Container(
          width: double.infinity,
          height: 18,
          decoration: const BoxDecoration(
            color: Color(0xFFe6e7e8),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
        )
      ],
    );
  }
}

class AlbumPickItem extends StatelessWidget {
  const AlbumPickItem({
    Key? key,
    required this.context,
    required this.album,
  }) : super(key: key);

  final BuildContext context;
  final AudioAlbumType album;

  Core get core => context.read<Core>();

  AudioBucketType get cache => core.collection.cacheBucket;
  Audio get audio => core.audio;
  String get name => album.name;
  // String get genre => album.genre.join(',');
  String get genre => cache.genreList(album.genre).map((e) => e.name).join(', ');
  String get track => album.track.toString();
  String get year => album.year.join(', ');
  String get duration => cache.duration(album.duration);

  Color get genreColor => album.genre.isNotEmpty && genreColorList.length > album.genre.first
      ? genreColorList[album.genre.first]
      : Colors.grey;

  void play() {
    audio.queuefromAlbum([album.uid]);
  }

  void navigate() {
    core.navigate(to: '/album-info', args: album);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: SizedBox(
        width: 170,
        // height: 170,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            // fit: StackFit.loose,
            children: [
              Align(
                alignment: const Alignment(0, -.38),
                child: SizedBox(
                  child: Icon(
                    LideaIcon.cd,
                    size: 100,
                    color: genreColor,
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, -.23),
                child: SizedBox(
                  child: Icon(
                    // LideaIcon.play,
                    Icons.play_arrow_rounded,
                    size: 60,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment(0, 1.0),
              //   child: Text('?'),
              // ),
              Container(
                height: 125,
                // width: double.infinity,
                alignment: Alignment.topCenter,
                child: buttonArt(context),
              ),
              Align(
                // alignment: Alignment(0, 1.0),
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 40.0,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 3.0,
                          // color: Theme.of(context).scaffoldBackgroundColor,
                          color: Color(0XFFfff0de),
                        ),
                      ),
                    ),
                    child: buttonTitle(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonArt(BuildContext context) {
    return TextButton(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Align(
          //   alignment: const Alignment(0, -1),
          //   child: Text(
          //     genre,
          //     textAlign: TextAlign.center,
          //     // style: Theme.of(context).textTheme.bodyText2,
          //     style: Theme.of(context).textTheme.headline5!.copyWith(
          //           fontSize: 17,
          //           fontFamily: 'Lato',
          //         ),
          //   ),
          // ),
          Align(
            alignment: const Alignment(0, -1),
            child: Text(
              year,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 17,
                    fontFamily: 'Lato',
                  ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.9, 1),
            child: Text(
              duration,
              // style: Theme.of(context).textTheme.bodyText2,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontSize: 14,
                    fontFamily: 'Lato',
                  ),
            ),
          ),
          Align(
            alignment: const Alignment(0.9, 1),
            child: Text(
              '#$track',
              // style: Theme.of(context).textTheme.bodyText2,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontSize: 17,
                    fontFamily: 'Lato',
                  ),
            ),
          ),
        ],
      ),
      onPressed: play,
    );
  }

  Widget buttonTitle(BuildContext context) {
    return WidgetButton(
      child: WidgetLabel(
        label: name,
        message: name,
        labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        labelStyle: Theme.of(context).textTheme.bodyText1,
      ),
      onPressed: navigate,
    );
  }
}

class AlbumPickItemHolder extends StatelessWidget {
  const AlbumPickItemHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: SizedBox(
        width: 170,
        // height: 170,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            // fit: StackFit.loose,
            children: const [
              Align(
                alignment: Alignment(0, -.38),
                child: SizedBox(
                  child: Icon(
                    LideaIcon.cd,
                    size: 100,
                    color: Color(0xFFd9dadb),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -.25),
                child: SizedBox(
                  child: Icon(
                    // LideaIcon.play,
                    Icons.play_arrow_rounded,
                    size: 55,
                    color: Color(0xFFe6e7e8),
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment(0, 1.0),
              //   child: Text('?'),
              // ),
              Align(
                // alignment: Alignment(0, 1.0),
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 40.0,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 3.0,
                          // color: Theme.of(context).scaffoldBackgroundColor,
                          color: Color(0XFFfff0de),
                        ),
                      ),
                    ),
                    // child: Text(''),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   // clipBehavior:Clip.hardEdge,
    //   margin: const EdgeInsets.all(3),
    //   width: 170,
    //   decoration: const BoxDecoration(
    //     color: Color(0xFFe6e7e8),
    //     borderRadius: BorderRadius.all(Radius.circular(5)),
    //   ),
    //   child:
    // );
  }
}
