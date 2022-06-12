part of ui.widget;

// NOTE: view -> artist-list
class ArtistList extends StatefulWidget {
  final Iterable<AudioArtistType> artists;
  final ScrollController? controller;
  final int limit;
  final EdgeInsetsGeometry padding;

  final bool? primary;
  final bool shrinkWrap;

  const ArtistList({
    Key? key,
    required this.artists,
    this.controller,
    this.limit = 17,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.primary,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  ArtistListState createState() => ArtistListState();
}

class ArtistListState extends State<ArtistList> {
  late final Core core = context.read<Core>();

  Iterable<AudioArtistType> get artist => widget.artists;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetListBuilder(
      key: widget.key,
      primary: widget.primary,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      duration: const Duration(milliseconds: 320),
      // itemSnap: const ArtistListItemHolder(),
      itemSnap: (context, index) {
        return const ArtistListItemHolder();
      },
      itemBuilder: (context, index) {
        return ArtistListItem(context: context, artist: artist.elementAt(index));
      },
      itemCount: artist.length,
    );

    // return Padding(
    //   padding: widget.padding,
    //   child: ListView.builder(
    //     key: widget.key,
    //     padding: EdgeInsets.zero,
    //     itemCount: artist.length,
    //     primary: false,
    //     shrinkWrap: true,
    //     itemBuilder: (context, index) {
    //       return FutureBuilder<bool>(
    //         future: Future.delayed(const Duration(milliseconds: 320), () => true),
    //         builder: (_, snap) {
    //           if (snap.hasData == false) return const ArtistListItemHolder();
    //           return ArtistListItem(context: context, artist: artist.elementAt(index));
    //         },
    //       );
    //     },
    //   ),
    // );
  }
}

// NOTE: view -> home -> album-info -> aritst-info
class ArtistBlock extends StatefulWidget {
  final Iterable<int> artists;
  final ScrollController? controller;
  // final String? label;

  final Widget? headerTitle;
  final Widget? headerTrailing;

  final int limit;
  final bool routePush;
  final bool wrap;
  final EdgeInsetsGeometry? padding;
  final bool? primary;
  final bool showMoreIf;

  const ArtistBlock({
    Key? key,
    required this.artists,
    this.controller,
    // this.label,

    this.headerTitle,
    this.headerTrailing,
    this.limit = 17,
    this.routePush = true,
    this.wrap = true,
    this.padding,
    this.primary,
    this.showMoreIf = true,
  }) : super(key: key);

  @override
  ArtistBlockState createState() => ArtistBlockState();
}

class ArtistBlockState extends State<ArtistBlock> {
  AudioBucketType get cache => core.collection.cacheBucket;

  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;

  int _page = 0;
  int _take = 0;
  int get _limit => widget.limit;

  ScrollController get controller => widget.controller!;
  bool get hasController => widget.controller != null;

  List<int> get artistAll => widget.artists.toList();
  final List<int> artist = [];

  int get total => artistAll.length;
  int get count => artist.length;
  bool get _hasMore => _take < total;

  @override
  void initState() {
    super.initState();

    _take = min(_limit, total);
    artist.addAll(artistAll.getRange(_page, _take));
    if (hasController) {
      controller.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (hasController) {
      controller.removeListener(_scrollListener);
    }
  }

  void _scrollListener() {
    if (_hasMore && controller.position.extentAfter < 50) {
      loadMore();
    }
  }

  void loadMore() {
    if (_hasMore) {
      _page = _page + _limit;
      _take = min(_take + _limit, total);
      setState(() {
        artist.addAll(artistAll.getRange(_page, _take));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetBlockSection(
      primary: widget.primary,
      padding: widget.padding,
      show: count > 0,
      headerLeading: widget.wrap
          ? null
          : const WidgetLabel(
              icon: LideaIcon.artist,
              iconSize: 22,
            ),
      headerTitle: widget.headerTitle,
      headerTrailing: widget.headerTrailing,
      footerTrailing: (widget.showMoreIf && _hasMore)
          ? WidgetButton(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              // elevation: 1,
              color: Theme.of(context).shadowColor.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              show: _hasMore,
              onPressed: loadMore,
              child: WidgetLabel(
                label: preference.text.moreOfTotal(count, total),
              ),
            )
          : null,
      child: widget.wrap ? childWrap() : childBlock(),
    );
  }

  Card childBlock() {
    return Card(
      child: WidgetListBuilder(
        primary: false,
        itemCount: count,
        itemBuilder: (_, index) {
          return ArtistListItem(
            context: context,
            artist: cache.artistById(
              artist.elementAt(index),
            ),
          );
        },
        // itemSeparator: (_, index) {
        //   return const Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 15),
        //     child: Divider(height: 1),
        //   );
        // },
      ),
    );
  }

  Wrap childWrap() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,

      children: List.generate(
        count,
        (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
            child: ArtistBlockItem(
              context: context,
              routePush: widget.routePush,
              // artist: artist.elementAt(index),
              artist: cache.artistById(
                artist.elementAt(index),
              ),
            ),
          );
        },
      ),
      // children: List.generate(
      //   count + 1,
      //   (index) {
      //     final inRange = index == count;
      //     if (inRange) {
      //       if (_hasMore) {
      //         return Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      //           child: ArtistBlockMore(
      //             // more: 'more * of ?',
      //             more: preference.text.moreOfTotal(count, total),
      //             total: total,
      //             count: count,
      //             onPressed: _hasMore ? loadMore : null,
      //           ),
      //         );
      //       }
      //       return const SizedBox();
      //     }
      //     return Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      //       child: ArtistBlockItem(
      //         context: context,
      //         routePush: widget.routePush,
      //         // artist: artist.elementAt(index),
      //         artist: cache.artistById(
      //           artist.elementAt(index),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
