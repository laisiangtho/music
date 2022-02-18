import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

import 'package:lidea/intl.dart' as intl;
import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.navigatorKey, this.arguments}) : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final Object? arguments;

  static const route = '/album-info';
  static const icon = Icons.article;
  static const name = 'Album';
  static const description = '...';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

  late final Core core = context.read<Core>();

  late final ViewNavigationArguments arguments = widget.arguments as ViewNavigationArguments;
  late final bool canPop = widget.arguments != null;
  // late final ViewNavigationArguments arguments = widget.arguments as ViewNavigationArguments;
  // late final bool canPop = widget.arguments != null;
  // ViewNavigationArguments get arguments => widget.arguments as ViewNavigationArguments;
  AudioAlbumType get album => arguments.args as AudioAlbumType;

  // SettingsController get settings => context.read<SettingsController>();
  // AppLocalizations get translate => AppLocalizations.of(context)!;
  // Authentication get authenticate => context.read<Authentication>();
  Preference get preference => core.preference;

  AudioBucketType get cache => core.collection.cacheBucket;
  Audio get audio => core.audio;

  String get albumId => album.uid;
  String get albumName => album.name;
  int get albumPlaysCount => album.plays;
  String get albumDuration => cache.duration(album.duration);
  String get albumTrackCount => album.track.toString();
  List<String> get albumGenre => cache.genreList(album.genre).map((e) => e.name).toList();
  List<String> get albumYear => album.year;

  Iterable<AudioMetaType> get albumTrack => audio.metaByUd([albumId]);

  Iterable<int> get albumArtists =>
      albumTrack.map((e) => e.trackInfo.artists).expand((i) => i).toSet();
  // Iterable<AudioArtistType> get albumArtists => albumTrack.map(
  //   (e) => e.trackInfo.artists
  // ).expand((i) => i).toSet().map(
  //   (id) => cache.artistById(id)
  // );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // void onClear() {
  //   Future.microtask(() {});
  // }

  void onSearch(String word) {}

  void onDelete(String word) {
    Future.delayed(Duration.zero, () {});
  }
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: widget.key,
      body: ViewPage(
        // controller: scrollController,
        child: body(),
      ),
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StaticBadgeAttribute(
                      icon: LideaIcon.listen,
                      // label: albumPlaysCount,
                      label: intl.NumberFormat.compact().format(albumPlaysCount),
                    ),
                    StaticBadgeAttribute(
                      icon: LideaIcon.time,
                      label: albumDuration,
                    ),
                    StaticBadgeAttribute(
                      icon: LideaIcon.music,
                      label: albumTrackCount,
                    ),
                  ],
                ),
                TitleAttribute(text: albumName),
                YearWrap(year: albumYear),
                PlayAllAttribute(
                  onPressed: () => core.audio.queuefromAlbum([albumId]),
                ),
                GenreWrap(
                  genre: albumGenre,
                ),
              ],
            ),
          ),
        ),
        ArtistWrap(
          artists: albumArtists,
        ),
        TrackList(
          // key: UniqueKey(),
          tracks: albumTrack,
        ),
        Selector<ViewScrollNotify, double>(
          selector: (_, e) => e.bottomPadding,
          builder: (context, bottomPadding, child) {
            return SliverPadding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              sliver: child,
            );
          },
        ),
      ],
    );
  }
}
