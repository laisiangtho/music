
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
import 'package:music/model.dart';
import 'package:music/widget.dart';

part 'bar.dart';
part 'modal.dart';

class Main extends StatefulWidget {
  Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late Core core;
  late ScrollController scrollController;
  // final scrollController = ScrollController();
  late Iterable<AudioAlbumType> album;
  // final GlobalKey<State> key = GlobalKey<ScaffoldState>();
  // final UniqueKey key = UniqueKey();

  AudioBucketType get cache => core.collection.cacheBucket;

  Iterable<AudioAlbumType> get albumAll => cache.album;

  late List<String> charList;
  List<String> get charFilter => core.albumFilterCharList;
  List<int> get langFilter => core.albumFilterLangList;
  List<int> get genreFilter => core.albumFilterGenreList;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    core = context.read<Core>();
    // Future.microtask((){});
    albumInit();
  }

  @override
  dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  void albumInit() {
    album = this.albumFilter();
  }

  Iterable<AudioAlbumType> albumFilter() => albumAll.where(
    (e) => charFilter.length > 0?e.name.length == 0?charFilter.contains('#'):charFilter.contains(e.name[0]):true
  ).where(
    (e) => langFilter.length > 0?langFilter.contains(e.lang):true
  ).where(
    (e) => genreFilter.length > 0?e.genre.where((i) => genreFilter.contains(i)).length > 0:true
  );
}

class _View extends _State with _Bar{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      body: ViewPage(
        // controller: scrollController,
        child: body()
      ),
    );
  }

  CustomScrollView body(){
    return CustomScrollView(
      // primary: true,
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: const AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        bar(),
        AlbumList(albums: album, controller: scrollController)
        // FutureBuilder(
        //   future: Future.delayed(const Duration(milliseconds: 285), ()=>true),
        //   builder: (_, snap){
        //     if (snap.hasData){
        //       return AlbumList(albums: album, controller: scrollController);
        //     }
        //     return SliverFillRemaining(
        //       child: Center(
        //         child: Icon(Icons.more_horiz_outlined),
        //       ),
        //     );
        //   }
        // )
      ]
    );
  }

}
