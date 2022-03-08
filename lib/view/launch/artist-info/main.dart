import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

import 'package:lidea/intl.dart' as intl;
import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
// import 'package:lidea/sliver.dart';
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

  static const route = '/artist-info';
  static const icon = Icons.article;
  static const name = 'Artist';
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
  // AudioAlbumType get album => arguments.meta as AudioAlbumType;

  // SettingsController get settings => context.read<SettingsController>();
  // AppLocalizations get translate => AppLocalizations.of(context)!;
  // Authentication get authenticate => context.read<Authentication>();
  Preference get preference => core.preference;

  late final AudioArtistType artist = arguments.args as AudioArtistType;
  late final int artistId = artist.id;

  late final AudioBucketType cache = core.collection.cacheBucket;
  late final Audio audio = core.audio;

  late Iterable<AudioTrackType> track;
  late List<String> artistAlbumId;
  late Iterable<AudioAlbumType> artistAlbum;
  late List<int> artistRecommendedId;

  @override
  void initState() {
    super.initState();

    track = cache.track.where((e) => e.artists.contains(artistId));

    artistAlbumId = track.map((e) => e.uid).toSet().toList();

    artistAlbum = artistAlbumId.map((e) => cache.albumById(e));

    artistRecommendedId = track
        .where((e) => e.artists.length > 1)
        .map((e) => e.artists)
        .expand((e) => e)
        .toSet()
        .toList(); //..removeWhere((e) => e == artistId);
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

  // void onSearch(String word) {}

  // void onDelete(String word) {
  //   Future.delayed(Duration.zero, () {});
  // }
  int get artistPlaysCount => artist.plays;
  String get artistDuration => cache.duration(artist.duration);
  String get artistTrackCount => artist.track.toString();
  String get artistAlbumCount => artist.album.toString();

  // Iterable<AudioTrackType> get track => cache.track.where((e) => e.artists.contains(artistId));

  // Iterable<AudioMetaType> get artistTrack => track.map((e) => cache.meta(e.id)).take(10);
  // Iterable<AudioMetaType> get artistTrack => track.map((e) => cache.meta(e.id));
  List<int> get artistTrackIds => track.map((e) => e.id).toList();

  // List<String> get artistAlbumId => track.map((e) => e.uid).toSet().toList();

  // Iterable<AudioAlbumType> get artistAlbum => artistAlbumId.map(
  //   (e) => cache.albumById(e)
  // );

  // List<int> get artistRecommendedId => track.where(
  //   (e) => e.artists.length > 1
  // ).map((e) => e.artists).expand((e) => e).toSet().toList();//..removeWhere((e) => e == artistId);

  // Iterable<AudioArtistType> get artistRecommended => artistRecommendedId.where((e) => e != artistId).map(
  //   (e) => cache.artistById(e)
  // );
  Iterable<int> get artistRecommended => artistRecommendedId.where((e) => e != artistId);

  // Iterable<AudioArtistType> get artistRelated => cache.trackByUid(artistAlbumId).map(
  //   (e) => e.artists
  // ).map((e) => e).expand((e) => e).toSet().where(
  //   (e) => !artistRecommendedId.contains(e)
  // ).map(
  //   (e) => cache.artistById(e)
  // );
  Iterable<int> get artistRelated => cache
      .trackByUid(artistAlbumId)
      .map((e) => e.artists)
      .expand((e) => e)
      .toSet()
      .where((e) => !artistRecommendedId.contains(e));

  List<String> get artistYear =>
      artistAlbum.map((e) => e.year.where((x) => x != '')).expand((e) => e).toSet().toList()
        ..sort((a, b) => a.compareTo(b));

  void _playAll() {
    audio.queuefromTrack(track.map((e) => e.id).toList(), group: true);
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
    // Wrap();
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        bar(),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          sliver: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 150), () => true),
            builder: (_, snap) {
              if (snap.hasData) {
                return workingContainer();
              }
              return const SliverToBoxAdapter();
            },
          ),
        ),

        ArtistWrap(
          artists: artistRecommended,
          label: 'Recommeded',
          routePush: false,
          limit: 7,
        ),

        TrackFlat(
          tracks: artistTrackIds,
          label: 'Tracks (?)',
          showMore: '* / ?',
          limit: 3,
        ),

        ArtistWrap(
          artists: artistRelated,
          label: 'Related',
          routePush: false,
          limit: 5,
        ),
        // // ArtistWrap(artists: [3,9,8,12,60], heading: 'Related', limit: 5,),

        AlbumBoard(
          albums: artistAlbum,
          controller: scrollController,
        ),
        // Selector<ViewScrollNotify, double>(
        //   selector: (_, e) => e.bottomPadding,
        //   builder: (context, bottomPadding, child) {
        //     return SliverPadding(
        //       padding: EdgeInsets.only(bottom: bottomPadding),
        //       sliver: child,
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget workingContainer() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // StaticBadgeAttribute(icon: LideaIcon.listen, label: artistPlaysCount),
              StaticBadgeAttribute(
                icon: LideaIcon.listen,
                // label: albumPlaysCount,
                label: intl.NumberFormat.compact().format(artistPlaysCount),
              ),

              StaticBadgeAttribute(icon: LideaIcon.time, label: artistDuration),
              StaticBadgeAttribute(icon: LideaIcon.music, label: artistTrackCount),
              StaticBadgeAttribute(icon: LideaIcon.album, label: artistAlbumCount),
            ],
          ),
          TitleAttribute(
            text: artist.name,
            aka: artist.aka,
          ),
          YearWrap(year: artistYear),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlayAllAttribute(
                onPressed: _playAll,
              ),
              CacheWidget(
                context: context,
                trackIds: artistTrackIds,
                name: artist.name,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
