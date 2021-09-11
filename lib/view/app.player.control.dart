part of 'app.dart';

class PlayControl extends StatelessWidget {
  // final Audio audio;
  // final bool showNavigation;

  // PlayControl({Key? key, required this.audio, this.showNavigation:true}) : super(key: key);

  // AudioPlayer get player => audio.player;
  final Core core;
  final bool showNavigation;

  PlayControl({Key? key, required this.core, this.showNavigation:true}) : super(key: key);

  Audio get audio => core.audio;
  AudioPlayer get player => audio.player;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: showNavigation?MainAxisSize.max:MainAxisSize.min,
      mainAxisAlignment: showNavigation?MainAxisAlignment.spaceBetween:MainAxisAlignment.spaceAround,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          // child: Container(
          //   key: Key(showNavigation.toString()),
          //   child: showNavigation?WidgetButton(
          //     label: "Album",
          //     child: Icon(
          //       ZaideihIcon.album,
          //       size: 25
          //     ),
          //     onPressed: ()=>null
          //   ):StreamBuilder<SequenceState?>(
          //     stream: player.sequenceStateStream,
          //     builder: (context, snapshot) => WidgetButton(
          //       label: "Previous",
          //       child: Icon(ZaideihIcon.play_previous,size: 22),
          //       onPressed: player.hasPrevious? player.seekToPrevious : null
          //     )
          //   )
          // ),
          child: Container(
            key: Key(showNavigation.toString()),
            child: showNavigation?buttonNavigation(
                label:"Lyric",
                index:1,
                child:Icon(
                  // ZaideihIcon.album,
                  Icons.segment,
                  size: 27
                )
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
        playToggle(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: Container(
            key: Key(showNavigation.toString()),
            child: showNavigation?buttonNavigation(
                label:"Playlist",
                index:2,
                child:Icon(
                  // ZaideihIcon.list_nested,
                  // CupertinoIcons.music_note_list,
                  Icons.queue_music,
                  size: 27
                )
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
              child: buttomPlayToggle(playerState, "Play")
            ),
            if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) Align(
              child: progressIndicate()
            )
          ],
        );
      },
    );
  }

  Widget buttomPlayToggle(PlayerState? playerState, label){
    // String label = "Play";
    IconData icon = Icons.play_circle_fill;
    if (playerState?.playing == true){
      icon = Icons.pause_circle_filled;
      label = "Pause";
    }
    return WidgetButton(
      label: label,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            child: Icon(icon,size: 42),
          ),
          Align(
            child: positionIndicate()
          )
        ]
      ),
      onPressed: audio.playOrPause
    );

  }

  Widget positionIndicate(){
    return StreamBuilder<AudioPositionType>(
      stream: audio.streamPositionData,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        final duration= positionData?.duration ?? Duration.zero;
        final position= positionData?.position ?? Duration.zero;
        final bufferedPosition = positionData?.bufferedPosition ?? Duration.zero;

        double value = bufferedPosition.inMilliseconds.toDouble();
        if (bufferedPosition.inMilliseconds > 0){
          value =(position.inMilliseconds/duration.inMilliseconds).clamp(0.0, 1.0).toDouble();
        }

        return SizedBox(
          width: 34,
          height: 34,
          child: CircularProgressIndicator(
            value:value,
            strokeWidth: 2,
            // color: Theme.of(context).backgroundColor,
            // color: Color(0xFFffa90a).withOpacity(0.5)
            color: Colors.orange.withOpacity(0.9)
          ),
        );
      },
    );
  }

  /// processingState == ProcessingState.loading || processingState == ProcessingState.buffering
  Widget progressIndicate(){
    return SizedBox(
      width: 32,
      height: 32,
      child: CircularProgressIndicator(
        // value: 0.7,
        strokeWidth: 8,
        // color: Theme.of(context).backgroundColor,
        color: Colors.orange
      ),
    );
  }

  Widget buttonNavigation({required String label, required Widget child,required int index}){
    return ValueListenableBuilder<int>(
      valueListenable: NotifyNavigationButton.navigation,
      builder: (a,currentIndex,abc){
        return WidgetButton(
          label: label,
          child: abc!,
          onPressed: currentIndex==index?null:() => NotifyNavigationButton.navigation.value = index
        );
      },
      child: child,
    );
  }
}

/*
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
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

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold)),
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
}
*/