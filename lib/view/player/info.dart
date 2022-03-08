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
  // LibraryType get likes => core.collection.valueOfLibraryLike;
  // bool get hasLike => likes.list.contains(track!.trackInfo.id);

  @override
  void initState() {
    super.initState();
  }

  Future whenNavigate() {
    return draggableController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AudioMetaType?>(
      stream: audio.streamMeta,
      builder: (context, snap) {
        if (snap.data == null) {
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
        return body(snap.data!);
      },
    );
  }

  Widget body(AudioMetaType track) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<LibraryType> box, child) {
            final like = core.collection.valueOfLibraryLike;
            final trackId = track.trackInfo.id;
            bool hasLike = like.list.contains(trackId);
            return ListTile(
              leading: const WidgetLabel(
                icon: Icons.audiotrack,
              ),
              title: Text(
                track.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              trailing: WidgetLabel(
                icon: Icons.star_rounded,
                iconColor: hasLike ? Theme.of(context).highlightColor : null,
              ),
              onTap: () {
                if (hasLike) {
                  like.list.remove(trackId);
                } else {
                  like.list.add(trackId);
                }
                if (like.isInBox) {
                  like.save();
                } else {
                  box.add(like);
                }
              },
            );
          },
        ),
        ListTile(
          leading: const WidgetLabel(
            icon: Icons.person,
          ),
          title: Wrap(
            children: List.generate(
              track.artistInfo.length,
              (index) {
                return ArtistWrapItem(
                  context: context,
                  artist: track.artistInfo.elementAt(index),
                  routePush: false,
                  whenNavigate: whenNavigate,
                );
              },
            ),
          ),
        ),
        ListTile(
          leading: const WidgetLabel(
            // icon: LideaIcon.album,
            icon: Icons.album,
          ),
          title: Text(track.album),
          onTap: () {
            whenNavigate().whenComplete(() {
              core.navigate(
                to: '/album-info',
                args: track.albumInfo,
                routePush: false,
              );
            });
          },
        ),
      ],
    );
  }
}
