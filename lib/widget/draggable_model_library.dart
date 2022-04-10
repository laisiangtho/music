part of ui.widget;

class WidgetDraggableLibraryModel extends ViewDraggableSheetWidget {
  final int index;
  const WidgetDraggableLibraryModel({Key? key, required this.index}) : super(key: key);

  @override
  State<WidgetDraggableLibraryModel> createState() => _WidgetDraggableLibraryState();
}

class _WidgetDraggableLibraryState extends ViewDraggableSheetState<WidgetDraggableLibraryModel> {
  @override
  bool get persistent => false;
  @override
  double get initialSize => 0.5;
  @override
  double get minSize => 0.4;

  bool isDownloading = false;
  String message = '';

  late final Core core = context.read<Core>();
  late final Preference preference = core.preference;

  late final Audio audio = core.audio;

  late final Box<LibraryType> box = core.collection.boxOfLibrary.box;

  LibraryType get library => box.values.firstWhere((e) => e.key == widget.index);
  Iterable<AudioMetaType> get trackMeta => audio.metaById(library.list);

  @override
  Widget body() {
    return ValueListenableBuilder(
      valueListenable: box.listenable(keys: [widget.index]),
      builder: (context, Box<LibraryType> o, child) {
        if (o.containsKey(widget.index)) {
          return super.body();
        }
        return child!;
      },
      child: const SizedBox(),
    );
  }

  @override
  List<Widget> sliverWidgets() {
    return <Widget>[
      SliverAppBar(
        pinned: true,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: WidgetAppbarTitle(
          label: library.name,
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
      ),
      WidgetBlockSection(
        duration: const Duration(milliseconds: 150),
        headerTitle: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.option(true),
        ),
        child: ListBody(
          children: [
            if (library.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Text(
                  library.description,
                  textAlign: TextAlign.center,
                ),
              ),
            ListTile(
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
      ),
      WidgetBlockSection(
        headerTitle: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.track(true),
        ),
        headerTrailing: CacheWidget(
          context: context,
          trackIds: library.list,
          name: library.name,
        ),
        child: TrackList(
          key: const Key('library-track-list'),
          primary: false,
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
      ),
      // TrackList(
      //   key: const Key('library-track-list'),
      //   tracks: trackMeta,
      //   itemReorderable: (int oldIndex, int newIndex) async {
      //     if (oldIndex < newIndex) newIndex--;
      //     if (oldIndex == newIndex) return;

      //     final itemMoved = library.list.removeAt(oldIndex);
      //     library.list.insert(newIndex, itemMoved);
      //     library.save();

      //     final index = audio.queue.value.indexWhere((e) => int.parse(e.id) == itemMoved);
      //     if (index >= 0) {
      //       audio.moveQueueItem(oldIndex, index);
      //       // audio.updateMediaItem();
      //     }
      //   },
      // ),
    ];
  }
}
