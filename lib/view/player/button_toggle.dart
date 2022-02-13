part of 'main.dart';

class PlayerButtonToggle extends StatefulWidget {
  const PlayerButtonToggle({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayerButtonToggle> createState() => _PlayerButtonToggleState();
}

class _PlayerButtonToggleState extends State<PlayerButtonToggle> {
  late final Core core = context.read<Core>();
  late final Audio audio = core.audio;

  // AudioPlayer get player => audio.player;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      key: widget.key,
      stream: audio.player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final pOS = playerState?.processingState;

        bool isProcessing = pOS == ProcessingState.loading || pOS == ProcessingState.buffering;

        return WidgetButton(
          // padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).hoverColor.withOpacity(0.1),
              width: 2,
            ),
            color: Theme.of(context).shadowColor,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: WidgetLabel(
                    icon: playerIcons,
                  ),
                ),
                if (isProcessing)
                  SizedBox(
                    child: CircularProgressIndicator(
                      value: 0.7,
                      strokeWidth: 2,
                      color: Theme.of(context).highlightColor.withOpacity(0.3),
                    ),
                  )
                else
                  SizedBox(
                    child: StreamBuilder<AudioPositionType>(
                      stream: audio.streamPositionData,
                      builder: (_, snapshot) {
                        final positionData = snapshot.data;
                        final duration = positionData?.duration ?? Duration.zero;
                        final position = positionData?.position ?? Duration.zero;
                        // final bufferedPosition = positionData?.bufferedPosition ?? Duration.zero;

                        return CircularProgressIndicator(
                          value: (position.inMilliseconds / duration.inMilliseconds)
                              .clamp(0.0, 1.0)
                              .toDouble(),
                          // value: 0.5,
                          strokeWidth: 2,
                          color: Theme.of(context).hintColor.withOpacity(0.3),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          onPressed: playerAction,
        );
      },
    );
  }

  IconData get playerIcons {
    final playerState = audio.player.playerState;
    final pOS = playerState.processingState;

    if (playerState.playing != true) {
      return Icons.play_arrow_rounded;
    } else if (pOS != ProcessingState.completed) {
      return Icons.pause_rounded;
    } else {
      return Icons.history_toggle_off_sharp;
    }
  }

  Function()? get playerAction {
    final playerState = audio.player.playerState;
    final pOS = playerState.processingState;

    if (playerState.playing) {
      return audio.player.pause;
    }

    if (pOS == ProcessingState.ready) {
      return audio.player.play;
    }

    if (pOS == ProcessingState.idle) {
      return audio.queuefromRandom;
    }
    return () => true;
  }
}
