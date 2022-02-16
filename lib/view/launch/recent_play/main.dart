import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:hive_flutter/hive_flutter.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({
    Key? key,
    this.arguments,
  }) : super(key: key);

  final Object? arguments;

  static const route = '/recent-play';
  static const icon = LideaIcon.layers;
  static const name = 'Recent play';
  static const description = '...';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late final scrollController = ScrollController();
  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;

  late final Box<RecentPlayType> box = core.collection.boxOfRecentPlay;

  late final ViewNavigationArguments arguments = widget.arguments as ViewNavigationArguments;
  late final bool canPop = widget.arguments != null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // void onClear() {
  //   box.clear();
  // }
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        // key: const ValueKey<String>('recent-play'),
        // controller: scrollController,
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<RecentPlayType> o, child) {
            return body(o.values.toList());
          },
        ),
      ),
    );
  }

  CustomScrollView body(List<RecentPlayType> items) {
    items.sort((a, b) => b.date!.compareTo(a.date!));

    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        bar(items.isNotEmpty),
        if (items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('...'),
            ),
          )
        else
          TrackList(
            key: const ValueKey<String>('tracklist-recent-play'),
            tracks: core.audio.trackMetaById(items.map((e) => e.id).toList()),
          ),
        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //     (BuildContext context, int index) {
        //       final item = items.elementAt(index);
        //       return ListTile(
        //         leading: Text('${item.plays}'),
        //         title: Text('${item.date}'),
        //         trailing: Text('${item.id}'),
        //       );
        //     },
        //     childCount: items.length,
        //   ),
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
}
