// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/extension.dart';
// import 'package:lidea/intl.dart';
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

  static const route = '/artist-list';
  static const icon = Icons.low_priority_outlined;
  static const name = 'Artists';
  static const description = '...';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late final scrollController = ScrollController();
  late final Core core = context.read<Core>();

  ViewNavigationArguments get arguments => widget.arguments as ViewNavigationArguments;
  // AudioAlbumType get album => arguments.meta as AudioAlbumType;

  // SettingsController get settings => context.read<SettingsController>();
  // AppLocalizations get translate => AppLocalizations.of(context)!;
  // Authentication get authenticate => context.read<Authentication>();
  Preference get preference => core.preference;

  @override
  void initState() {
    super.initState();
    artistInit();
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
  late final FilterCommonType filter = core.artistFilter;
  late Iterable<AudioArtistType> artist;

  void artistInit() {
    artist = core.artistList();
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
      // primary: true,
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        ArtistList(artists: artist, controller: scrollController),
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
