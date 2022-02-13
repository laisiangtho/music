import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/rendering.dart';

import 'package:lidea/provider.dart';

import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';
// import 'package:lidea/hive.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/search-result';
  static const icon = LideaIcon.search;
  static const name = 'Result';
  static const description = '...';
  // static final uniqueKey = UniqueKey();
  // static final navigatorKey = GlobalKey<NavigatorState>();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late final Core core = context.read<Core>();
  late final AudioBucketType cache = core.collection.cacheBucket;

  late final scrollController = ScrollController();
  late final TextEditingController textController = TextEditingController();
  late final Future<void> initiator = core.conclusionGenerate(init: true);
  late final Preference preference = core.preference;

  ViewNavigationArguments get arguments => widget.arguments as ViewNavigationArguments;
  GlobalKey<NavigatorState> get navigator => arguments.navigator!;
  ViewNavigationArguments get parent => arguments.args as ViewNavigationArguments;
  bool get canPop => arguments.args != null;
  // bool get canPop => arguments.canPop;
  // bool get canPop => navigator.currentState!.canPop();
  // bool get canPop => Navigator.of(context).canPop();

  // AppLocalizations get translate => AppLocalizations.of(context)!;
  // Preference get preference => core.preference;

  @override
  void initState() {
    super.initState();
    onQuery();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    textController.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onUpdate(bool status) {
    if (status) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (scrollController.hasClients && scrollController.position.hasContentDimensions) {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 500),
          );
        }
      });
      onQuery();
    }
  }

  void onQuery() async {
    Future.microtask(() {
      textController.text = core.searchQuery;
    });
  }

  void onSearch(String ord) async {
    core.searchQuery = ord;
    core.suggestQuery = ord;
    await core.conclusionGenerate();
    onQuery();
    onUpdate(core.searchQuery.isNotEmpty);
  }

  // void onSwitchFavorite() {
  //   core.collection.favoriteSwitch(core.searchQuery);
  //   core.notify();
  // }
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        FutureBuilder(
          future: initiator,
          builder: (BuildContext _, AsyncSnapshot<void> snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return _msg(preference.text.aMoment);
              default:
                return Selector<Core, ConclusionType<OfRawType>>(
                  selector: (_, e) => e.collection.cacheConclusion,
                  builder: (BuildContext context, ConclusionType<OfRawType> o, Widget? child) {
                    if (o.query.isEmpty) {
                      return _msg(preference.text.aWordOrTwo);
                    } else if (o.raw.isNotEmpty) {
                      return _resultBlock(o);
                    } else {
                      return _msg(preference.text.searchNoMatch);
                    }
                  },
                );
            }
          },
        ),
        // Selector<Core, ConclusionType>(
        //   selector: (_, e) => e.collection.cacheConclusion,
        //   builder: (BuildContext context, ConclusionType o, Widget? child) {
        //     if (o.query.isEmpty) {
        //       return _msg(translate.aWordOrTwo);
        //     } else if (o.raw.isNotEmpty) {
        //       return _resultBlock(o);
        //     } else {
        //       return _msg(translate.searchNoMatch);
        //     }
        //   },
        // ),
        // SliverList(
        //   delegate: SliverChildListDelegate(
        //     const <Widget>[
        //       Text('1'),
        //       Text('2'),
        //       // SliverToBoxAdapter(
        //       //   child: Text('SliverToBoxAdapter'),
        //       // ),
        //     ],
        //   ),
        // ),
        // SliverPrototypeExtentList(
        //   delegate: SliverChildListDelegate(
        //     const [Text('4'), Text('3')],
        //   ),
        //   prototypeItem: const Text('prototypeItem'),
        // ),
        Selector<ViewScrollNotify, double>(
          selector: (_, e) => e.bottomPadding,
          builder: (context, bottomPadding, child) {
            return SliverPadding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              sliver: child,
            );
          },
          child: const SliverToBoxAdapter(),
        ),
      ],
    );
  }

  Widget _msg(String msg) {
    return SliverFillRemaining(
      hasScrollBody: false,
      fillOverscroll: true,
      child: Center(
        child: Text(msg),
      ),
    );
  }

  Widget _resultBlock(ConclusionType<OfRawType> o) {
    // return MultiSliver(
    //   children: List.generate(
    //     o.raw.length,
    //     (index) {
    //       final raw = o.raw.elementAt(index);
    //       switch (raw.type) {
    //         case 0:
    //           return _trackContainer(raw);
    //         case 1:
    //           return _artistContainer(raw);
    //         case 2:
    //           return _albumContainer(raw);
    //         default:
    //           return _resultContainer(raw);
    //       }
    //     },
    //   ),
    // );

    // SliverChildListDelegate
    // SliverChildBuilderDelegate
    // SliverChildListDelegate
    // SliverList(
    //   delegate: SliverChildListDelegate(<Widget>[]),
    // );
    // SliverPrototypeExtentList(delegate: SliverChildListDelegate([]),prototypeItem:const Text('a'));
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        // (BuildContext context, int i) => _resultContainer(o.raw.elementAt(i)),
        (BuildContext context, int i) {
          final raw = o.raw.elementAt(i);
          switch (raw.type) {
            case 0:
              return _trackContainer(raw);
            case 1:
              return _artistContainer(raw);
            case 2:
              return _albumContainer(raw);
            default:
              return _resultContainer(raw);
          }
        },
        childCount: o.raw.length,
      ),
    );
  }

  Widget _resultContainer(OfRawType raw) {
    return ListTile(
      title: Text(raw.term),
      leading: const Icon(CupertinoIcons.arrow_turn_down_right, semanticLabel: 'Conclusion'),
      onTap: () => true,
    );
  }

  Widget _trackContainer(OfRawType raw) {
    // return Column(
    //   children: [
    //     ListTile(
    //       leading: const Icon(LideaIcon.track, semanticLabel: 'Track'),
    //       title: Text(raw.term),
    //       trailing: Text(raw.count.toString()),
    //       onTap: () => true,
    //     ),
    //     const Text('...'),
    //   ],
    // );
    // return const SliverToBoxAdapter(
    //   child: Text('Track'),
    // );
    return TrackFlat(
      primary: false,
      tracks: raw.kid,
      label: 'Track--- (?)',
      limit: 4,
      showMore: 'show more()',
    );
  }

  Widget _artistContainer(OfRawType raw) {
    // return Column(
    //   children: [
    //     ListTile(
    //       leading: const Icon(LideaIcon.artist, semanticLabel: 'Artist'),
    //       title: Text(raw.term),
    //       trailing: Text(raw.count.toString()),
    //       onTap: () => true,
    //     ),
    //     const Text('...'),
    //   ],
    // );
    // return const SliverToBoxAdapter(
    //   child: Text('artist'),
    // );
    //
    return ArtistWrap(
      primary: false,
      artists: raw.kid,
      label: 'Artist--- (?)',
      limit: 4,
    );
  }

  Widget _albumContainer(OfRawType raw) {
    // return Column(
    //   children: [
    //     ListTile(
    //       leading: const Icon(LideaIcon.album, semanticLabel: 'Album'),
    //       title: Text(raw.term),
    //       trailing: Text(raw.count.toString()),
    //       onTap: () => true,
    //     ),
    //     const Text('...'),
    //   ],
    // );
    // artistAlbumId.map((e) => cache.albumById(e));
    // return const SliverToBoxAdapter(
    //   child: Text('album'),
    // );
    return AlbumBoard(
      primary: false,
      shrinkWrap: true,
      albums: raw.uid.map((e) => cache.albumById(e)),
      controller: scrollController,
    );
  }
}

// class SliverSingle extends SingleChildRenderObjectWidget {
//   const SliverSingle({Key? key, Widget? child}) : super(key: key, child: child);
//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return RenderSliverSingle();
//   }
// }

// class RenderSliverSingle extends RenderSliverSingleBoxAdapter {
//   RenderSliverSingle({RenderBox? child}) : super(child: child);

//   @override
//   void performLayout() {
//     if (child == null) {
//       geometry = SliverGeometry.zero;
//       return;
//     }
//     final SliverConstraints constraints = this.constraints;
//     child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
//     final double childExtent;
//     switch (constraints.axis) {
//       case Axis.horizontal:
//         childExtent = child!.size.width;
//         break;
//       case Axis.vertical:
//         childExtent = child!.size.height;
//         break;
//     }
//     // assert(childExtent != null);
//     final double paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);
//     final double cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);

//     assert(paintedChildSize.isFinite);
//     assert(paintedChildSize >= 0.0);
//     geometry = SliverGeometry(
//       scrollExtent: childExtent,
//       paintExtent: paintedChildSize,
//       cacheExtent: cacheExtent,
//       maxPaintExtent: childExtent,
//       hitTestExtent: paintedChildSize,
//       hasVisualOverflow:
//           childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
//     );
//     setChildParentData(child!, constraints, geometry!);
//   }
// }

// // MultiChildRenderObjectWidget
// // SingleChildRenderObjectWidget
// class SliverMulti extends MultiChildRenderObjectWidget {
//   // SliverMulti({Key? key, required List<Widget> children}) : super(key: key, children: children);
//   // SliverMulti({Key? key, required List<Widget> children}) : super(key: key, children: children);
//   SliverMulti({Key? key, List<Widget>? children}) : super(key: key, children: children!);
//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return RenderSliverMulti();
//   }
// }

// class RenderSliverMulti extends RenderSliverMultiBoxAdaptor {
//   // RenderSliverMulti({RenderSliverBoxChildManager? children}) : super(childManager: children!);
//   RenderSliverMulti({required RenderSliverBoxChildManager children})
//       : super(childManager: children);

//   @override
//   void performLayout() {
//     if (firstChild == null) {
//       geometry = SliverGeometry.zero;
//       return;
//     }
//     final SliverConstraints constraints = this.constraints;
//     firstChild!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
//     // final double childExtent;
//     // switch (constraints.axis) {
//     //   case Axis.horizontal:
//     //     childExtent = firstChild!.size.width;
//     //     break;
//     //   case Axis.vertical:
//     //     childExtent = firstChild!.size.height;
//     //     break;
//     // }
//     // assert(childExtent != null);
//     // final double paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);
//     // final double cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);

//     // final correction = _layoutChildSequence(
//     //   child: firstChild,
//     //   scrollOffset: constraints.scrollOffset,
//     //   overlap: constraints.overlap,
//     //   remainingPaintExtent: constraints.remainingPaintExtent,
//     //   mainAxisExtent: constraints.viewportMainAxisExtent,
//     //   crossAxisExtent: constraints.crossAxisExtent,
//     //   growthDirection: GrowthDirection.forward,
//     //   advance: childAfter,
//     //   remainingCacheExtent: constraints.remainingCacheExtent,
//     //   cacheOrigin: constraints.cacheOrigin,
//     // );

//     // geometry = SliverGeometry(
//     //   scrollExtent: childExtent,
//     //   paintExtent: paintedChildSize,
//     //   cacheExtent: cacheExtent,
//     //   maxPaintExtent: childExtent,
//     //   hitTestExtent: paintedChildSize,
//     //   hasVisualOverflow:
//     //       childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
//     // );
//     // if (correction != null) {
//     //   geometry = SliverGeometry(scrollOffsetCorrection: correction);
//     //   return;
//     // }
//     geometry = const SliverGeometry();
//   }
// }
// class SliverTesting extends RenderSliverMultiBoxAdaptor {
//   SliverTesting({required RenderSliverBoxChildManager childManager})
//       : super(childManager: childManager);

//   @override
//   void performLayout() {
//     // TODO: implement performLayout
//   }
// }

// class RenderMultiSliver extends RenderSliver {
//   RenderMultiSliver({
//     required bool containing,
//   });

//   @override
//   void performLayout() {
//     // TODO: implement performLayout
//     if (firstChild == null) {
//       geometry = SliverGeometry.zero;
//       return;
//     }
//   }
// }
