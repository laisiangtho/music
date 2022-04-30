import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'state.dart';

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

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        // controller: scrollController,
        child: CustomScrollView(
          controller: scrollController,
          slivers: sliverWidgets(),
        ),
      ),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        // reservedPadding: MediaQuery.of(context).padding.top,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 70],
        overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: bar,
      ),
      const PullToRefresh(),
      WidgetBlockSection(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
        // label: '--- Most play album (?)',
        label: preference.text
            .mostVerbNoun(preference.text.playMusic(false), preference.text.album(true)),
        more: const WidgetLabel(
          icon: Icons.more_horiz_rounded,
        ),
      ),
      ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<RecentPlayType> o, child) {
          if (o.isEmpty || o.length < 5) {
            return child!;
          }
          final recentPlayIds = o.values.take(7).map((e) => e.id);
          return TrackBlock(
            // label: '--- Recent play track (?)',
            // label: preference.text
            //     .recentVerbNoun(preference.text.playMusic(false), preference.text.track(true)),
            headerTitle: WidgetLabel(
              alignment: Alignment.centerLeft,
              label: preference.text.recentVerbNoun(
                preference.text.playMusic(false),
                preference.text.track(true),
              ),
            ),

            tracks: recentPlayIds,
          );
        },
        child: TrackBlock(
          // label: '--- Most play track (?)',
          // label: preference.text
          //     .mostVerbNoun(preference.text.playMusic(false), preference.text.track(true)),
          headerTitle: WidgetLabel(
            alignment: Alignment.centerLeft,
            label: preference.text.mostVerbNoun(
              preference.text.playMusic(false),
              preference.text.track(true),
            ),
          ),
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
            return ArtistBlock(
              primary: false,
              // label: 'Artists in ' + lag.name.toUpperCase(),
              // TODO: language zola as in zomi etc
              headerTitle: WidgetLabel(
                alignment: Alignment.center,
                // label: 'Artists in ' + lag.name.toUpperCase(),
                label: preference.text.artistInLanguage(
                  preference.text.artist(true),
                  // lag.name.toUpperCase(),
                  preference.language(lag.name + '-people'),
                ),
              ),
              artists: tmp,
            );
          },
          childCount: langList.length,
        ),
      ),
      WidgetBlockSection(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: seeMore(),
        ),
      ),
      recentSearchContainer(),
      WidgetBlockSection(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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

  Widget recentSearchContainer() {
    return Selector<Core, List<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.collection.boxOfRecentSearch.entries.toList(),
      builder: (BuildContext _, List<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
        if (items.isEmpty) {
          return const WidgetChildBuilder(
            child: Icon(LideaIcon.dotHoriz),
          );
        }
        items.sort((a, b) => b.value.date!.compareTo(a.value.date!));

        return WidgetBlockSection(
          show: items.isNotEmpty,
          headerTitle: WidgetLabel(
            alignment: Alignment.center,
            // message: preference.text.addTo(preference.text.recentSearch(true)),
            label: preference.text.recentSearch(true),
          ),
          child: researchWrap(items),
        );

        // return WidgetChildBuilder(
        //   show: items.isNotEmpty,
        //   child: Column(
        //     children: [
        //       WidgetBlockTile(
        //         title: WidgetLabel(
        //           // alignment: Alignment.centerLeft,
        //           message: preference.text.addTo(preference.text.recentSearch(true)),
        //           label: preference.text.recentSearch(true),
        //         ),
        //       ),
        //       researchWrap(items),
        //     ],
        //   ),
        // );
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

  Widget seeMore() {
    return Wrap(
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

        // WidgetButton(
        //   child: WidgetLabel(
        //     icon: LideaIcon.cog,
        //     label: preference.text.setting(true),
        //   ),
        //   onPressed: () {
        //     core.navigate(to: '/settings');
        //   },
        // ),
      ],
    );
  }
}
