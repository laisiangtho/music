part of ui.widget;

// NOTE: view -> album-list
class AlbumList extends StatefulWidget {
  final Iterable<AudioAlbumType> albums;
  final ScrollController? controller;
  final int limit;
  final EdgeInsetsGeometry padding;

  final bool? primary;
  final bool shrinkWrap;

  const AlbumList({
    Key? key,
    required this.albums,
    this.controller,
    this.limit = 51,
    this.padding = EdgeInsets.zero,
    this.primary,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  late final Core core = context.read<Core>();

  Iterable<AudioAlbumType> get album => widget.albums;

  @override
  Widget build(BuildContext context) {
    return WidgetGridBuilder(
      key: widget.key,
      primary: widget.primary,
      shrinkWrap: widget.shrinkWrap,
      duration: const Duration(milliseconds: 320),
      padding: widget.padding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        mainAxisExtent: 240,
      ),
      itemSnap: (BuildContext context, int index) {
        return const AlbumListItemHolder();
      },
      itemBuilder: (BuildContext context, int index) {
        return AlbumListItem(
          context: context,
          album: album.elementAt(index),
        );
      },
      itemCount: album.length,
    );
  }
}

// NOTE: view -> artist-info
class AlbumBoard extends StatefulWidget {
  final Iterable<AudioAlbumType> albums;
  final ScrollController? controller;

  final Widget? headerTitle;
  final Widget? headerTrailing;

  final int limit;
  final EdgeInsetsGeometry? padding;

  final bool? primary;
  final bool shrinkWrap;

  const AlbumBoard({
    Key? key,
    required this.albums,
    this.controller,
    this.headerTitle,
    this.headerTrailing,
    this.limit = 10,
    this.padding,
    this.primary,
    this.shrinkWrap = true,
  }) : super(key: key);

  @override
  _AlbumBoardState createState() => _AlbumBoardState();
}

class _AlbumBoardState extends State<AlbumBoard> {
  late final Core core = context.read<Core>();

  Iterable<AudioAlbumType> get album => widget.albums;

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
    return WidgetBlockSection(
      primary: widget.primary,
      headerLeading: const WidgetLabel(
        icon: LideaIcon.album,
        iconSize: 22,
      ),
      headerTitle: widget.headerTitle,
      headerTrailing: widget.headerTrailing,
      child: WidgetGridBuilder(
        primary: false,
        padding: widget.padding,
        scrollController: widget.controller,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300.0,
          mainAxisExtent: 200,
          // mainAxisExtent: 170,
          mainAxisSpacing: 7.0,
          crossAxisSpacing: 3.0,
          // childAspectRatio: 1.0,
        ),
        duration: const Duration(milliseconds: 320),
        itemSnap: (BuildContext context, int index) {
          return const AlbumListItemHolder();
        },
        itemBuilder: (BuildContext context, int index) {
          return AlbumPickItem(
            context: context,
            album: album.elementAt(index),
          );
        },
        itemCount: album.length,
      ),
    );
  }
}

// NOTE: view -> home
class AlbumFlat extends StatelessWidget {
  final BuildContext context;
  final Iterable<AudioAlbumType> album;
  final String? label;
  final Widget? more;
  final EdgeInsetsGeometry padding;
  final bool? primary;
  final bool shrinkWrap;

  const AlbumFlat({
    Key? key,
    required this.context,
    required this.album,
    this.label,
    this.more,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.primary,
    this.shrinkWrap = false,
  }) : super(key: key);

  Core get core => context.read<Core>();
  int get total => album.length;

  @override
  Widget build(BuildContext context) {
    return WidgetBlockSection(
      primary: primary,
      padding: padding,
      show: total > 0,
      headerLeading: const WidgetLabel(
        icon: LideaIcon.album,
        iconSize: 22,
      ),
      headerTitle: WidgetLabel(
        alignment: Alignment.centerLeft,
        label: label!.replaceFirst('?', total.toString()),
      ),
      headerTrailing: WidgetButton(
        child: more,
        onPressed: () => core.navigate(to: '/album-list'),
      ),
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
          left: 7,
          right: 7,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        clipBehavior: Clip.hardEdge,
        height: 200,
        child: WidgetListBuilder(
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          duration: const Duration(milliseconds: 320),
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          // physics: const NeverScrollableScrollPhysics(),
          // itemSnap: const AlbumPickItemHolder(),
          itemSnap: (context, index) {
            return const AlbumPickItemHolder();
          },
          itemBuilder: (BuildContext context, int index) {
            return AlbumPickItem(
              context: context,
              album: album.elementAt(index),
            );
          },
          itemCount: total,
        ),
      ),
    );
  }
}
