part of 'main.dart';

class _Detail extends StatefulWidget {
  const _Detail({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<_Detail> {
  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;

  // late final AudioBucketType cache = core.collection.cacheBucket;
  // late final _fieldController = TextEditingController();

  // final AudioMetaType track;
  // Audio get audio => core.audio;
  // late final AudioBucketType cache = core.collection.cacheBucket;
  late final Box<LibraryType> box = core.collection.boxOfLibrary;

  Iterable<AudioMetaType> get trackMeta => core.audio.trackMetaById(library.list);
  LibraryType get library => box.values.firstWhere((e) => e.key == widget.index);

  @override
  void initState() {
    super.initState();
    // library.box?.watch();
    // final adfd =
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        // return scrollView(scrollController);

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
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
              leading: const WidgetLabel(
                icon: Icons.queue_music_rounded,
              ),

              title: Text(
                library.name,
              ),

              actions: [
                WidgetButton(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: WidgetLabel(
                    // icon: Icons.edit_rounded,
                    icon: LideaIcon.tools,
                    iconSize: 23,
                    message: preference.text.renameTo(preference.text.playlist(false)),
                  ),
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
        // SliverToBoxAdapter(
        //   child: CupertinoButton(
        //     child: const Text('Delete'),
        //     onPressed: () {
        //       // box.deleteAt(index);
        //       library.delete();
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ),
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
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          sliver: SliverToBoxAdapter(
            child: WidgetLabel(
              alignment: Alignment.centerLeft,
              label: preference.text.track(true),
            ),
          ),
        ),

        // Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
        //     child: ,
        //   ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          sliver: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 200), () => true),
            builder: (_, snap) {
              if (snap.hasData && trackMeta.isNotEmpty) {
                return TrackList(
                  // key: UniqueKey(),
                  tracks: trackMeta,
                );
              }
              return SliverToBoxAdapter(
                child: Text(
                  preference.text.noItem(preference.text.track(true)),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
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
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: Text(
                library.description,
                textAlign: TextAlign.center,
              ),
            ),
          WidgetLabel(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            alignment: Alignment.centerLeft,
            label: preference.text.option(true),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            leading: const Icon(
              Icons.play_arrow_rounded,
              size: 35,
            ),
            title: Text(
              preference.text.play(false),
              style: Theme.of(context).textTheme.headline5,
            ),
            trailing: Text(library.list.length.toString()),
            onTap: () {
              if (library.list.isNotEmpty) {
                core.audio.queuefromTrack(library.list, group: true);
              }
              // core.audio.queuefromRandom;
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            leading: const Icon(
              Icons.delete,
              size: 35,
            ),
            title: Text(
              preference.text.delete,
              style: Theme.of(context).textTheme.headline5,
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
              size: 35,
            ),
            title: Text(
              preference.text.reset,
              style: Theme.of(context).textTheme.headline5,
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
