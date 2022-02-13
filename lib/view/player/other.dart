part of 'main.dart';

class PlayerOther extends StatefulWidget {
  const PlayerOther({Key? key}) : super(key: key);

  @override
  _PlayerOtherState createState() => _PlayerOtherState();
}

class _PlayerOtherState extends State<PlayerOther> {
  late final Core core = context.read<Core>();
  late final Audio audio = core.audio;
  late final AudioPlayer player = audio.player;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      key: widget.key,
      delegate: SliverChildListDelegate(
        [
          queueContainer(),
          multiTaskContainer(),
          optionContainer(),
        ],
      ),
    );
  }

  Widget queueContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Queue'),
        ListTile(
          title: const Text('add: Dam Dal'),
          onTap: () {
            core.audio.queuefromTrack([3384]);
          },
        ),
        ListTile(
          title: const Text('add: AungPan'),
          onTap: () {
            core.audio.queuefromTrack([3876]);
          },
        ),
        ListTile(
          title: const Text('add: Album'),
          onTap: () {
            core.audio.queuefromAlbum(["406c19550987baa8c368"]);
          },
        ),
      ],
    );
  }

  Widget multiTaskContainer() {
    return Column(
      children: [
        const Text('Multi task'),
        ListTile(
          title: const Text('Multi: download'),
          onTap: () {
            core.audio.trackDownload([89, 3384, 7]).then((value) {
              debugPrint('Downloaded');
            }).catchError((e) {
              debugPrint(e);
            });
          },
        ),
        ListTile(
          title: const Text('Multi: delete'),
          onTap: () {
            core.audio.trackDelete([89, 3384, 7]).then((value) {
              debugPrint('Deleted');
            }).catchError((e) {
              debugPrint(e);
            });
          },
        ),
      ],
    );
  }

  Widget optionContainer() {
    return Column(
      children: [
        const Text('Check'),
        ListTile(
          title: const Text('is available?'),
          onTap: () {
            core.audio.trackUrlById(3384).then((value) {
              debugPrint('$value');
            });
          },
        ),
        ListTile(
          title: const Text('download'),
          onTap: () {
            audio.trackDownload([3384]).then((value) {
              debugPrint('downloaded');
            }).catchError((e) {
              debugPrint(e);
            });
          },
        ),
        ListTile(
          title: const Text('delete'),
          onTap: () {
            audio.trackDelete([3384]).then((value) {
              debugPrint('deleted');
            }).catchError((e) {
              debugPrint(e);
            });
          },
        ),
      ],
    );
  }
}
