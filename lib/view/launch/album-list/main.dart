import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
import 'package:lidea/icon.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/extension.dart';
import 'package:lidea/view/main.dart';
// import 'package:lidea/icon.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'bar.dart';
part 'sheet.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.navigatorKey, this.arguments}) : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final Object? arguments;

  static const route = '/album-list';
  // static const icon = Icons.low_priority_outlined;
  static const icon = LideaIcon.album;
  static const name = 'Albums';
  static const description = '...';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late final scrollController = ScrollController();
  late final Core core = context.read<Core>();

  ViewNavigationArguments get arguments => widget.arguments as ViewNavigationArguments;
  Preference get preference => core.preference;

  @override
  void initState() {
    super.initState();
    albumInit();
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
  // void onClear() {
  //   Future.microtask(() {});
  // }
  // void onSearch(String word) {}
  // void onDelete(String word) {
  //   Future.delayed(Duration.zero, () {});
  // }

  late final AudioBucketType cache = core.collection.cacheBucket;
  late final FilterCommonType filter = core.albumFilter;
  late Iterable<AudioAlbumType> album;

  void albumInit() {
    album = core.albumList();
  }
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: widget.key,
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
        AlbumList(
          albums: album,
          controller: scrollController,
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
}
