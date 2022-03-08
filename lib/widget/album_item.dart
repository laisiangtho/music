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
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
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
                  child: buttonArt(),
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, -1),
            child: Container(
              height: 100,
              alignment: const Alignment(0, 0),
              child: buttonTitle(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonArt() {
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
            alignment: const Alignment(0, -0.95),
            child: Text(
              year,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.8, 0.95),
            child: Text(
              duration,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: Theme.of(context).focusColor,
                  ),
            ),
          ),
          Align(
            alignment: const Alignment(0.86, 0.95),
            child: Text(
              track,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: Theme.of(context).focusColor,
                  ),
            ),
          ),
        ],
      ),
      onPressed: play,
    );
  }

  Widget buttonTitle() {
    return Tooltip(
      message: name,
      child: TextButton(
        style: TextButton.styleFrom(
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
            ),
            Text(
              artists,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
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
                  decoration: BoxDecoration(
                    // color: Color(0xFFe6e7e8),
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Stack(
                    alignment: const Alignment(0, 0),
                    children: [
                      Align(
                        alignment: const Alignment(0, 0),
                        child: Icon(
                          LideaIcon.cd,
                          size: 75,
                          color: Theme.of(context).shadowColor,
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
        Container(
          width: double.infinity,
          height: 25,
          decoration: BoxDecoration(
            // color: Color(0xFFe6e7e8),
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
        ),
        Container(
          width: double.infinity,
          height: 15,
          decoration: BoxDecoration(
            // color: Color(0xFFe6e7e8),
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
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
                alignment: const Alignment(0, -.40),
                child: SizedBox(
                  child: Icon(
                    LideaIcon.cd,
                    size: 100,
                    color: genreColor,
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, -.27),
                child: SizedBox(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 60,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ),
              Container(
                height: 125,
                alignment: Alignment.topCenter,
                child: buttonArt(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 56.0,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 3.0,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                    child: buttonTitle(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonArt() {
    return TextButton(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: const Alignment(0, -0.9),
            child: Text(
              year,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.9, 1.35),
            child: Text(
              duration,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: Theme.of(context).focusColor,
                  ),
            ),
          ),
          Align(
            alignment: const Alignment(0.9, 1.35),
            child: Text(
              '#$track',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: Theme.of(context).focusColor,
                  ),
            ),
          ),
        ],
      ),
      onPressed: play,
    );
  }

  Widget buttonTitle() {
    return WidgetButton(
      child: WidgetLabel(
        message: name,
        label: name,
        labelStyle: Theme.of(context).textTheme.labelLarge,
        labelPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
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
                alignment: const Alignment(0, -.40),
                child: SizedBox(
                  child: Icon(
                    LideaIcon.cd,
                    size: 100,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, -.27),
                child: SizedBox(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 60,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 3.0,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
