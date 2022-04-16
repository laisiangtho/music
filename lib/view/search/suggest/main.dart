import 'package:flutter/material.dart';

// import 'package:lidea/hive.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.navigatorKey, this.arguments}) : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final Object? arguments;

  static const route = '/search-suggest';
  static const icon = LideaIcon.search;
  static const name = 'Suggestion';
  static const description = '...';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        child: CustomScrollView(
          controller: scrollController,
          slivers: sliverWidgets(),
        ),
      ),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      // Selector<Core, bool>(
      //   selector: (BuildContext _, Core e) => e.nodeFocus,
      //   builder: (BuildContext _, bool word, Widget? child) {
      //     return bar();
      //   },
      // ),
      SliverLayoutBuilder(
        builder: (BuildContext context, constraints) {
          return ViewHeaderSliverSnap(
            pinned: true,
            floating: false,
            padding: MediaQuery.of(context).viewPadding,
            heights: const [kToolbarHeight],
            overlapsBackgroundColor: Theme.of(context).primaryColor,
            overlapsBorderColor: Theme.of(context).shadowColor,
            overlapsForce: constraints.scrollOffset > 0,
            builder: bar,
          );
        },
      ),

      Selector<Core, SuggestionType<OfRawType>>(
        selector: (_, e) => e.collection.cacheSuggestion,
        builder: (BuildContext context, SuggestionType<OfRawType> o, Widget? child) {
          if (o.query.isEmpty) {
            return _suggestNoQuery();
          } else if (o.raw.isNotEmpty) {
            return SliverList(
              // key: UniqueKey(),
              key: ValueKey(o.query),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final raw = o.raw.elementAt(index);
                  // return _suggestBlock(raw);
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
                  // OfRawType();
                  // if (raw.type == 0) {
                  //   return _trackContainer(raw);
                  // } else if (raw.type == 1) {
                  //   return _artistContainer(raw);
                  // } else if (raw.type == 2) {
                  //   return _albumContainer(raw);
                  // } else {
                  //   return _resultContainer(raw);
                  // }
                },
                childCount: o.raw.length,
              ),
            );
          } else {
            return _msg('suggest: not found');
          }
        },
      ),
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
    ];
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

  Widget _suggestNoQuery() {
    return Selector<Core, Iterable<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.collection.boxOfRecentSearch.entries,
      builder: (BuildContext _a, Iterable<MapEntry<dynamic, RecentSearchType>> items, Widget? _b) {
        if (items.isNotEmpty) {
          return _recentBlock(items);
        }
        return _msg(preference.text.aWordOrTwo);
      },
    );
  }

  /*
  Widget _suggestBlock(OfRawType snap) {
    return WidgetBlockSection(
      primary: false,
      headerLeading: WidgetLabel(
        icon: typeIcons.elementAt(snap.type),
        iconSize: 22,
      ),
      headerTitle: WidgetLabel(
        alignment: Alignment.centerLeft,
        label: preference.text.objContainSub(suggestQuery, snap.term),
      ),
      // headerTrailing: Text(snap.count.toString()),
      headerTrailing: WidgetLabel(
        label: snap.count.toString(),
      ),
      child: Card(
        child: WidgetListBuilder(
          primary: false,
          itemCount: snap.uid.length,
          itemBuilder: (_, index) {
            String word = snap.uid.elementAt(index);
            int ql = suggestQuery.length;
            int wl = word.length;
            return _suggestItem(word, ql < wl ? ql : wl);
            // return Text(word);
          },
          itemSeparator: (_, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 1),
            );
          },
        ),
      ),
      // child: _suggestSwitch(snap),
    );
  }
  Widget _suggestItem(String word, int hightlight) {
    return ListTile(
      leading: const Icon(Icons.north_east_rounded),
      title: Text(
        word,
      ),
      // onTap: () => onSearch(word),
      onTap: () {
        debugPrint('word $word');
      },
    );
  }
  */

  Widget _resultContainer(OfRawType raw) {
    return ListTile(
      title: Text(raw.term),
      leading: const Icon(Icons.north_east_rounded, semanticLabel: 'Conclusion'),
      onTap: () => true,
    );
  }

  Widget _trackContainer(OfRawType raw) {
    return TrackBlock(
      primary: false,
      tracks: raw.kid,
      headerTitle: WidgetLabel(
        alignment: Alignment.centerLeft,
        label: preference.text.objContainSub(suggestQuery, raw.term),
      ),
      // headerTrailing: WidgetLabel(label: raw.count.toString()),
      limit: raw.limit,
    );
  }

  Widget _artistContainer(OfRawType raw) {
    return ArtistBlock(
      primary: false,
      wrap: false,
      artists: raw.kid,
      headerTitle: WidgetLabel(
        alignment: Alignment.centerLeft,
        label: preference.text.objContainSub(suggestQuery, raw.term),
      ),
      // headerTrailing: WidgetLabel(label: raw.count.toString()),
      limit: raw.limit,
    );
  }

  Widget _albumContainer(OfRawType raw) {
    return AlbumBoard(
      primary: false,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      albums: raw.uid.map((e) => cacheBucket.albumById(e)),
      headerTitle: WidgetLabel(
        alignment: Alignment.centerLeft,
        label: preference.text.objContainSub(suggestQuery, raw.term),
      ),
      headerTrailing: WidgetLabel(
        label: raw.count.toString(),
      ),
      // controller: scrollController,
      limit: raw.limit,
    );
    // return WidgetBlockSection(
    //   primary: false,
    //   headerLeading: WidgetLabel(
    //     icon: typeIcons.elementAt(raw.type),
    //     iconSize: 22,
    //   ),

    //   child: AlbumBoard(
    //     primary: false,
    //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
    //     albums: raw.uid.map((e) => cacheBucket.albumById(e)),
    //     controller: scrollController,
    //     limit: raw.limit,
    //   ),
    // );
  }

  // Recent searches
  Widget _recentBlock(Iterable<MapEntry<dynamic, RecentSearchType>> items) {
    return WidgetBlockSection(
      headerLeading: const WidgetLabel(
        icon: LideaIcon.record,
        iconSize: 22,
      ),
      headerTitle: WidgetLabel(
        alignment: Alignment.centerLeft,
        label: preference.text.recentSearch(items.length > 1),
      ),
      child: Card(
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _recentContainer(index, items.elementAt(index));
          },
          separatorBuilder: (context, index) {
            return const Divider(height: 0);
          },
        ),
      ),
    );
  }

  Dismissible _recentContainer(int index, MapEntry<dynamic, RecentSearchType> item) {
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      child: ListTile(
        // contentPadding: EdgeInsets.zero,
        // minLeadingWidth: 10,
        // leading: Icon(Icons.manage_search_rounded),
        leading: const Icon(
          Icons.north_east_rounded,
          semanticLabel: 'Suggestion',
        ),
        title: _recentItem(item.value.word),

        onTap: () => onSuggest(item.value.word),
      ),
      background: _recentDismissibleBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return onDelete(item.value.word);
        }
        return null;
      },
    );
  }

  Widget _recentItem(String word) {
    int hightlight = suggestQuery.length < word.length ? suggestQuery.length : word.length;
    return Text.rich(
      TextSpan(
        text: word.substring(0, hightlight),
        semanticsLabel: word,
        style: TextStyle(
          fontSize: 22,
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.w300,
        ),
        children: <TextSpan>[
          TextSpan(
            text: word.substring(hightlight),
            style: TextStyle(
              color: Theme.of(context).highlightColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _recentDismissibleBackground() {
    return Container(
      color: Theme.of(context).disabledColor,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: Text(
          preference.text.delete,
          // textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
