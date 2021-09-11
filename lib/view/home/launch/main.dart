import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';

// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_example/common.dart';
// import 'package:rxdart/rxdart.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';

import 'package:music/core.dart';
import 'package:music/icon.dart';
import 'package:music/widget.dart';
import 'package:music/model.dart';

part 'bar.dart';
part 'board.dart';

class Main extends StatefulWidget {
  Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late Core core;
  final scrollController = ScrollController();

  AudioBucketType get cache => core.collection.cacheBucket;

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
    if (mounted) super.setState(fn);
  }

  // Iterable<AudioMetaType> get trackMeta => core.audio.trackMetaById([3384,3876,77,5,7,8]);
  // Iterable<int> get trackMeta => [3384,3876,77,5,7,8];
  Iterable<int> get trackMeta => cache.track.take(3).map((e) => e.id);
  Iterable<AudioLangType> get language => cache.langAvailable();
  // Iterable<AudioArtistType> artistPopularByLang(int id) => cache.artistPopularByLang(id);
  Iterable<int> artistPopularByLang(int id) => cache.artistPopularByLang(id);
  Iterable<AudioAlbumType> get albumPopular => cache.album.take(17);
}

class _View extends _State with _Bar, _Board {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      key: widget.key,
      // controller: scrollController,
      child: scroll()
    );
  }

  Widget scroll() {
    return CustomScrollView(
      // primary: true,
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      semanticChildCount: 2,
      slivers: <Widget>[
        bar(),
        board(),
        // _tmpWorking(),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Text('Personalized experience and more...', textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1,)
            )
          ),
        ),

        TrackFlat(tracks: trackMeta, label: 'Most play track (?)'),

        AlbumFlat(core: core, album: albumPopular, label: 'Most play album (?)',),

        ArtistWrap(
          artists:artistPopularByLang(language.elementAt(0).id),
          // artists:[],
          routePush: false,
          heading: language.elementAt(0).name.toUpperCase(),
        ),
        ArtistWrap(
          artists:artistPopularByLang(language.elementAt(1).id),
          // artists:[],
          routePush: false,
          heading: language.elementAt(1).name.toUpperCase(),
        ),
        ArtistWrap(
          artists:artistPopularByLang(language.elementAt(2).id),
          // artists:[],
          routePush: false,
          heading: language.elementAt(2).name.toUpperCase(),
        ),
        ArtistWrap(
          artists:artistPopularByLang(language.elementAt(3).id),
          // artists:[],
          routePush: false,
          heading: language.elementAt(3).name.toUpperCase(),
        ),
      ]
    );
  }

  // Widget langBlock(){
  //   return new SliverList(
  //     delegate: SliverChildBuilderDelegate(
  //       // (BuildContext context, int index) => artistBlock(language.elementAt(index)),
  //       (BuildContext context, int index) => ArtistWrap(
  //         artists:artistPopularByLang(language.elementAt(index).id),
  //         // artists:[],
  //         routePush: false,
  //         heading: language.elementAt(index).name.toUpperCase(),
  //       ),
  //       childCount: language.length
  //     )
  //   );
  // }

  // Widget _tmpWorking(){
  //   return SliverList(
  //     delegate: SliverChildListDelegate(
  //       [
  //         TextButton(
  //           // color: Colors.transparent,
  //           // splashColor: Colors.black26,
  //           onPressed: () {
  //             print('TextButton');
  //           },
  //           child: Text('TextButton'),
  //         ),
  //         OutlinedButton(
  //           onPressed: () {
  //             print('Received click');
  //           },
  //           child: const Text('Click Me'),
  //         ),
  //         // RaisedButton(
  //         //   // color: Colors.transparent,
  //         //   // splashColor: Colors.black26,
  //         //   onPressed: () {
  //         //     print('done');
  //         //   },
  //         //   child: Text('Click Me!'),
  //         // ),
  //         WidgetButton(
  //           child: Text('Popular Artists'),
  //           onPressed: () => core.audio.testPopularArtist()
  //         ),
  //         WidgetButton(
  //           child: Text('Popular Albums'),
  //           onPressed: () => core.audio.testPopularAlbum()
  //         ),
  //         WidgetButton(
  //           child: Text('Popular Track'),
  //           onPressed: () => core.audio.testPopularTrack()
  //         ),
  //         WidgetButton(
  //           child: Text('Language block'),
  //           onPressed: () => core.audio.testLanguageBlock()
  //         ),
  //         WidgetButton(
  //           child: Text('Popular Artists Language'),
  //           onPressed: () => core.audio.testPopularArtistLang()
  //         ),
  //       ]
  //     )
  //   );
  // }

  Widget tmpList(int count){
    return new SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('$index'),
            ),
          );
        },
        childCount: count
      )
    );
  }
}
