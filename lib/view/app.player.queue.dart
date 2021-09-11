part of 'app.dart';

class PlayQueue extends StatelessWidget {
  final Core core;

  PlayQueue({Key? key, required this.core}) : super(key: key);

  Audio get audio => core.audio;
  AudioPlayer get player => audio.player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final sequence = state?.sequence ?? [];
        return SliverReorderableList(
          key: Key('PlayQueueKey'),
          itemBuilder:(BuildContext context, int index) => queueItem(
            index,
            index == state!.currentIndex,
            sequence.elementAt(index).tag
          ),
          itemCount:sequence.length,
          onReorder: (int oldIndex, int newIndex) {

            // if (oldIndex < newIndex) {
            //   newIndex -= 1;
            // }
            // if (oldIndex == newIndex) return;

            if (oldIndex < newIndex) newIndex--;
            audio.queue.move(oldIndex, newIndex);
          },
        );
      }
    );
  }

  // AudioMetaType tag
  Widget queueItem(int index, bool isCurrent, AudioMetaType tag){
    // IndexedAudioSource item
    // AudioQueueType tag = item.tag;
    return Selector<Core,bool>(
      key: ValueKey(index),
      selector: (_, e) => e.audio.queueEditMode,
      builder: (BuildContext context, bool editQueue, Widget? child) {
        return Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          child: ListTile(
            leading: editQueue?WidgetButton(
              label: "Remove from Queue",
              child: Icon(
                Icons.remove_circle_outline_rounded,
                color: Colors.red,
                size: 25.0
              ),
              onPressed: () => audio.queueRemoveAtIndex(index)
            ):Text('??'),
            selected: isCurrent,
            selectedTileColor: Colors.orange,

            title: Text(tag.title),
            // selectedTileColor: Colors.brown,
            // selectedTileColor: Theme.of(context).,
            subtitle: Text(tag.artist),
            trailing: editQueue?ReorderableDragStartListener(
              index: index,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                child: Icon(
                  ZaideihIcon.drag_handle,
                  color: Colors.red,
                  size: 25.0
                ),
              ),
            ):Text('??'),

            onTap: () => audio.queuePlayAtIndex(index),
          ),
        );
      }
    );
  }
}
