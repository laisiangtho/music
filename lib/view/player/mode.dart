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
  // late final Box<LibraryType> box = core.collection.boxOfLibrary;

  @override
  Widget build(BuildContext context) {
    // double optSize = (70*(stretch-0.7)).clamp(0.0, 25).toDouble();
    return Row(
      key: widget.key,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // StreamBuilder<SequenceState?>(
        //   stream: audio.player.sequenceStateStream,
        //   builder: (_, snapshot) {
        //     final item = snapshot.data?.currentSource;
        //     if (item != null) {
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
        // StreamBuilder<AudioMetaType?>(
        //   stream: audio.streamMeta,
        //   builder: (_, snapshot) {
        //     final meta = snapshot.data;
        //     if (meta != null) {
        //       return star(meta.trackInfo.id);
        //     }
        //     return WidgetLabel(
        //       icon: Icons.grade_outlined,
        //       iconColor: Theme.of(context).focusColor,
        //       label: "Like",
        //     );
        //   },
        // ),

        StreamBuilder<AudioServiceRepeatMode>(
          stream: audio.playbackState.map((state) => state.repeatMode).distinct(),
          builder: (context, snapshot) {
            final repeatMode = snapshot.data ?? AudioServiceRepeatMode.none;
            const icons = [Icons.repeat_rounded, Icons.repeat_rounded, Icons.repeat_one_rounded];
            const cycleModes = [
              AudioServiceRepeatMode.none,
              AudioServiceRepeatMode.all,
              AudioServiceRepeatMode.one,
            ];
            const strMode = ['', 'All', 'One'];
            final index = cycleModes.indexOf(repeatMode);
            return WidgetButton(
              child: WidgetLabel(
                icon: icons[index],
                iconColor:
                    index == 1 ? Theme.of(context).highlightColor : Theme.of(context).hintColor,
                label: "Repeat",
              ),
              message: strMode.elementAt(index),
              onPressed: () {
                audio.setRepeatMode(
                    cycleModes[(cycleModes.indexOf(repeatMode) + 1) % cycleModes.length]);
              },
            );
          },
        ),

        StreamBuilder<bool>(
          stream: audio.playbackState.map((state) {
            return state.shuffleMode == AudioServiceShuffleMode.all;
          }).distinct(),
          builder: (context, snapshot) {
            final enable = snapshot.data ?? false;
            return WidgetButton(
              child: WidgetLabel(
                label: "Shuffle",
                icon: Icons.shuffle,
                iconColor: enable ? Theme.of(context).highlightColor : Theme.of(context).hintColor,
              ),
              onPressed: () async {
                await audio.setShuffleMode(
                    !enable ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none);
              },
            );
          },
        ),
      ],
    );
  }

  // Widget star(int trackId) {
  //   return ValueListenableBuilder(
  //     valueListenable: box.listenable(),
  //     builder: (context, Box<LibraryType> box, child) {
  //       // return scrollView(scrollController, box);
  //       return FutureBuilder(
  //         future: Future.delayed(const Duration(milliseconds: 240), () => true),
  //         builder: (_, snap) {
  //           if (snap.hasData) {
  //             final value = core.collection.valueOfLibraryLike;
  //             bool hasLike = value.list.contains(trackId);
  //             // return const Text('??');
  //             return WidgetButton(
  //               child: WidgetLabel(
  //                 icon: hasLike ? Icons.grade_rounded : Icons.grade_outlined,
  //                 iconColor:
  //                     hasLike ? Theme.of(context).highlightColor : Theme.of(context).hintColor,
  //                 label: "Like",
  //               ),
  //               onPressed: () {
  //                 if (hasLike) {
  //                   value.list.remove(trackId);
  //                 } else {
  //                   value.list.add(trackId);
  //                 }
  //                 if (value.isInBox) {
  //                   value.save();
  //                 } else {
  //                   box.add(value);
  //                 }
  //               },
  //             );
  //           }
  //           return const SizedBox();
  //         },
  //       );
  //     },
  //   );
  // }
}
