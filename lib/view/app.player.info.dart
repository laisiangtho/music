part of 'app.dart';

class PlayInfo extends StatefulWidget {
  PlayInfo({Key? key}) : super(key: key);

  @override
  _PlayInfoState createState() => _PlayInfoState();
}

class _PlayInfoState extends State<PlayInfo> {
  late Core core;

  Audio get audio => core.audio;
  AudioPlayer get player => audio.player;

  @override
  void initState() {
    super.initState();
    core = context.read<Core>();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 170
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          decoration: BoxDecoration(
            // color: Colors.
          ),
          child: StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state != null && state.sequence.length > 0){
                final sequence = state.sequence;
                final index = state.currentIndex;
                final item = sequence.elementAt(index);
                AudioMetaType tag = item.tag;
                return Column(
                  children: [
                    // Selector<Core, bool>(
                    //     builder: (context, value, child) {
                    //     return Text(value.toString());
                    //   },
                    //   selector: (_, e) => tag.trackInfo.queued,
                    // ),
                    Text(
                      tag.title,
                      style: Theme.of(context).textTheme.headline1,
                      strutStyle: StrutStyle(
                        height: 2.5
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        tag.artist,
                        style: Theme.of(context).textTheme.bodyText1,
                        strutStyle: StrutStyle(
                          height: 1.3
                        ),
                      ),
                    ),
                    Text(
                      tag.album,
                      style: Theme.of(context).textTheme.headline3!,
                      strutStyle: StrutStyle(
                        height: 2.3
                      ),
                    ),
                    // Text(
                    //   "${tag.isAvailable}: ${tag.uri.path} ",
                    //   style: Theme.of(context).textTheme.headline5!.copyWith(
                    //     // fontSize: 12
                    //   )
                    // ),
                    Container(
                      color: Colors.grey[300],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          WidgetButton(
                            label: "isAvailable",
                            child: Icon(
                              // CupertinoIcons.checkmark_shield
                              CupertinoIcons.shield_lefthalf_fill
                            ),
                            onPressed: () async => await audio.trackUrlById(tag.trackInfo.id).then(
                              (value) => print(value)
                            )
                          ),
                          WidgetButton(
                            label: "Download",
                            child: Icon(
                              CupertinoIcons.exclamationmark_shield_fill
                              // CupertinoIcons.cloud_download_fill
                            ),
                            onPressed: () async => await audio.trackDownload([tag.trackInfo.id]).then(
                              (_) async => await audio.queuefromTrack([tag.trackInfo.id])
                            ).catchError((e){
                              print(e);
                            })
                          ),
                          WidgetButton(
                            label: "Delete",
                            child: Icon(
                              CupertinoIcons.checkmark_shield_fill
                            ),
                            onPressed: () async => await audio.trackDelete([tag.trackInfo.id]).then(
                              (_) async => await audio.queuefromTrack([tag.trackInfo.id])
                            ).catchError((e){
                              print(e);
                            })
                          )
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Icon(ZaideihIcon.dot_horiz);
              }
            }
          ),
        ),
      )
    );
  }
}
