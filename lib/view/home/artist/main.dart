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
// import 'package:music/icon.dart';
import 'package:music/widget.dart';
import 'package:music/model.dart';

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
  late Iterable<AudioArtistType> artist;
  // final GlobalKey<State> key = GlobalKey<ScaffoldState>();
  // final UniqueKey key = UniqueKey();

  // late AnimationController animationController;
  // late Animation animation;
  // late Animation<AlignmentGeometryTween> alignAnimation;

  AudioBucketType get cache => core.collection.cacheBucket;

  Iterable<AudioArtistType> get artistAll => cache.artist;

  List<String> get charFilter => core.artistFilterCharList;
  List<int> get langFilter => core.artistFilterLangList;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    core = context.read<Core>();
    // Future.microtask((){});

    // animationController = AnimationController(
    //   duration: Duration(seconds: 1),
    //   vsync: this,
    // );

    // animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);
    // alignAnimation = AlignmentGeometryTween(begin: Alignment.bottomCenter, end: Alignment.center).animate(animationController);

    // animationController.forward();

    artistInit();
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

  void artistInit() {
    artist = this.artistFilter();
  }

  Iterable<AudioArtistType> artistFilter() => artistAll.where(
    // (e) => charFilter.length > 0?charFilter.contains(e.name[0]):true
    (e) => charFilter.length > 0?e.name.length == 0?charFilter.contains('#'):charFilter.contains(e.name[0]):true
  ).where(
    (e) => langFilter.length > 0?e.lang.where((i) => langFilter.contains(i)).length > 0:true
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
        ArtistList(artists: artist, controller: scrollController)
        // FutureBuilder(
        //   future: Future.delayed(const Duration(milliseconds: 285), ()=>true),
        //   builder: (_, snap){
        //     if (snap.hasData){
        //       return ArtistList(key: UniqueKey(), artists: artist, controller: scrollController);
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
