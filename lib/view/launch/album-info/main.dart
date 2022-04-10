import 'package:flutter/material.dart';

import 'package:lidea/intl.dart' as intl;
// import 'package:lidea/provider.dart';
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

  static const route = '/album-info';
  static const icon = Icons.article;
  static const name = 'Album';
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
        heights: const [kToolbarHeight, 50],
        overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: bar,
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StaticBadgeAttribute(
                    icon: LideaIcon.listen,
                    // label: albumPlaysCount,
                    label: intl.NumberFormat.compact().format(albumPlaysCount),
                  ),
                  StaticBadgeAttribute(
                    icon: LideaIcon.time,
                    label: albumDuration,
                  ),
                  StaticBadgeAttribute(
                    icon: LideaIcon.music,
                    label: albumTrackCount,
                  ),
                ],
              ),
              TitleAttribute(text: albumName),
              YearWrap(year: albumYear),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlayAllAttribute(
                    onPressed: _playAll,
                  ),
                  CacheWidget(
                    context: context,
                    trackIds: albumTrackIds,
                    name: album.name,
                  ),
                ],
              ),
              GenreWrap(
                genre: albumGenre,
              ),
            ],
          ),
        ),
      ),
      ArtistWrap(
        artists: albumArtists,
      ),
      TrackList(
        // key: UniqueKey(),
        tracks: albumTrack,
      ),
      // Selector<ViewScrollNotify, double>(
      //   selector: (_, e) => e.bottomPadding,
      //   builder: (context, bottomPadding, child) {
      //     return SliverPadding(
      //       padding: EdgeInsets.only(bottom: bottomPadding),
      //       sliver: child,
      //     );
      //   },
      // ),
    ];
  }
}
