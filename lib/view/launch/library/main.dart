import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
// import 'package:lidea/intl.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'detail.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.navigatorKey, this.arguments}) : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final Object? arguments;

  static const route = '/library';
  // LideaIcon.layers;
  // static const icon = Icons.library_music_rounded;
  static const icon = Icons.auto_awesome_rounded;
  static const name = 'Library';
  static const description = '...';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

  late final Core core = context.read<Core>();
  // Preference get preference => core.preference;
  late final Preference preference = core.preference;
  late final ViewNavigationArguments arguments = widget.arguments as ViewNavigationArguments;
  late final bool canPop = widget.arguments != null;

  // late final AudioBucketType cache = core.collection.cacheBucket;
  late final Box<LibraryType> box = core.collection.boxOfLibrary;

  // late Box<LibraryType> library;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // @override
  // void setState(fn) {
  //   if (mounted) super.setState(fn);
  // }

  LibraryType get likes {
    return core.collection.valueOfLibraryLike;
  }

  LibraryType get queues {
    return core.collection.valueOfLibraryQueue;
  }

  Iterable<LibraryType> get playlists {
    return core.collection.listOfLibraryPlaylists;
  }

  void clearAll() {
    box.clear();
  }

  void showDetail(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) => _Detail(index: index),
    );
    // showModalBottomSheet(
    //   context: context,
    //   // builder: (BuildContext context) => TrackOption(
    //   //   trackId: track.trackInfo.id,
    //   // ),
    //   builder: (BuildContext context) {
    //     return AnnotatedRegion<SystemUiOverlayStyle>(
    //       // value: SystemUiOverlayStyle.light.copyWith(
    //       //   systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
    //       //   systemNavigationBarDividerColor: Theme.of(context).focusColor,
    //       // ),
    //       value: SystemUiOverlayStyle(
    //         // systemNavigationBarColor: Theme.of(context).primaryColor,
    //         systemNavigationBarDividerColor: Theme.of(context).focusColor,
    //         // systemNavigationBarIconBrightness: Brightness.dark,
    //       ),
    //       child: TrackOption(
    //         trackId: track.trackInfo.id,
    //       ),
    //     );
    //   },
    //   barrierColor: Theme.of(context).shadowColor.withOpacity(0.6),
    //   // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //   // backgroundColor: Theme.of(context).primaryColor,
    //   isScrollControlled: true,
    //   elevation: 10,
    //   useRootNavigator: true,
    // ).whenComplete(
    //   () => Future.delayed(
    //     const Duration(milliseconds: 300),
    //     () => {},
    //   ),
    // );
  }
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: widget.key,
      body: ViewPage(
        // controller: scrollController,
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<LibraryType> o, child) {
            return body();
          },
        ),
      ),
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          sliver: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 150), () => true),
            builder: (_, snap) {
              if (snap.hasData) {
                return SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: Column(
                      children: [
                        ListTile(
                          // leading: Icon(Icons.favorite_border),
                          leading: const Icon(
                            // Icons.favorite_border,
                            Icons.grade_rounded,
                            size: 30,
                          ),
                          title: Text(likes.name),
                          trailing: Wrap(
                            children: [
                              Text(
                                likes.list.length.toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const Icon(
                                Icons.navigate_next,
                              ),
                            ],
                          ),
                          onTap: () => showDetail(likes.key),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).focusColor,
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.play_arrow,
                            size: 30,
                          ),
                          title: Text(
                            queues.name,
                          ),
                          trailing: Wrap(
                            children: [
                              Text(
                                queues.list.length.toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const Icon(Icons.navigate_next),
                            ],
                          ),
                          onTap: () {
                            showDetail(queues.key);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter();
            },
          ),
        ),
        FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 250), () => true),
          builder: (_, snap) {
            if (snap.hasData) {
              return playlistsContainer();
            }
            return const SliverToBoxAdapter();
          },
        ),
        // tmp(),
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

  Widget playlistsContainer() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          <Widget>[
            WidgetBlockTile(
              title: WidgetLabel(
                alignment: Alignment.centerLeft,
                label: preference.text.playlist(true),
              ),
            ),
            if (playlists.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  // child: Text(preference.language('abc??')),
                  child: WidgetButton(
                    child: WidgetLabel(
                      icon: Icons.add,
                      label: preference.text.addTo(preference.text.playlist(false)),
                    ),
                    onPressed: () {
                      doConfirmWithWidget(
                        context: context,
                        child: const PlayListsEditor(),
                      );
                    },
                  ),
                ),
              )
            else
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: playlists.length,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  itemBuilder: (_, index) {
                    final item = playlists.elementAt(index);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      leading: const WidgetLabel(
                        // icon: Icons.queue_music_rounded,
                        // icon: Icons.playlist_add,
                        // icon: Icons.playlist_add_check,
                        icon: Icons.queue_music_rounded,
                        iconSize: 35,
                      ),
                      title: Text(
                        item.name,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      trailing: Wrap(
                        children: [
                          Text(
                            item.list.length.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const Icon(Icons.navigate_next),
                        ],
                      ),
                      onTap: () => showDetail(item.key),
                    );
                  },
                  separatorBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        height: 1,
                        color: Theme.of(context).shadowColor,
                      ),
                    );
                  },
                ),
              ),
            if (playlists.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: WidgetButton(
                  child: WidgetLabel(
                    icon: Icons.add,
                    // label: preference.language('Add more Playlists'),
                    label: preference.text.addMore(preference.text.playlist(true)),
                  ),
                  onPressed: () {
                    doConfirmWithWidget(
                      context: context,
                      child: const PlayListsEditor(),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  SliverList tmp() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          WidgetBlockTile(
            title: const Text('Add Queue'),
            onPressed: () {
              box.add(
                LibraryType(
                  date: DateTime.now(),
                  name: 'Queue',
                  type: 0,
                  list: [1, 2, 3, 4, 5, 6, 7],
                ),
              );
            },
          ),
          WidgetBlockTile(
            title: const Text('Add Like'),
            onPressed: () {
              box.add(
                LibraryType(
                  date: DateTime.now(),
                  name: 'Like',
                  type: 1,
                  list: [1, 2, 3, 4, 5, 6, 7],
                ),
              );
            },
          ),
          WidgetBlockTile(
            title: const Text('Add Recent'),
            onPressed: () {
              box.add(
                LibraryType(
                  date: DateTime.now(),
                  name: 'Recent',
                  type: 2,
                  list: [1, 2, 3, 4, 5, 6, 7],
                ),
              );
            },
          ),
          WidgetBlockTile(
            title: const Text('Add PlayLists'),
            onPressed: () {
              box.add(
                LibraryType(
                  date: DateTime.now(),
                  name: 'PlayLists Name',
                  type: 3,
                  list: [1, 2, 3, 4, 5, 6],
                ),
              );
            },
          ),
          WidgetBlockTile(
            title: const Text('Clear All'),
            onPressed: () {
              box.clear();
            },
          ),
        ],
      ),
    );
  }
}
