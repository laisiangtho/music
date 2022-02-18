part of 'main.dart';

class PlayerInfo extends StatefulWidget {
  const PlayerInfo({Key? key}) : super(key: key);

  @override
  _PlayerInfoState createState() => _PlayerInfoState();
}

class _PlayerInfoState extends State<PlayerInfo> {
  late final Core core = context.read<Core>();
  late final Audio audio = core.audio;
  late final Preference preference = core.preference;

  late final Box<LibraryType> box = core.collection.boxOfLibrary;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AudioMetaType?>(
      stream: audio.streamMeta,
      builder: (context, snapshot) {
        final meta = snapshot.data;

        if (meta == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 7),
            child: Center(
              child: Text(
                preference.language('Try hit the play button!'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Divider(),
              ),
              Text(
                meta.title,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  textDirection: TextDirection.ltr,
                  spacing: 7,
                  children: List<Widget>.generate(meta.artistInfo.length, (index) {
                    final artist = meta.artistInfo.elementAt(index);
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
                  meta.album,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                onPressed: () {
                  core.navigate(to: '/album-info', args: meta.albumInfo);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
