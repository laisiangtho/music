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
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, required this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/search-result';
  static const icon = LideaIcon.search;
  static const name = 'Result';
  static const description = '...';

  @override
  State<StatefulWidget> createState() => _View();
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
        // Selector<ViewScrollNotify, double>(
        //   selector: (_, e) => e.bottomPadding,
        //   builder: (context, bottomPadding, child) {
        //     return SliverPadding(
        //       padding: EdgeInsets.only(bottom: bottomPadding),
        //       sliver: child,
        //     );
        //   },
        //   child: const SliverToBoxAdapter(),
        // ),
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
    return TrackFlat(
      primary: false,
      tracks: raw.kid,
      label: 'Track--- (?)',
      limit: 4,
      showMore: 'show more()',
    );
  }

  Widget _artistContainer(OfRawType raw) {
    return ArtistWrap(
      primary: false,
      artists: raw.kid,
      label: 'Artist--- (?)',
      limit: 4,
    );
  }

  Widget _albumContainer(OfRawType raw) {
    return AlbumBoard(
      primary: false,
      shrinkWrap: true,
      albums: raw.uid.map((e) => cacheBucket.albumById(e)),
      controller: scrollController,
    );
  }
}
