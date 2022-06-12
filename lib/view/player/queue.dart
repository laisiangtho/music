part of 'main.dart';

class PlayerQueue extends StatefulWidget {
  const PlayerQueue({Key? key}) : super(key: key);

  @override
  State<PlayerQueue> createState() => _PlayerQueueState();
}

class _PlayerQueueState extends State<PlayerQueue> {
  late final Core core = context.read<Core>();
  late final Audio audio = core.audio;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: StreamBuilder<AudioQueueStateType>(
        stream: audio.streamQueueState,
        builder: (context, snapshot) {
          final queueState = snapshot.data ?? AudioQueueStateType.empty;
          final queue = queueState.queue;
          return ReorderableListView(
            key: UniqueKey(),
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) newIndex--;
              audio.moveQueueItem(oldIndex, newIndex);
            },
            children: [
              for (var i = 0; i < queue.length; i++)
                Dismissible(
                  key: ValueKey(queue[i].id),
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  onDismissed: (dismissDirection) {
                    audio.removeQueueItemAt(i);
                  },
                  child: Material(
                    color: i == queueState.queueIndex ? Colors.grey.shade300 : null,
                    child: ListTile(
                      title: Text(queue[i].title),
                      onTap: () => audio.skipToQueueItem(i),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
