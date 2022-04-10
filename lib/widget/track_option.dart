part of ui.widget;
/*
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
  late final Box<LibraryType> box = core.collection.boxOfLibrary.box;
  LibraryType get likes => core.collection.valueOfLibraryLike;
  bool get hasLike => likes.list.contains(widget.trackId);

  AudioMetaType get track => cache.meta(widget.trackId);

  @override
  void initState() {
    super.initState();
    // final abc = track.artistInfo;
  }

  Future whenNavigate() {
    return Navigator.of(context).maybePop().whenComplete(() {
      return Future.delayed(const Duration(milliseconds: 200), () {
        if (Navigator.of(context).canPop()) Navigator.pop(context);
      });
    });
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
      scrollBehavior: const ViewScrollBehavior(),
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
        WidgetBlockSection(
          headerTitle: const WidgetLabel(
            alignment: Alignment.centerLeft,
            label: 'Like it?',
          ),
          child: Column(
            children: [
              ListTile(
                leading: const WidgetLabel(
                  icon: Icons.audiotrack,
                ),
                title: Text(
                  track.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                trailing: WidgetLabel(
                  icon: Icons.star_rounded,
                  iconColor: hasLike ? Theme.of(context).highlightColor : null,
                ),
                onTap: () {
                  if (hasLike) {
                    likes.list.remove(widget.trackId);
                  } else {
                    likes.list.add(widget.trackId);
                  }
                  if (likes.isInBox) {
                    likes.save();
                  } else {
                    box.add(likes);
                  }
                },
              ),
              ListTile(
                leading: const WidgetLabel(
                  icon: Icons.person,
                ),
                title: Wrap(
                  children: List.generate(
                    track.artistInfo.length,
                    (index) {
                      return ArtistWrapItem(
                        context: context,
                        artist: track.artistInfo.elementAt(index),
                        routePush: false,
                        whenNavigate: whenNavigate,
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                leading: const WidgetLabel(
                  // icon: LideaIcon.album,
                  icon: Icons.album,
                ),
                title: Text(track.album),
                onTap: () {
                  // Navigator.of(context).maybePop().whenComplete(() {
                  //   Future.delayed(const Duration(milliseconds: 200), () {
                  //     if (Navigator.of(context).canPop()) Navigator.pop(context);
                  //   }).whenComplete(() {});
                  // });
                  whenNavigate().whenComplete(() {
                    core.navigate(
                      to: '/album-info',
                      args: track.albumInfo,
                      routePush: false,
                    );
                  });
                },
              ),
              ListTile(
                title: Text.rich(
                  TextSpan(
                    text: 'Played: ',
                    children: [
                      TextSpan(
                        text: track.trackInfo.plays.toString(),
                      ),
                      TextSpan(
                        text: ', with duration: ',
                        children: [
                          TextSpan(
                            text: cache.duration(track.trackInfo.duration),
                          ),
                        ],
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  // style: Theme.of(context).textTheme.labelMedium,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                      ),
                ),
              ),
            ],
          ),
        ),

        // SliverPadding(
        //   padding: const EdgeInsets.fromLTRB(0, 15, 0, 25),
        //   sliver: FutureBuilder(
        //     future: Future.delayed(const Duration(milliseconds: 240), () => true),
        //     builder: (_, snap) {
        //       if (snap.hasData) {
        //         final items = box.values.where((e) => e.type > 2).toList();
        //         return playlistsContainer(items);
        //       }
        //       return const SliverToBoxAdapter();
        //     },
        //   ),
        // ),
        // FutureBuilder(
        //   future: Future.delayed(const Duration(milliseconds: 240), () => true),
        //   builder: (_, snap) {
        //     if (snap.hasData) {
        //       final items = box.values.where((e) => e.type > 2).toList();
        //       return playlistsContainer(box.values.where((e) => e.type > 2).toList());
        //     }
        //     return const SliverToBoxAdapter();
        //   },
        // ),
        playlistsContainer(box.values.where((e) => e.type > 2).toList()),
      ],
    );
  }

  Widget playlistsContainer(List<LibraryType> items) {
    return WidgetBlockSection(
      headerTitle: WidgetLabel(
        alignment: Alignment.centerLeft,
        label: preference.text.playlist(true),
      ),
      headerTrailing: WidgetButton(
        // child: const Icon(Icons.add_rounded),
        child: const WidgetLabel(
          icon: Icons.add_rounded,
        ),
        message: preference.text.addMore(preference.text.playlist(true)),
        onPressed: () {
          doConfirmWithWidget(
            context: context,
            child: const PlayListsEditor(),
          );
        },
      ),
      child: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 240), () => items.isNotEmpty),
        builder: (_, snap) {
          if (snap.hasData) {
            return ListView.separated(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                final item = items.elementAt(index);
                final hasAdded = item.list.contains(widget.trackId);
                return ListTile(
                  selected: hasAdded,
                  // selectedColor: Theme.of(context).scaffoldBackgroundColor,
                  selectedColor: Theme.of(context).highlightColor,

                  leading: WidgetMark(
                    icon: hasAdded ? Icons.playlist_add_check_rounded : Icons.playlist_add_rounded,
                    iconSize: 35,
                  ),
                  title: Text(
                    item.name,
                  ),
                  trailing: WidgetMark(
                    label: item.list.length.toString(),
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
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    height: 1,
                  ),
                );
              },
            );
          }
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Text(
                preference.text.noItem(preference.text.playlist(true)),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
    // return SliverList(
    //   delegate: SliverChildListDelegate(
    //     <Widget>[
    //       Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             WidgetLabel(
    //               alignment: Alignment.centerLeft,
    //               label: preference.text.playlist(true),
    //             ),
    //             WidgetButton(
    //               // child: const Icon(Icons.add_rounded),
    //               child: WidgetLabel(
    //                 icon: Icons.add_rounded,
    //                 message: preference.text.addMore(preference.text.playlist(true)),
    //               ),
    //               onPressed: () {
    //                 doConfirmWithWidget(
    //                   context: context,
    //                   child: const PlayListsEditor(),
    //                 );
    //               },
    //             )
    //           ],
    //         ),
    //       ),
    //       if (items.isNotEmpty)
    //         ListView.separated(
    //           shrinkWrap: true,
    //           primary: false,
    //           physics: const NeverScrollableScrollPhysics(),
    //           itemCount: items.length,
    //           itemBuilder: (_, index) {
    //             final item = items.elementAt(index);
    //             final hasAdded = item.list.contains(widget.trackId);
    //             return ListTile(
    //               selected: hasAdded,
    //               selectedColor: Theme.of(context).highlightColor,
    //               // contentPadding: EdgeInsets.zero,
    //               contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
    //               // leading: const Icon(Icons.queue_music_rounded),
    //               leading: WidgetLabel(
    //                 // icon: Icons.queue_music_rounded,
    //                 // icon: Icons.playlist_add,
    //                 // icon: Icons.playlist_add_check,
    //                 icon: hasAdded ? Icons.playlist_add_check_rounded : Icons.playlist_add_rounded,
    //                 iconSize: 35,
    //               ),
    //               title: Text(
    //                 item.name,
    //               ),
    //               trailing: Text(
    //                 item.list.length.toString(),
    //               ),
    //               onTap: () {
    //                 if (hasAdded) {
    //                   item.list.remove(widget.trackId);
    //                 } else {
    //                   item.list.add(widget.trackId);
    //                 }
    //                 item.save();
    //               },
    //             );
    //           },
    //           separatorBuilder: (_, index) {
    //             return Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 15),
    //               child: Divider(
    //                 height: 1,
    //                 color: Theme.of(context).shadowColor,
    //               ),
    //             );
    //           },
    //         )
    //       else
    //         Padding(
    //           padding: const EdgeInsets.all(15),
    //           child: Center(
    //             child: Text(
    //               preference.text.noItem(preference.text.playlist(true)),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //         ),
    //     ],
    //   ),
    // );
  }
}

*/