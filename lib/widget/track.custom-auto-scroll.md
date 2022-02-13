# ?

```dart
part of 'main.dart';

class TrackList extends StatefulWidget {
  final Iterable<AudioMetaType> tracks;
  final ScrollController? controller;
  final int limit;
  final EdgeInsetsGeometry padding;

  final bool? primary;
  final bool shrinkWrap;

  const TrackList({
    Key? key,
    required this.tracks,
    this.controller,
    this.limit = 17,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.primary,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  late final Core core = context.read<Core>();

  int _page = 0;
  int _take = 0;
  int get _limit => widget.limit;

  ScrollController get controller => widget.controller!;
  bool get hasController => widget.controller != null;

  List<AudioMetaType> get trackAll => widget.tracks.toList();
  final List<AudioMetaType> track = [];

  int get total => trackAll.length;
  int get count => track.length;
  bool get _hasMore => _take < total;

  @override
  void initState() {
    super.initState();

    _take = min(_limit, total);
    track.addAll(trackAll.getRange(_page, _take));
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
        track.addAll(trackAll.getRange(_page, _take));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: widget.padding,
    //   child: ListView.builder(
    //     key: widget.key,
    //     padding: EdgeInsets.zero,
    //     itemCount: count,
    //     primary: false,
    //     shrinkWrap: true,
    //     itemBuilder: (context, index) {
    //       return FutureBuilder<bool>(
    //         // future: Future.microtask(() => true),
    //         future: Future.delayed(const Duration(milliseconds: 320), () => true),
    //         builder: (_, snap) {
    //           if (snap.hasData == false) return const TrackListItemHolder();
    //           return TrackListItem(
    //             context: context,
    //             track: track.elementAt(index),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );
    return WidgetListBuilder(
      key: widget.key,
      primary: widget.primary,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      physics: const NeverScrollableScrollPhysics(),
      duration: const Duration(milliseconds: 320),
      itemSnap: const TrackListItemHolder(),
      itemBuilder: (context, index) {
        return TrackListItem(
          context: context,
          track: track.elementAt(index),
        );
      },
      itemCount: track.length,
    );
  }
}

class TrackFlat extends StatefulWidget {
  // final Iterable<AudioMetaType> tracks;
  final Iterable<int> tracks;
  final ScrollController? controller;
  final int limit;
  final String? label;
  final String? showMore;
  final int milliseconds;
  final EdgeInsetsGeometry padding;
  final bool? primary;

  const TrackFlat({
    Key? key,
    required this.tracks,
    this.controller,
    this.limit = 17,
    this.label,
    this.showMore,
    this.milliseconds = 0,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.primary,
  }) : super(key: key);

  @override
  _TrackFlatState createState() => _TrackFlatState();
}

class _TrackFlatState extends State<TrackFlat> {
  late final Core core = context.read<Core>();
  AudioBucketType get cache => core.collection.cacheBucket;

  int _page = 0;
  int _take = 0;
  int get _limit => widget.limit;

  ScrollController get controller => widget.controller!;
  bool get hasController => widget.controller != null;

  late List<int> trackAll;
  final List<int> track = [];

  int get total => trackAll.length;
  int get count => track.length;
  bool get _hasMore => _take < total;

  @override
  void initState() {
    super.initState();

    trackAll = widget.tracks.toList();

    _take = min(_limit, total);
    track.addAll(trackAll.getRange(_page, _take));
    if (hasController) {
      controller.addListener(_scrollListener);
    }

    // final albumInfo = cache.albumById(track.uid);
    // final artistInfo = cache.artistList(track.artists);
    // final albumInfo = cache.albumById('b7972194028f41746445');
    // debugPrint('albumById  ${albumInfo.name}');
    // final artistInfo = cache.artistList([3]);
    // debugPrint('artistInfo  ${artistInfo.length}');
    // final abcs = cache.meta(1);
    // final abc = cache.track;
    // final abc = cache.track.firstWhere((e) => e.id == 1);
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
        track.addAll(trackAll.getRange(_page, _take));
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
                alignment: Alignment.centerLeft,
                label: widget.label!.replaceFirst('?', total.toString()),
              ),
            ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            // child: ListView.builder(
            //   key: const Key('track-list'),
            //   // padding: const EdgeInsets.all(0),
            //   padding: EdgeInsets.zero,
            //   itemCount: count,
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   primary: false,
            //   itemBuilder: (context, index) {
            //     return FutureBuilder<bool>(
            //       // future: Future.microtask(() => true),
            //       future: Future.delayed(const Duration(milliseconds: 320), () => true),
            //       builder: (_, snap) {
            //         if (snap.hasData == false) return const TrackListItemHolder();
            //         return TrackListItem(
            //           context: context,
            //           track: cache.meta(track.elementAt(index)),
            //         );
            //       },
            //     );
            //   },
            // ),
            child: WidgetListBuilder(
              key: const Key('track-list'),
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              duration: const Duration(milliseconds: 320),
              physics: const NeverScrollableScrollPhysics(),
              itemSnap: const TrackListItemHolder(),
              itemBuilder: (context, index) {
                return TrackListItem(
                  context: context,
                  track: cache.meta(track.elementAt(index)),
                );
              },
              itemCount: count,
            ),
          ),
          if (widget.showMore != null)
            WidgetBlockMore(
              more: widget.showMore!,
              total: total,
              count: count,
              onPressed: _hasMore ? loadMore : null,
            )
        ],
      ),
    );
  }
}
