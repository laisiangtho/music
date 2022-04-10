// part of 'main.dart';
/*
class _Detail extends StatefulWidget {
  const _Detail({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<_Detail> {
  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;
  late final Audio audio = core.audio;

  // late final AudioBucketType cache = core.collection.cacheBucket;
  // late final _fieldController = TextEditingController();

  // final AudioMetaType track;
  // Audio get audio => core.audio;
  // late final AudioBucketType cache = core.collection.cacheBucket;
  late final Box<LibraryType> box = core.collection.boxOfLibrary.box;

  LibraryType get library => box.values.firstWhere((e) => e.key == widget.index);
  Iterable<AudioMetaType> get trackMeta => audio.metaById(library.list);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return ValueListenableBuilder(
          valueListenable: box.listenable(keys: [widget.index]),
          builder: (context, Box<LibraryType> o, child) {
            if (o.containsKey(widget.index)) {
              return scrollView(scrollController);
            }
            return child!;
          },
          child: const SizedBox(),
        );
      },
    );
  }

  CustomScrollView scrollView(ScrollController scrollController) {
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
              // snap: false,
              // centerTitle: true,
              elevation: 0.2,
              forceElevated: innerBoxIsScrolled,

              automaticallyImplyLeading: false,
              // leading: const Icon(
              //   Icons.queue_music_rounded,
              // ),
              leading: WidgetLabel(
                icon: Icons.queue_music_rounded,
                iconColor: Theme.of(context).hintColor,
              ),

              title: Text(
                library.name,
              ),

              actions: [
                WidgetButton(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: const WidgetLabel(
                    // icon: Icons.edit_rounded,
                    icon: LideaIcon.tools,
                    iconSize: 21,
                  ),
                  message: preference.text.renameTo(preference.text.playlist(false)),
                  onPressed: () {
                    doConfirmWithWidget(
                      context: context,
                      child: PlayListsEditor(
                        index: library.key,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          sliver: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 150), () => true),
            builder: (_, snap) {
              if (snap.hasData) {
                return optionsContainer();
              }
              return const SliverToBoxAdapter();
            },
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          sliver: SliverToBoxAdapter(
            // child: WidgetLabel(
            //   alignment: Alignment.centerLeft,
            //   label: preference.text.track(true),
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetLabel(
                  alignment: Alignment.centerLeft,
                  label: preference.text.track(true),
                ),
                CacheWidget(
                  context: context,
                  trackIds: library.list,
                  name: library.name,
                ),
              ],
            ),
          ),
        ),
        // SliverPadding(
        //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //   sliver: FutureBuilder(
        //     future: Future.delayed(const Duration(milliseconds: 200), () => true),
        //     builder: (_, snap) {
        //       if (snap.hasData && trackMeta.isNotEmpty) {
        //         return TrackList(
        //           // key: UniqueKey(),
        //           tracks: trackMeta,
        //         );
        //       }
        //       return SliverToBoxAdapter(
        //         child: Text(
        //           preference.text.noItem(preference.text.track(true)),
        //           textAlign: TextAlign.center,
        //         ),
        //       );
        //     },
        //   ),
        // ),

        TrackList(
          key: const Key('library-track-list'),
          tracks: trackMeta,
          itemReorderable: (int oldIndex, int newIndex) async {
            if (oldIndex < newIndex) newIndex--;
            if (oldIndex == newIndex) return;

            final itemMoved = library.list.removeAt(oldIndex);
            library.list.insert(newIndex, itemMoved);
            library.save();

            final index = audio.queue.value.indexWhere((e) => int.parse(e.id) == itemMoved);
            if (index >= 0) {
              audio.moveQueueItem(oldIndex, index);
              // audio.updateMediaItem();
            }
          },
        ),
      ],
    );
  }

  Widget optionsContainer() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          if (library.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Text(
                library.description,
                textAlign: TextAlign.center,
              ),
            ),
          WidgetLabel(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            alignment: Alignment.centerLeft,
            label: preference.text.option(true),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       WidgetLabel(
          //         label: preference.text.option(true),
          //       ),
          //       CacheWidget(
          //         context: context,
          //         trackIds: library.list,
          //         name: library.name,
          //       ),
          //     ],
          //   ),
          // ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            leading: const Icon(
              Icons.play_arrow_rounded,
              size: 50,
            ),
            title: Text(
              preference.text.play(false),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: Text(library.list.length.toString()),
            onTap: () {
              if (library.list.isNotEmpty) {
                audio.queuefromTrack(library.list, group: true);
              }
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            leading: const Icon(
              Icons.delete,
              size: 50,
            ),
            title: Text(
              preference.text.delete,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () {
              // box.deleteAt(index);
              library.delete();
              Navigator.of(context).pop();
              // Future.microtask(() {
              //   // library.delete();
              //   // box.deleteAt(widget.index);
              //   // box.delete(widget.index);
              // });
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            leading: const Icon(
              Icons.clear_all,
              size: 50,
            ),
            title: Text(
              preference.text.reset,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () {
              library.list.clear();
              library.save();
            },
          ),
        ],
      ),
    );
  }
}

*/