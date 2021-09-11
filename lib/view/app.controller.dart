// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:just_audio/just_audio.dart';
import 'package:lidea/provider.dart';

import 'package:music/core.dart';
import 'package:music/icon.dart';
import 'package:music/model.dart';
import 'package:music/widget.dart';

import 'app.common.dart';

class PlayControl extends StatelessWidget {
  final Audio audio;
  final bool showNavigation;

  PlayControl({Key? key, required this.audio, this.showNavigation:true}) : super(key: key);

  AudioPlayer get player => audio.player;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: showNavigation?MainAxisSize.max:MainAxisSize.min,
      mainAxisAlignment: showNavigation?MainAxisAlignment.spaceBetween:MainAxisAlignment.spaceAround,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // StreamBuilder<SequenceState?>(
        //   stream: player.sequenceStateStream,
        //   builder: (context, snapshot) => WidgetButton(
        //     label: "Previous",
        //     child: Icon(ZaideihIcon.play_previous,size: 22),
        //     onPressed: player.hasPrevious? player.seekToPrevious : null
        //   )
        // ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: Container(
            key: Key(showNavigation.toString()),
            child: showNavigation?WidgetButton(
              label: "Album",
              child: Icon(
                ZaideihIcon.album,
                size: 25
              ),
              onPressed: ()=>null
            ):StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) => WidgetButton(
                label: "Previous",
                child: Icon(ZaideihIcon.play_previous,size: 22),
                onPressed: player.hasPrevious? player.seekToPrevious : null
              )
            )
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: showNavigation?0:13),
        //   child: playToggle()
        // ),
        playToggle(),
        // StreamBuilder<SequenceState?>(
        //   stream: player.sequenceStateStream,
        //   builder: (context, snapshot) => WidgetButton(
        //     label: "Next",
        //     child: Icon(ZaideihIcon.play_next,size: 22),
        //     onPressed: player.hasNext? player.seekToNext : null
        //   )
        // ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: Container(
            key: Key(showNavigation.toString()),
            child: showNavigation?WidgetButton(
              label: "Artist",
              child: Icon(
                ZaideihIcon.artist,
                size: 22
              ),
              onPressed: ()=>null
            ):StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) => WidgetButton(
                label: "Next",
                child: Icon(ZaideihIcon.play_next,size: 22),
                onPressed: player.hasNext? player.seekToNext : null
              )
            )
          ),
        ),
      ]
    );
  }

  Widget buildtmp(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget playToggle(){
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        // final playing = playerState?.playing;

        return Stack(
          alignment: Alignment.center,
          children: [
            Align(
              child: playToggleButton(playerState)
            ),
            if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) Align(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  // value: 0.7,
                  strokeWidth: 8,
                  // color: Theme.of(context).backgroundColor,
                  color: Colors.orange
                ),
              )
            ),
          ],
        );
      },
    );
  }

  Widget playToggleButton(PlayerState? playerState){
    final processingState = playerState?.processingState;
    // final queue = audio.queue.length;
        // print('queue: $queue');
    // if (queue >= 0) {}
    if (playerState?.playing != true) {
      return WidgetButton(
        label: "Play",
        child: Icon(Icons.play_circle_fill,size: 42),
        onPressed: (){
          player.play().catchError(
            (e){
              print('e $e');
            }
          );
        }
      );
    } else if(processingState != ProcessingState.completed) {
      return WidgetButton(
        label: "Pause",
        // child: Icon(Icons.pause_circle_filled,size: 42),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              child: Icon(Icons.pause_circle_filled,size: 42),
            ),
            if (playerState?.playing == true) Align(
              child: StreamBuilder<AudioPositionType>(
                stream: audio.streamPositionData,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  final duration= positionData?.duration ?? Duration.zero;
                  final position= positionData?.position ?? Duration.zero;
                  // final bufferedPosition = positionData?.bufferedPosition ?? Duration.zero;
                  // return Container();

                  return SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      value: (position.inMilliseconds/duration.inMilliseconds).clamp(0.0, 1.0).toDouble(),
                      strokeWidth: 4,
                      // color: Theme.of(context).backgroundColor,
                      // color: Color(0xFFffa90a).withOpacity(0.5)
                      color: Colors.orange.withOpacity(0.7)
                    ),
                  );
                },
              ),
            )
          ]
        ),
        onPressed: player.pause
      );
    } else {
      return WidgetButton(
        label: "Help",
        child: Icon(Icons.help,size: 42),
        onPressed: () async {

          // print(player.effectiveIndices!.first);

          await audio.player.seek(Duration.zero, index: 0).catchError((e){
          });
          // player.seek(Duration.zero, index: player.effectiveIndices!.first).then(
          //   (e){
          //     print('Help ?1');
          //   }
          // );
        }
      );
    }
  }

}

class PlayInfo extends StatelessWidget {
  final Audio audio;

  PlayInfo({Key? key, required this.audio}) : super(key: key);

  AudioPlayer get player => audio.player;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: StreamBuilder<SequenceState?>(
        stream: player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state != null && state.sequence.length > 0){
            final sequence = state.sequence;
            final index = state.currentIndex;
            final item = sequence.elementAt(index);
            return Column(
              children: [
                Text(
                  item.tag.title,
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                    // fontSize: 12
                  )
                ),
                Text(
                  item.tag.album,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                    // fontSize: 12
                  )
                ),
              ],
            );
          } else {
            return Container(
              color: Colors.brown,
              child:Text('abc')
            );
          }
        }
      )
    );
  }

}

class PlayQueue extends StatelessWidget {
  final Core core;
  // final bool editQueue;

  PlayQueue({Key? key, required this.core}) : super(key: key);

  Audio get audio => core.audio;
  AudioPlayer get player => audio.player;
  // bool get editQueue => core.editQueueMode;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final sequence = state?.sequence ?? [];
        return SliverReorderableList(
          key: Key('PlayQueueKey'),
          itemBuilder:(BuildContext context, int index) => queueItem(
            index,
            index == state!.currentIndex,
            sequence.elementAt(index)
          ),
          itemCount:sequence.length,
          onReorder: (int oldIndex, int newIndex) {

            // if (oldIndex < newIndex) {
            //   newIndex -= 1;
            // }
            // if (oldIndex == newIndex) return;

            if (oldIndex < newIndex) newIndex--;
            audio.queue.move(oldIndex, newIndex);
          },
        );
      }
    );
  }

  Widget queueItem(int index, bool isCurrent, IndexedAudioSource item){
    // return Card(
    //   key: Key('$index'),
    //   child: Text(item.tag.title),
    // );Material
    return Selector<Core,bool>(
      key: ValueKey(index),
      selector: (_, e) => e.audio.queueEditMode,
      builder: (BuildContext context, bool editQueue, Widget? child) {
        return Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          child: ListTile(
            leading: editQueue?WidgetButton(
              label: "Remove from Queue",
              child: Icon(
                Icons.remove_circle_outline_rounded,
                color: Colors.red,
                size: 25.0
              ),
              onPressed: () => audio.queueRemoveAtIndex(index)
            ):Text('??'),
            // selected: isCurrent,
            title: Text(item.tag.title as String),
            // selectedTileColor: Colors.brown,
            // selectedTileColor: Theme.of(context).,
            subtitle: Text('Artist'),
            trailing: editQueue?ReorderableDragStartListener(
              index: index,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                child: Icon(
                  ZaideihIcon.drag_handle,
                  color: Colors.red,
                  size: 25.0
                ),
              ),
            ):Text('??'),

            onTap: () => audio.queuePlayAtIndex(index),
          ),
        );
      }
    );
  }
}

// final processingState = playerState?.processingState;
//     if (playerState?.playing != true) {
//       return WidgetButton(
//         label: "Play",
//         child: Icon(Icons.play_circle_fill,size: 42),
//         onPressed: player.play
//       );
//     }