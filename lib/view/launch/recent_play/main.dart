import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';

// import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);

  final Object? arguments;

  static const route = '/recent-play';
  static const icon = LideaIcon.layers;
  static const name = 'Recent play';
  static const description = '...';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: middleware,
        ),
      ),
    );
  }

  Widget middleware(BuildContext context, Box<RecentPlayType> o, Widget? child) {
    return CustomScrollView(
      controller: scrollController,
      slivers: sliverWidgets(o.values.toList()),
    );
  }

  List<Widget> sliverWidgets(List<RecentPlayType> items) {
    // TODO option to sort
    // items.sort((a, b) => b.date!.compareTo(a.date!));
    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        // reservedPadding: MediaQuery.of(context).padding.top,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 50],
        overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: bar,
      ),
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
          tracks: core.audio.metaById(items.map((e) => e.id).toList()),
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
}
