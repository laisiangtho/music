part of 'main.dart';

class PlayerInfo extends StatefulWidget {
  const PlayerInfo({Key? key}) : super(key: key);

  @override
  _PlayerInfoState createState() => _PlayerInfoState();
}

class _PlayerInfoState extends State<PlayerInfo> {
  late final Core core = context.read<Core>();
  late final Audio audio = core.audio;
  late final AudioPlayer player = audio.player;

  late final Box<LibraryType> box = core.collection.boxOfLibrary;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      key: widget.key,
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state != null && state.sequence.isNotEmpty) {
          final sequence = state.sequence;
          final index = state.currentIndex;
          final item = sequence.elementAt(index);
          AudioMetaType tag = item.tag;
          AudioTrackType track = tag.trackInfo;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: Divider(),
                ),
                Text(
                  track.title,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    textDirection: TextDirection.ltr,
                    spacing: 7,
                    children: List<Widget>.generate(tag.artistInfo.length, (index) {
                      final artist = tag.artistInfo.elementAt(index);
                      return WidgetButton(
                        child: WidgetLabel(
                          label: artist.name,
                          labelStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        onPressed: () {
                          core.navigate(to: '/artist-info', args: artist, routePush: true);
                        },
                      );
                    }),
                  ),
                ),
                WidgetButton(
                  child: Text(
                    tag.album,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  onPressed: () {
                    core.navigate(to: '/album-info', args: tag.albumInfo);
                  },
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 7),
            child: Center(
              child: Text(
                'Try hit the play button!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        }
      },
    );
  }
}
