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
part 'refresh.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/launch/home';
  static const icon = LideaIcon.search;
  static const name = 'Home';
  static const description = '...';
  // static final uniqueKey = UniqueKey();
  // static final navigatorKey = GlobalKey<NavigatorState>();
  // static late final scaffoldKey = GlobalKey<ScaffoldState>();
  // static const scaffoldKey = Key('launch-adfeeppergt');

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late final scrollController = ScrollController();
  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;
  // Preference get preference => core.preference;
  late final Box<RecentPlayType> box = core.collection.boxOfRecentPlay;
  late final langList = cache.langAvailable();

  Authentication get authenticate => context.read<Authentication>();

  AudioBucketType get cache => core.collection.cacheBucket;
  // Iterable<AudioMetaType> get trackMeta => core.audio.trackMetaById([3384,3876,77,5,7,8]);
  // Iterable<int> get trackMeta => [3384,3876,77,5,7,8];
  Iterable<int> get trackMeta => cache.track.take(7).map((e) => e.id);
  Iterable<AudioCategoryLang> get language => cache.langAvailable();
  // Iterable<AudioArtistType> artistPopularByLang(int id) => cache.artistPopularByLang(id);
  Iterable<int> artistPopularByLang(int id) => cache.artistPopularByLang(id);
  Iterable<AudioAlbumType> get albumPopular => cache.album.take(17);

  // bool _showModal = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // late PersistentBottomSheetController? _bottomSheetController;

  @override
  void initState() {
    super.initState();
    // Future.microtask((){});
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onClear() {
    Future.microtask(() {});
  }

  String get searchQuery => core.searchQuery;
  set searchQuery(String ord) {
    core.searchQuery = ord;
  }

  String get suggestQuery => core.suggestQuery;
  set suggestQuery(String ord) {
    core.suggestQuery = ord.replaceAll(RegExp(' +'), ' ').trim();
  }

  void onSearch(String ord) {
    suggestQuery = ord;
    searchQuery = suggestQuery;

    Future.microtask(() {
      core.conclusionGenerate();
    });
    core.navigate(to: '/search-result');
  }

  // void onDelete(String word) {
  //   Future.delayed(Duration.zero, () {});
  // }

  bool get canPop => Navigator.of(context).canPop();
}

class _View extends _State with _Bar, _Refresh {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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

        // SliverToBoxAdapter(
        //   child: SizedBox(
        //     height: kBottomNavigationBarHeight,
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
        //       child: Hero(
        //         tag: 'searchHero',
        //         child: GestureDetector(
        //           child: Material(
        //             type: MaterialType.transparency,
        //             child: MediaQuery(
        //               data: MediaQuery.of(context),
        //               child: TextFormField(
        //                 readOnly: true,
        //                 enabled: false,
        //                 decoration: InputDecoration(
        //                   hintText: preference.text.aWordOrTwo,
        //                   prefixIcon: const Icon(LideaIcon.find, size: 20),
        //                   fillColor:
        //                       Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
        //                 ),
        //               ),
        //             ),
        //           ),
        //           onTap: () {
        //             core.navigate(to: '/search');
        //           },
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Hero(
                  tag: 'searchHero',
                  child: GestureDetector(
                    child: Material(
                      type: MaterialType.transparency,
                      child: MediaQuery(
                        data: MediaQuery.of(context),
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: preference.text.aWordOrTwo,
                            prefixIcon: const Icon(LideaIcon.find, size: 20),
                            fillColor:
                                Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      core.navigate(to: '/search');
                    },
                  ),
                ),
              ),
            ),
          ),
        ),

        // const SliverPadding(
        //   padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        //   sliver: SliverToBoxAdapter(
        //     child: Text('abc'),
        //   ),
        // ),
        // SliverLayoutBuilder(
        //   builder: (_, __) {
        //     return const SliverPadding(
        //       padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        //       sliver: SliverToBoxAdapter(
        //         child: Text('abc'),
        //       ),
        //     );
        //   },
        // ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Text(
              core.collection.language('Personalized experience'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),

        // SliverToBoxAdapter(
        //   child: AlbumFlat(
        //     context: context,
        //     primary: false,
        //     album: albumPopular,
        //     label: 'Most play album (?)',
        //     more: const WidgetLabel(
        //       icon: Icons.more_horiz_rounded,
        //     ),
        //   ),
        // ),

        AlbumFlat(
          context: context,
          album: albumPopular,
          label: '--- Most play album (?)',
          more: const WidgetLabel(
            icon: Icons.more_horiz_rounded,
          ),
        ),

        // favoriteContainer(),
        // SliverToBoxAdapter(
        //   child: TrackFlat(
        //     primary: false,
        //     tracks: trackMeta,
        //     label: 'widget Most play track (?)',
        //   ),
        // ),
        // TrackFlat(
        //   tracks: trackMeta,
        //   label: '--- Most play track (?)',
        // ),

        ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<RecentPlayType> o, child) {
            // debugPrint('??? recent play');
            if (o.isEmpty || o.length < 5) {
              return child!;
            }
            final recentPlayIds = o.values.take(7).map((e) => e.id);
            // return SliverToBoxAdapter(
            //   child: Text('?? ${o.values.length}'),
            // );
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
              final tmp = cache.artist.where((e) {
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
                    // spacing: 15,
                    // runSpacing: 20,
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
                        child: const WidgetLabel(
                          icon: LideaIcon.layers,
                          label: 'Recent play',
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        recentSearchContainer(),

        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Text(
              core.collection.language('Discover music'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),

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
              return CupertinoButton(
                child: Text(
                  e.value.word,
                  style: Theme.of(context).textTheme.bodyText1,
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
    // return Selector<Core, List<MapEntry<dynamic, RecentSearchType>>>(
    //   selector: (_, e) => e.collection.recentSearches.toList(),
    //   builder: (BuildContext _, List<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
    //     items.sort((a, b) => b.value.date!.compareTo(a.value.date!));
    //     if (items.isEmpty) {
    //       return const Icon(LideaIcon.dotHoriz);
    //     }
    //     return Wrap(
    //       alignment: WrapAlignment.center,
    //       crossAxisAlignment: WrapCrossAlignment.center,
    //       textDirection: TextDirection.ltr,
    //       children: items.take(3).map(
    //         (e) {
    //           return CupertinoButton(
    //             child: Text(
    //               e.value.word,
    //               style: Theme.of(context).textTheme.bodyText1,
    //             ),
    //             onPressed: () => onSearch(e.value.word),
    //           );
    //         },
    //       ).toList(),
    //     );
    //   },
    // );
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
              labelStyle: Theme.of(context).textTheme.bodyText1,
            ),
            onPressed: () => onSearch(e.value.word),
          );
        },
      ).toList(),
    );
  }
}
