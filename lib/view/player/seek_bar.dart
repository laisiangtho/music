part of 'main.dart';

// class PlayerSeekBar extends StatefulWidget {
//   const PlayerSeekBar({Key? key}) : super(key: key);

//   @override
//   _PlayerSeekBarState createState() => _PlayerSeekBarState();
// }

// class _PlayerSeekBarState extends State<PlayerSeekBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class PlayerSeekBar extends StatefulWidget {
  // final double opacity;
  // final Duration duration;
  // final Duration position;
  // final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const PlayerSeekBar({
    Key? key,
    // required this.opacity,
    // required this.duration,
    // required this.position,
    // required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  _PlayerSeekBarState createState() => _PlayerSeekBarState();
}

class _PlayerSeekBarState extends State<PlayerSeekBar> {
  late final Core core = context.read<Core>();
  late final Audio audio = core.audio;

  late AudioPositionType? positionData;

  Duration get _duration => positionData?.duration ?? Duration.zero;
  Duration get _position => positionData?.position ?? Duration.zero;
  Duration get _bufferedPosition => positionData?.bufferedPosition ?? Duration.zero;
  Duration get _remaining => _duration - _position;

  // String time(Duration e) {
  //   // return RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch(e)?.group(1) ?? '$_duration';
  //   return RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch(e.toString())?.group(1) ?? '$e';
  // }

  bool get isCollapsed => false;
  // bool get isCollapsed => widget.opacity == 0.0;

  late final SliderThemeData _sliderThemeData = SliderTheme.of(context).copyWith(
    trackHeight: 1,
    activeTrackColor: Theme.of(context).highlightColor.withOpacity(0.5),
    inactiveTrackColor: Theme.of(context).shadowColor,
    thumbColor: Theme.of(context).shadowColor,
    trackShape: const RectangularSliderTrackShape(),
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7.0),
    overlayColor: Theme.of(context).highlightColor.withAlpha(32),
  );
  double? _dragValue;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AudioPositionType>(
      key: widget.key,
      stream: audio.streamPositionData,
      builder: (_, snap) {
        positionData = snap.data;
        // final ddd = _duration.inMilliseconds.toDouble();
        // final ppp = _position.inMilliseconds.toDouble();
        // final asdf = min(ppp, ddd);
        // debugPrint('_position.inMilliseconds $ddd $ppp $asdf');

        return SizedBox(
          height: 50,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0.90, -0.7),
                child: Text(
                  core.collection.cacheBucket.duration(_duration.inSeconds),
                  style: Theme.of(context).textTheme.overline,
                ),
              ),
              Align(
                alignment: const Alignment(-.90, -0.7),
                child: Text(
                  core.collection.cacheBucket.duration(_remaining.inSeconds),
                  style: Theme.of(context).textTheme.overline,
                ),
              ),
              Align(
                child: SliderTheme(
                  data: _sliderThemeData.copyWith(
                    thumbShape: HiddenThumbComponentShape(),
                    // overlayShape: RoundSliderOverlayShape(overlayRadius: isCollapsed ? 0.0 : 15.0),
                    // trackHeight: 7,
                    // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
                    // activeTrackColor: Colors.blue,
                    // inactiveTrackColor: Colors.grey,
                    // activeTrackColor: Colors.blue.shade100,
                    // inactiveTrackColor: Colors.grey.shade300,
                  ),
                  child: ExcludeSemantics(
                    child: Slider(
                      min: 0.0,
                      max: _duration.inMilliseconds.toDouble(),
                      value: _bufferedPosition.inMilliseconds.toDouble(),
                      // value: min(_bufferedPosition.inMilliseconds.toDouble(),
                      //     _duration.inMilliseconds.toDouble()),
                      onChanged: null,
                      onChangeEnd: null,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SliderTheme(
                  data: _sliderThemeData.copyWith(
                    // activeTrackColor: Colors.transparent,
                    inactiveTrackColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                  ),
                  child: Slider(
                    min: 0.0,
                    max: _duration.inMilliseconds.toDouble(),
                    // value: _dragValue ??
                    //     min(_position.inMilliseconds.toDouble(),
                    //         _duration.inMilliseconds.toDouble()),
                    value: _dragValue ?? _position.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _dragValue = value;
                      });
                      // _dragValue = value;
                      // if (widget.onChanged != null) {
                      //   widget.onChanged!(Duration(milliseconds: value.round()));
                      // }
                      // _dragValue = value;
                      // audio.player.pause();
                      // audio.player.seek(Duration(milliseconds: value.round()));
                    },
                    onChangeEnd: (value) {
                      // if (widget.onChangeEnd != null) {
                      //   widget.onChangeEnd!(Duration(milliseconds: value.round()));
                      // }
                      audio.player.seek(Duration(milliseconds: value.round()));
                      _dragValue = null;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  /*

  Widget buildOrg(BuildContext context) {
    // print(widget.position.inMilliseconds/widget.duration.inMilliseconds);
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0.90, -1.0),
          child: Opacity(
            opacity: widget.opacity,
            child: Text(
                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch("$_duration")?.group(1) ??
                    '$_duration',
                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12)),
          ),
        ),
        Opacity(
          opacity: widget.opacity,
          child: Align(
            alignment: const Alignment(-.90, -1.0),
            child: Text(
                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch("$_remaining")?.group(1) ??
                    '$_remaining',
                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12)),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            overlayShape: RoundSliderOverlayShape(overlayRadius: isCollapsed ? 0.0 : 15.0),
            trackHeight: isCollapsed ? 0.2 : 3,
            // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
            // activeTrackColor: Colors.blue,
            // inactiveTrackColor: Colors.grey,
            // activeTrackColor: Colors.blue.shade100,
            // inactiveTrackColor: Colors.grey.shade300,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: isCollapsed ? 2.0 : 5.0),
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
      ],
    );
  }
  */
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed', fontWeight: FontWeight.bold, fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
