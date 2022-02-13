part of 'main.dart';

class TrackList extends StatefulWidget {
  final Iterable<AudioMetaType> tracks;
  final EdgeInsetsGeometry padding;
  // final ScrollController? controller;
  // final int limit;

  final bool? primary;
  final bool shrinkWrap;

  const TrackList({
    Key? key,
    required this.tracks,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    // this.controller,
    // this.limit = 17,
    this.primary,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  late final Core core = context.read<Core>();

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
      physics: const NeverScrollableScrollPhysics(),
      duration: const Duration(milliseconds: 320),
      itemSnap: const TrackListItemHolder(),
      itemBuilder: (context, index) {
        return TrackListItem(
          context: context,
          track: widget.tracks.elementAt(index),
        );
      },
      itemCount: widget.tracks.length,
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
  }

  @override
  void dispose() {
    super.dispose();
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
