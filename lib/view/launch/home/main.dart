import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/cached_network_image.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'state.dart';
part 'refresh.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/launch/home';
  static const icon = LideaIcon.search;
  static const name = 'Home';
  static const description = '...';

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar, _Refresh {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      body: ViewPage(
        // key: widget.key,
        // controller: scrollController,
        child: body(),
      ),
    );
  }

  Widget body() {
    return CustomScrollView(
      // primary: true,
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        refresh(),

        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          sliver: SliverToBoxAdapter(
            child: Text(
              core.collection.language('Personalized experience'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),

        AlbumFlat(
          context: context,
          album: albumPopular,
          label: '--- Most play album (?)',
          more: const WidgetLabel(
            icon: Icons.more_horiz_rounded,
          ),
        ),

        // favoriteContainer(),

        ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<RecentPlayType> o, child) {
            if (o.isEmpty || o.length < 5) {
              return child!;
            }
            final recentPlayIds = o.values.take(7).map((e) => e.id);
            return TrackFlat(
              label: '--- Recent play track (?)',
              tracks: recentPlayIds,
            );
          },
          child: TrackFlat(
            label: '--- Most play track (?)',
            tracks: trackMeta,
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext _, int index) {
              final lag = langList.elementAt(index);
              // lag.id
              final tmp = cacheBucket.artist.where((e) {
                return e.lang.contains(lag.id) && e.id > 2;
              }).map((e) {
                return e.id;
              }).take(7);
              return ArtistWrap(
                primary: false,
                label: 'Artists in ' + lag.name.toUpperCase(),
                artists: tmp,
              );
            },
            childCount: langList.length,
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 20),
                  child: Wrap(
                    // crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    spacing: 15,
                    runSpacing: 20,
                    children: [
                      WidgetButton(
                        child: WidgetLabel(
                          icon: LideaIcon.music,
                          label: preference.text.music(true),
                        ),
                        onPressed: null,
                      ),
                      WidgetButton(
                        child: WidgetLabel(
                          icon: Icons.auto_awesome_rounded,
                          label: preference.text.library(true),
                        ),
                        onPressed: () {
                          core.navigate(at: 1);
                        },
                      ),
                      WidgetButton(
                        child: WidgetLabel(
                          icon: LideaIcon.artist,
                          label: preference.text.artist(true),
                        ),
                        onPressed: () {
                          core.navigate(to: '/artist-list');
                        },
                      ),
                      WidgetButton(
                        child: WidgetLabel(
                          icon: LideaIcon.album,
                          label: preference.text.album(true),
                        ),
                        onPressed: () {
                          core.navigate(to: '/album-list');
                        },
                      ),
                      WidgetButton(
                        child: WidgetLabel(
                          icon: LideaIcon.layers,
                          label: preference.text.recentPlay(false),
                        ),
                        onPressed: () {
                          core.navigate(to: '/recent-play');
                        },
                      ),
                      WidgetButton(
                        child: const WidgetLabel(
                          icon: LideaIcon.layers,
                          label: 'Reorderable',
                        ),
                        onPressed: () {
                          core.navigate(to: '/reorderable');
                        },
                      ),
                      WidgetButton(
                        child: WidgetLabel(
                          icon: LideaIcon.cog,
                          label: preference.text.setting(true),
                        ),
                        onPressed: () {
                          core.navigate(to: '/settings');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        recentSearchContainer(),

        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
          sliver: SliverToBoxAdapter(
            child: Text(
              core.collection.language('Discover music'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
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
      ],
    );
  }

  Widget favoriteContainer() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            WidgetBlockTile(
              title: WidgetLabel(
                alignment: Alignment.centerLeft,
                label: preference.text.favorite(true),
              ),
              trailing: WidgetButton(
                child: WidgetLabel(
                  icon: Icons.more_horiz,
                  message: preference.text.addTo(preference.text.favorite(true)),
                ),
                onPressed: () {
                  core.navigate(to: '/recent-search');
                },
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: favoriteWrap(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget recentSearchContainer() {
    return Selector<Core, List<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.collection.recentSearches.toList(),
      builder: (BuildContext _, List<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
        if (items.isEmpty) {
          return const WidgetChildBuilder(
            show: true,
            child: Icon(LideaIcon.dotHoriz),
          );
        }
        items.sort((a, b) => b.value.date!.compareTo(a.value.date!));
        return WidgetChildBuilder(
          show: items.isNotEmpty,
          child: Column(
            children: [
              WidgetBlockTile(
                title: WidgetLabel(
                  // alignment: Alignment.centerLeft,
                  message: preference.text.addTo(preference.text.recentSearch(true)),
                  label: preference.text.recentSearch(true),
                ),
              ),
              researchWrap(items),
            ],
          ),
        );
      },
    );
    // return SliverPadding(
    //   padding: const EdgeInsets.symmetric(vertical: 8),
    //   sliver: SliverList(
    //     delegate: SliverChildListDelegate(
    //       [
    //         WidgetBlockTile(
    //           title: WidgetLabel(
    //             alignment: Alignment.centerLeft,
    //             message: preference.text.addTo(preference.text.recentSearch(true)),
    //             label: preference.text.recentSearch(true),
    //           ),
    //           // trailing: WidgetButton(
    //           //   child: WidgetLabel(
    //           //     icon: Icons.more_horiz,
    //           //     message: preference.text.addTo(preference.text.recentSearch(true)),
    //           //   ),
    //           //   // child: const Text('more'),
    //           //   onPressed: () {
    //           //     core.navigate(to: '/recent-search');
    //           //   },
    //           // ),
    //         ),
    //         // Card(
    //         //   margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
    //         //   child: ,
    //         // ),
    //         Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
    //           child: researchWrap(),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget favoriteWrap() {
    return Selector<Core, List<MapEntry<dynamic, FavoriteWordType>>>(
      selector: (_, e) => e.collection.favorites.toList(),
      builder: (BuildContext _, List<MapEntry<dynamic, FavoriteWordType>> items, Widget? __) {
        items.sort((a, b) => b.value.date!.compareTo(a.value.date!));
        if (items.isEmpty) {
          return const Icon(LideaIcon.dotHoriz);
        }
        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          textDirection: TextDirection.ltr,
          children: items.take(3).map(
            (e) {
              return WidgetButton(
                child: Text(
                  e.value.word,
                ),
                onPressed: () => onSearch(e.value.word),
              );
            },
          ).toList(),
        );
      },
    );
  }

  Widget researchWrap(List<MapEntry<dynamic, RecentSearchType>> items) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      textDirection: TextDirection.ltr,
      children: items.take(3).map(
        (e) {
          return WidgetButton(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: WidgetLabel(
              label: e.value.word,
            ),
            onPressed: () => onSearch(e.value.word),
          );
        },
      ).toList(),
    );
  }
}
