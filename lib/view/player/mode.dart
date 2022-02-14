part of 'main.dart';

class PlayerMode extends StatefulWidget {
  const PlayerMode({Key? key}) : super(key: key);

  @override
  _PlayerModeState createState() => _PlayerModeState();
}

class _PlayerModeState extends State<PlayerMode> {
  late final Core core = context.read<Core>();
  late final Audio audio = core.audio;

  // AudioPlayer get player => audio.player;
  late final Box<LibraryType> box = core.collection.boxOfLibrary;

  @override
  Widget build(BuildContext context) {
    // double optSize = (70*(stretch-0.7)).clamp(0.0, 25).toDouble();
    return Row(
      key: widget.key,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // const WidgetButton(
        //   child: WidgetLabel(
        //     icon: Icons.grade_outlined,
        //     label: "Like",
        //   ),
        // ),
        // StreamBuilder<int?>(
        //   stream: audio.player.currentIndexStream,
        //   builder: (_, snapshot) {
        //     final index = snapshot.data;
        //     final item = audio.player.sequenceState?.currentSource;
        //     if (index != null && item != null) {
        //       AudioMetaType tag = item.tag;
        //       return star(tag.trackInfo.id);
        //     }
        //     return WidgetLabel(
        //       icon: Icons.grade_outlined,
        //       iconColor: Theme.of(context).focusColor,
        //       label: "Like",
        //     );
        //   },
        // ),
        StreamBuilder<SequenceState?>(
          stream: audio.player.sequenceStateStream,
          builder: (_, snapshot) {
            final item = snapshot.data?.currentSource;
            if (item != null) {
              AudioMetaType tag = item.tag;
              return star(tag.trackInfo.id);
            }
            return WidgetLabel(
              icon: Icons.grade_outlined,
              iconColor: Theme.of(context).focusColor,
              label: "Like",
            );
          },
        ),
        StreamBuilder<LoopMode>(
          stream: audio.player.loopModeStream,
          builder: (context, snapshot) {
            // final loopMode = snapshot.data ?? LoopMode.off;
            // const icons = [Icons.repeat, Icons.repeat, Icons.repeat_one];
            // const cycleModes = [LoopMode.off, LoopMode.all, LoopMode.one];
            // const strMode = ['Off', 'All', 'One'];
            final loopMode = snapshot.data ?? LoopMode.all;
            const icons = [Icons.repeat, Icons.repeat_one];
            const cycleModes = [LoopMode.all, LoopMode.one];
            const strMode = ['All', 'One'];

            final indexMode = cycleModes.indexOf(loopMode);
            return WidgetButton(
              child: WidgetLabel(
                icon: icons[indexMode],
                iconColor:
                    indexMode == 1 ? Theme.of(context).highlightColor : Theme.of(context).hintColor,
                label: "Repeat",
                message: strMode.elementAt(indexMode),
              ),
              onPressed: () {
                audio.player.setLoopMode(cycleModes[(indexMode + 1) % cycleModes.length]);
              },
            );
          },
        ),
        StreamBuilder<bool>(
          stream: audio.player.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            final shuffleEnabled = snapshot.data ?? false;
            return WidgetButton(
              child: WidgetLabel(
                label: "Shuffle",
                icon: Icons.shuffle,
                // iconColor: shuffleEnabled ? Colors.orange : Colors.grey,
                iconColor:
                    shuffleEnabled ? Theme.of(context).highlightColor : Theme.of(context).hintColor,
              ),
              onPressed: () async {
                final enable = !shuffleEnabled;
                if (enable) {
                  await audio.player.shuffle();
                }
                await audio.player.setShuffleModeEnabled(enable);
              },
            );
          },
        ),
      ],
    );
  }

  Widget star(int trackId) {
    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<LibraryType> box, child) {
        // return scrollView(scrollController, box);
        return FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 240), () => true),
          builder: (_, snap) {
            if (snap.hasData) {
              final value = core.collection.valueOfLibraryLike;
              bool hasLike = value.list.contains(trackId);
              // return const Text('??');
              return WidgetButton(
                child: WidgetLabel(
                  icon: hasLike ? Icons.grade_rounded : Icons.grade_outlined,
                  iconColor:
                      hasLike ? Theme.of(context).highlightColor : Theme.of(context).hintColor,
                  label: "Like",
                ),
                onPressed: () {
                  if (hasLike) {
                    value.list.remove(trackId);
                  } else {
                    value.list.add(trackId);
                  }
                  if (value.isInBox) {
                    value.save();
                  } else {
                    box.add(value);
                  }
                },
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }
}
