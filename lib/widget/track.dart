part of ui.widget;

class TrackList extends StatefulWidget {
  final Iterable<AudioMetaType> tracks;
  final EdgeInsetsGeometry padding;
  // final ScrollController? controller;
  // final int limit;

  final bool? primary;
  final bool shrinkWrap;

  final void Function(int, int)? itemReorderable;

  const TrackList({
    Key? key,
    required this.tracks,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    // this.controller,
    // this.limit = 17,
    this.primary,
    this.shrinkWrap = true,
    this.itemReorderable,
  }) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;

  // bool get reorderable => itemReorderable != null;
  late final reorderable = widget.itemReorderable != null;

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
      primary: widget.primary,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      physics: const NeverScrollableScrollPhysics(),
      duration: const Duration(milliseconds: 320),
      // itemSnap: const TrackListItemHolder(),
      itemSnap: (context, index) {
        return const TrackListItemHolder();
      },
      itemVoid: Text(
        preference.text.noItem(preference.text.track(true)),
        textAlign: TextAlign.center,
      ),
      itemBuilder: (context, index) {
        return TrackListItem(
          // key: ValueKey(index),
          context: context,
          index: index,
          track: widget.tracks.elementAt(index),
          reorderable: reorderable,
        );
      },
      itemReorderable: widget.itemReorderable,
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
  // '* / ?'
  final String? showMore;
  final int milliseconds;
  final EdgeInsetsGeometry? padding;
  final bool? primary;

  const TrackFlat({
    Key? key,
    required this.tracks,
    this.controller,
    this.limit = 17,
    this.label,
    this.showMore,
    this.milliseconds = 0,
    this.padding,
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
    return WidgetBlockSection(
      primary: widget.primary,
      padding: widget.padding,
      show: count > 0,
      headerLeading: const WidgetLabel(
        icon: LideaIcon.track,
      ),
      headerTitle: WidgetLabel(
        alignment: Alignment.centerLeft,
        label: widget.label!.replaceFirst('?', total.toString()),
      ),
      child: Card(
        // margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: WidgetListBuilder(
          // key: const Key('track-list'),
          primary: false,
          // padding: EdgeInsets.zero,
          duration: const Duration(milliseconds: 320),
          physics: const NeverScrollableScrollPhysics(),
          // itemSnap: const TrackListItemHolder(key: Key('$index')),
          itemSnap: (context, index) {
            return TrackListItemHolder(key: ValueKey(index));
          },
          itemBuilder: (context, index) {
            return TrackListItem(
              key: ValueKey(index),
              context: context,
              index: index,
              track: cache.meta(track.elementAt(index)),
            );
          },

          itemCount: count,
        ),
      ),
      // widget.showMore != null && _hasMore
      footerTrailing: (widget.showMore != null && _hasMore)
          ? WidgetButton(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              // elevation: 1,
              color: Theme.of(context).shadowColor.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: WidgetLabel(
                // alignment: Alignment.centerRight,
                label: widget.showMore!
                    .replaceFirst('*', count.toString())
                    .replaceFirst('?', total.toString()),
              ),
              onPressed: _hasMore ? loadMore : null,
            )
          : null,
    );
  }
}
