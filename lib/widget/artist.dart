part of 'main.dart';

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
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  late Core core;

  Iterable<AudioArtistType> get artist => widget.artists;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
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
class ArtistWrap extends StatefulWidget {
  final Iterable<int> artists;
  final ScrollController? controller;
  final String? label;
  final int limit;
  final bool routePush;
  final EdgeInsetsGeometry padding;
  final bool? primary;

  const ArtistWrap({
    Key? key,
    required this.artists,
    this.controller,
    this.label,
    this.limit = 17,
    this.routePush = true,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.primary,
  }) : super(key: key);

  @override
  _ArtistWrapState createState() => _ArtistWrapState();
}

class _ArtistWrapState extends State<ArtistWrap> {
  AudioBucketType get cache => core.collection.cacheBucket;

  late Core core;

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
    core = context.read<Core>();

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
    return WidgetChildBuilder(
      primary: widget.primary,
      padding: widget.padding,
      show: count > 0,
      child: Column(
        children: [
          if (widget.label != null)
            WidgetBlockTile(
              title: WidgetLabel(
                // alignment: Alignment.centerLeft,
                label: widget.label!.replaceFirst('?', total.toString()),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              // textDirection: TextDirection.ltr,
              // alignment: WrapAlignment.start,
              // crossAxisAlignment: WrapCrossAlignment.start,
              // textDirection: TextDirection.ltr,
              children: List.generate(
                count + 1,
                (index) {
                  final inRange = index == count;
                  if (inRange) {
                    if (_hasMore) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                        child: ArtistWrapMore(
                          more: 'more * of ?',
                          total: total,
                          count: count,
                          onPressed: _hasMore ? loadMore : null,
                        ),
                      );
                    }
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                    child: ArtistWrapItem(
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
            ),
          ),
        ],
      ),
    );
  }
}
