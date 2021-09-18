import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';

import 'package:music/core.dart';
import 'package:music/icon.dart';
import 'package:music/model.dart';
import 'package:music/widget.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late Core core;
  final scrollController = ScrollController();
  final GlobalKey<State> key = GlobalKey<ScaffoldState>();

  // AudioAlbumType get album => widget.arguments as AudioAlbumType;
  NavigatorArguments get arguments => widget.arguments as NavigatorArguments;
  AudioAlbumType get album => arguments.meta as AudioAlbumType;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
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

  String get albumId => album.uid;
  String get albumName => album.name;
  String get albumPlaysCount => album.plays.toString();
  String get albumDuration => cache.duration(album.duration);
  String get albumTrackCount => album.track.toString();
  List<String> get albumGenre => cache.genreList(album.genre).map((e) => e.name).toList();
  List<String> get albumYear => album.year;

  Iterable<AudioMetaType> get albumTrack => audio.trackMetaByUd([albumId]);

  Iterable<int> get albumArtists => albumTrack.map(
    (e) => e.trackInfo.artists
  ).expand((i) => i).toSet();
  // Iterable<AudioArtistType> get albumArtists => albumTrack.map(
  //   (e) => e.trackInfo.artists
  // ).expand((i) => i).toSet().map(
  //   (id) => cache.artistById(id)
  // );

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
    return CustomScrollView(
      primary: true,
      // controller: scrollController,
      physics: const BouncingScrollPhysics(parent: const AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        bar(),

        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StaticBadgeAttribute(icon:ZaideihIcon.listen,label:albumPlaysCount),
                    StaticBadgeAttribute(icon:ZaideihIcon.time,label:albumDuration),
                    StaticBadgeAttribute(icon:ZaideihIcon.music,label:albumTrackCount)
                  ],
                ),
                TitleAttribute(text: albumName,),

                YearWrap(year: albumYear),

                PlayAllAttribute(
                  onPressed: () => core.audio.queuefromAlbum([albumId]),
                ),
                GenreWrap(genre: albumGenre,),
              ],
            ),
          )
        ),

        // FutureBuilder(
        //   future: Future.delayed(const Duration(milliseconds: 285), ()=>true),
        //   builder: (_, snap){
        //     if (snap.hasData){
        //       return TrackList(key: UniqueKey(), tracks: albumTrack, controller: scrollController);
        //     }
        //     return SliverFillRemaining(
        //       child: Center(
        //         child: Icon(Icons.more_horiz_outlined),
        //       ),
        //     );
        //   }
        // )
        ArtistWrap(artists:albumArtists),
        TrackList(key: UniqueKey(), tracks: albumTrack, controller: scrollController)
      ]
    );
  }

}
