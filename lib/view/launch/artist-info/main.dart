import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';

import 'package:lidea/intl.dart' as intl;
// import 'package:lidea/provider.dart';
// import 'package:lidea/intl.dart';
// import 'package:lidea/sliver.dart';
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

  static const route = '/artist-info';
  static const icon = Icons.article;
  static const name = 'Artist';
  static const description = '...';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
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
    // Wrap();
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        bar(),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          sliver: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 150), () => true),
            builder: (_, snap) {
              if (snap.hasData) {
                return workingContainer();
              }
              return const SliverToBoxAdapter();
            },
          ),
        ),

        ArtistWrap(
          artists: artistRecommended,
          label: 'Recommeded',
          routePush: false,
          limit: 7,
        ),

        TrackFlat(
          tracks: artistTrackIds,
          label: 'Tracks (?)',
          showMore: '* / ?',
          limit: 3,
        ),

        ArtistWrap(
          artists: artistRelated,
          label: 'Related',
          routePush: false,
          limit: 5,
        ),
        // // ArtistWrap(artists: [3,9,8,12,60], heading: 'Related', limit: 5,),

        AlbumBoard(
          albums: artistAlbum,
          controller: scrollController,
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
      ],
    );
  }

  Widget workingContainer() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // StaticBadgeAttribute(icon: LideaIcon.listen, label: artistPlaysCount),
              StaticBadgeAttribute(
                icon: LideaIcon.listen,
                // label: albumPlaysCount,
                label: intl.NumberFormat.compact().format(artistPlaysCount),
              ),

              StaticBadgeAttribute(icon: LideaIcon.time, label: artistDuration),
              StaticBadgeAttribute(icon: LideaIcon.music, label: artistTrackCount),
              StaticBadgeAttribute(icon: LideaIcon.album, label: artistAlbumCount),
            ],
          ),
          TitleAttribute(
            text: artist.name,
            aka: artist.aka,
          ),
          YearWrap(year: artistYear),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlayAllAttribute(
                onPressed: _playAll,
              ),
              CacheWidget(
                context: context,
                trackIds: artistTrackIds,
                name: artist.name,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
