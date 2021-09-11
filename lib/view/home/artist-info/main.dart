import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';

import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
import 'package:lidea/view.dart';

import 'package:music/core.dart';
import 'package:music/icon.dart';
// import 'package:music/icon.dart';
import 'package:music/model.dart';
import 'package:music/widget.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {

  late Core core;
  final scrollController = ScrollController();
  final GlobalKey<State> key = GlobalKey<ScaffoldState>();

    // final ScreenArguments arguments;
  ScreenArguments get arguments => widget.arguments as ScreenArguments;
  AudioArtistType get artist => arguments.meta as AudioArtistType;

  late Iterable<AudioTrackType> track;
  late List<String> artistAlbumId;
  late Iterable<AudioAlbumType> artistAlbum;
  late List<int> artistRecommendedId;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();

    track = cache.track.where((e) => e.artists.contains(artistId));

    artistAlbumId = track.map((e) => e.uid).toSet().toList();

    artistAlbum = artistAlbumId.map(
      (e) => cache.albumById(e)
    );

    artistRecommendedId = track.where(
      (e) => e.artists.length > 1
    ).map((e) => e.artists).expand((e) => e).toSet().toList();//..removeWhere((e) => e == artistId);

  }

  @override
  dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  AudioBucketType get cache => core.collection.cacheBucket;
  Audio  get audio => core.audio;

  int get artistId => artist.id;
  String get artistPlaysCount => artist.plays.toString();
  String get artistDuration => cache.duration(artist.duration);
  String get artistTrackCount => artist.track.toString();
  String get artistAlbumCount => artist.album.toString();

  // Iterable<AudioTrackType> get track => cache.track.where((e) => e.artists.contains(artistId));

  // Iterable<AudioMetaType> get artistTrack => track.map((e) => cache.meta(e.id)).take(10);
  // Iterable<AudioMetaType> get artistTrack => track.map((e) => cache.meta(e.id));
  Iterable<int> get artistTrack => track.map((e) => e.id);

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
  Iterable<int> get artistRelated => cache.trackByUid(artistAlbumId).map(
    (e) => e.artists
  ).expand((e) => e).toSet().where(
    (e) => !artistRecommendedId.contains(e)
  );

  List<String> get artistYear => artistAlbum.map(
    (e) => e.year.where((x) => x != '')
  ).expand((e) => e).toSet().toList()..sort((a,b)=>a.compareTo(b));

  void playAll() {
    audio.queuefromTrack(track.map((e) => e.id).toList());
  }

  // void tmp() {}
}

class _View extends _State with _Bar{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: ViewPage(
        key: widget.key,
        // controller: scrollController,
        child: body()
      ),
    );
  }

  CustomScrollView body(){
    debugPrint('artist-info');
    return CustomScrollView(
      key: const Key('artist-info'),
      // primary: true,
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      // cacheExtent:9999999,
      slivers: <Widget>[
        bar(),

        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StaticBadgeAttribute(icon:ZaideihIcon.listen,label:artistPlaysCount),
                    StaticBadgeAttribute(icon:ZaideihIcon.time,label:artistDuration),
                    StaticBadgeAttribute(icon:ZaideihIcon.music,label:artistTrackCount),
                    StaticBadgeAttribute(icon:ZaideihIcon.album,label:artistAlbumCount),
                  ],
                ),

                TitleAttribute(text: artist.name, aka: artist.aka,),

                YearWrap(year: artistYear),

                PlayAllAttribute(
                  onPressed: playAll,
                ),
              ]
            )
          )
        ),

        ArtistWrap(artists: artistRecommended, heading: 'Recommeded', limit: 7,),

        TrackFlat(tracks: artistTrack, label: 'Tracks (?)', showMore: '* / ?', limit: 3,),

        ArtistWrap(artists: artistRelated, heading: 'Related', limit: 5,),

        AlbumBoard(albums: artistAlbum, controller: scrollController,)
      ]
    );
  }

}
