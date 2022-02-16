part of 'main.dart';

class TrackOption extends StatefulWidget {
  const TrackOption({
    Key? key,
    required this.trackId,
  }) : super(key: key);

  final int trackId;

  @override
  State<StatefulWidget> createState() => _TrackOptionState();
}

class _TrackOptionState extends State<TrackOption> {
  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;

  late final AudioBucketType cache = core.collection.cacheBucket;
  late final Box<LibraryType> box = core.collection.boxOfLibrary;

  AudioMetaType get track => cache.meta(widget.trackId);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<LibraryType> box, child) {
            return scrollView(scrollController, box);
          },
        );
      },
    );
  }

  CustomScrollView scrollView(ScrollController scrollController, Box<LibraryType> box) {
    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        SliverLayoutBuilder(
          builder: (BuildContext context, constraints) {
            final innerBoxIsScrolled = constraints.scrollOffset > 0;
            return SliverAppBar(
              pinned: true,
              floating: false,
              elevation: 0.2,
              forceElevated: innerBoxIsScrolled,
              automaticallyImplyLeading: false,
              leading: const WidgetLabel(
                icon: Icons.music_note_rounded,
              ),
              // collapsedHeight: kToolbarHeight,
              // expandedHeight: 90,
              title: Text(preference.text.track(false)),
            );
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                child: Text(
                  track.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                child: Text(
                  track.artist,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          sliver: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 240), () => true),
            builder: (_, snap) {
              if (snap.hasData) {
                return likeContainer(core.collection.valueOfLibraryLike);
              }
              return const SliverToBoxAdapter();
            },
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 25),
          sliver: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 240), () => true),
            builder: (_, snap) {
              if (snap.hasData) {
                final items = box.values.where((e) => e.type > 2).toList();
                return playlistsContainer(items);
              }
              return const SliverToBoxAdapter();
            },
          ),
        ),
      ],
    );
  }

  SliverList likeContainer(LibraryType item) {
    bool hasLike = item.list.contains(widget.trackId);
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            child: WidgetLabel(
              alignment: Alignment.centerLeft,
              label: 'Like it?',
            ),
          ),
          ListTile(
            selected: hasLike,
            selectedColor: Theme.of(context).highlightColor,
            minLeadingWidth: 60,
            // contentPadding: const EdgeInsets.all(10),
            // minVerticalPadding: 7,
            leading: WidgetLabel(
              // icon: hasLike ? Icons.favorite : Icons.favorite_border_rounded,
              // icon: hasLike ? Icons.grade_rounded : Icons.grade_outlined_,
              icon: hasLike ? Icons.grade_rounded : Icons.grade_outlined,
              iconSize: 50,
            ),

            title: Text.rich(
              TextSpan(
                text: '',
                children: [
                  TextSpan(
                    text: 'from ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                  ),
                  const TextSpan(text: '"'),
                  TextSpan(
                    text: track.album,
                    style: const TextStyle(fontSize: 20),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pop;
                        core.navigate(to: '/album-info', args: track.albumInfo);
                        // Navigator.of(context, rootNavigator: true).pop();
                        // Navigator.of(context).popUntil((route) => route.isFirst);
                        // core.navigate(to: '/album-info', args: track.albumInfo, routePush: false);
                      },
                  ),
                  const TextSpan(text: '", '),
                  TextSpan(
                    text: 'duration: ',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    children: [
                      TextSpan(
                        text: cache.duration(track.trackInfo.duration),
                      ),
                    ],
                  ),
                  TextSpan(
                    text: ' plays: ',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    children: [
                      TextSpan(
                        text: track.trackInfo.plays.toString(),
                      ),
                    ],
                  ),
                ],
              ),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            onTap: () {
              if (hasLike) {
                item.list.remove(widget.trackId);
              } else {
                item.list.add(widget.trackId);
              }
              if (item.isInBox) {
                item.save();
              } else {
                box.add(item);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget playlistsContainer(List<LibraryType> items) {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetLabel(
                  alignment: Alignment.centerLeft,
                  label: preference.text.playlist(true),
                ),
                WidgetButton(
                  // child: const Icon(Icons.add_rounded),
                  child: WidgetLabel(
                    icon: Icons.add_rounded,
                    message: preference.text.addMore(preference.text.playlist(true)),
                  ),
                  onPressed: () {
                    doConfirmWithWidget(
                      context: context,
                      child: const PlayListsEditor(),
                    );
                  },
                )
              ],
            ),
          ),
          if (items.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items.elementAt(index);
                final hasAdded = item.list.contains(widget.trackId);
                return ListTile(
                  selected: hasAdded,
                  selectedColor: Theme.of(context).highlightColor,
                  // contentPadding: EdgeInsets.zero,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  // leading: const Icon(Icons.queue_music_rounded),
                  leading: WidgetLabel(
                    // icon: Icons.queue_music_rounded,
                    // icon: Icons.playlist_add,
                    // icon: Icons.playlist_add_check,
                    icon: hasAdded ? Icons.playlist_add_check_rounded : Icons.playlist_add_rounded,
                    iconSize: 35,
                  ),
                  title: Text(
                    item.name,
                  ),
                  trailing: Text(
                    item.list.length.toString(),
                  ),
                  onTap: () {
                    if (hasAdded) {
                      item.list.remove(widget.trackId);
                    } else {
                      item.list.add(widget.trackId);
                    }
                    item.save();
                  },
                );
              },
              separatorBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).shadowColor,
                  ),
                );
              },
            )
          else
            Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Text(
                  preference.text.noItem(preference.text.playlist(true)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
