part of 'main.dart';

class PlayerQueue extends StatefulWidget {
  const PlayerQueue({Key? key}) : super(key: key);

  @override
  State<PlayerQueue> createState() => _PlayerQueueState();
}

class _PlayerQueueState extends State<PlayerQueue> {
  late final Core core = context.read<Core>();
  late final Audio audio = core.audio;
  late final AudioPlayer player = audio.player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      key: widget.key,
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final sequence = state?.sequence ?? [];
        return SliverReorderableList(
          key: const Key('PlayQueueKey'),
          itemBuilder: (BuildContext context, int index) {
            return queueItem(index, index == state!.currentIndex, sequence.elementAt(index).tag);
          },
          itemCount: sequence.length,
          onReorder: (int oldIndex, int newIndex) {
            // if (oldIndex < newIndex) {
            //   newIndex -= 1;
            // }
            // if (oldIndex == newIndex) return;

            if (oldIndex < newIndex) newIndex--;
            audio.queue.move(oldIndex, newIndex);
          },
        );
      },
    );
  }

  // AudioMetaType tag
  Widget queueItem(int index, bool isCurrent, AudioMetaType tag) {
    // IndexedAudioSource item
    // AudioQueueType tag = item.tag;
    return Selector<Core, bool>(
      key: ValueKey(index),
      selector: (_, e) => e.audio.queueEditMode,
      builder: (BuildContext context, bool editQueue, Widget? child) {
        return ListTile(
          leading: editQueue
              ? WidgetButton(
                  child: const WidgetLabel(
                    icon: Icons.remove_circle_outline_rounded,
                    label: "Remove from Queue",
                  ),
                  onPressed: () {
                    audio.queueRemoveAtIndex(index);
                  },
                )
              : null,
          selected: isCurrent,
          selectedTileColor: Colors.orange,

          title: Text(tag.title),
          // selectedTileColor: Colors.brown,
          // selectedTileColor: Theme.of(context).,
          subtitle: Text(tag.artist),
          trailing: editQueue
              ? ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    child: Icon(LideaIcon.dragHandler, color: Colors.red, size: 25.0),
                  ),
                )
              : null,

          onTap: () {
            audio.queuePlayAtIndex(index);
          },
        );
      },
    );
  }
}
// class _PlayerQueueState extends State<PlayerQueue> {
//   late final Core core = context.read<Core>();
//   late final Audio audio = core.audio;
//   late final AudioPlayer player = audio.player;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<SequenceState?>(
//       stream: player.sequenceStateStream,
//       builder: (context, snapshot) {
//         final state = snapshot.data;
//         final sequence = state?.sequence ?? [];
//         return SliverReorderableList(
//           key: const Key('PlayQueueKey'),
//           itemBuilder: (BuildContext context, int index) =>
//               queueItem(index, index == state!.currentIndex, sequence.elementAt(index).tag),
//           itemCount: sequence.length,
//           onReorder: (int oldIndex, int newIndex) {
//             // if (oldIndex < newIndex) {
//             //   newIndex -= 1;
//             // }
//             // if (oldIndex == newIndex) return;

//             if (oldIndex < newIndex) newIndex--;
//             audio.queue.move(oldIndex, newIndex);
//           },
//         );
//       },
//     );
//   }

//   // AudioMetaType tag
//   Widget queueItem(int index, bool isCurrent, AudioMetaType tag) {
//     // IndexedAudioSource item
//     // AudioQueueType tag = item.tag;
//     return Selector<Core, bool>(
//       key: ValueKey(index),
//       selector: (_, e) => e.audio.queueEditMode,
//       builder: (BuildContext context, bool editQueue, Widget? child) {
//         return ListTile(
//           leading: editQueue
//               ? WidgetButton(
//                   child: const WidgetLabel(
//                     icon: Icons.remove_circle_outline_rounded,
//                     label: "Remove from Queue",
//                   ),
//                   onPressed: () {
//                     audio.queueRemoveAtIndex(index);
//                   },
//                 )
//               : null,
//           selected: isCurrent,
//           selectedTileColor: Colors.orange,

//           title: Text(tag.title),
//           // selectedTileColor: Colors.brown,
//           // selectedTileColor: Theme.of(context).,
//           subtitle: Text(tag.artist),
//           trailing: editQueue
//               ? ReorderableDragStartListener(
//                   index: index,
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
//                     child: Icon(LideaIcon.dragHandler, color: Colors.red, size: 25.0),
//                   ),
//                 )
//               : null,

//           onTap: () {
//             audio.queuePlayAtIndex(index);
//           },
//         );
//       },
//     );
//   }
// }
