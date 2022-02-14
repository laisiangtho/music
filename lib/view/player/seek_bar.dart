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

  Duration get _duration {
    Duration _stmDur = positionData?.duration ?? Duration.zero;
    Duration _stmPos = _position;
    final item = audio.player.sequenceState?.currentSource;
    if (_stmDur == Duration.zero && item != null) {
      AudioTrackType track = item.tag.trackInfo;
      final _trkDur = Duration(seconds: track.duration);

      if (_trkDur > _stmPos) {
        _stmPos = _trkDur;
      }
    }
    if (_stmDur < _stmPos) {
      return _stmPos;
    }
    return _stmDur;
    // if (isSeek) {
    //   if (d > p) {
    //     return d;
    //   }

    //   return p;
    // }

    // if (d > b) {
    //   return d;
    // }

    // return b;
  }

  // Duration get _duration => positionData?.duration ?? Duration.zero;
  Duration get _position => positionData?.position ?? Duration.zero;
  Duration get _buffered => positionData?.bufferedPosition ?? Duration.zero;
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
        // final ddd = positionData?.duration.inMilliseconds.toDouble();
        // final ppp = positionData?.position.inMilliseconds.toDouble();
        // final bbb = positionData?.bufferedPosition.inMilliseconds.toDouble();
        // final asdf = min(ppp, ddd);
        // debugPrint('inMilliseconds $ddd $ppp $bbb');

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
                      max: ((_duration > _buffered) ? _duration : _buffered)
                          .inMilliseconds
                          .toDouble(),
                      // max: checkValue(_duration, _buffered),
                      value: _buffered.inMilliseconds.toDouble(),
                      // value: checkValue(_buffered, _duration),
                      // value: checkValueTmp(false),
                      // value: min(_buffered.inMilliseconds.toDouble(),
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
                    // max: checkValueTmp(true),
                    // max: _duration.inMilliseconds.toDouble(),
                    max: _duration.inMilliseconds.toDouble(),
                    // max: checkValue(_position, _duration),
                    // value: _dragValue ??
                    //     min(_position.inMilliseconds.toDouble(),
                    //         _duration.inMilliseconds.toDouble()),
                    value: _dragValue ?? _position.inMilliseconds.toDouble(),
                    // value: _dragValue ?? checkValue(_position, _duration),
                    // value: _dragValue ?? checkValueTmp(true),
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
  double checkValueTmp(bool isSeek) {
    final p = _position.inMilliseconds.toDouble();
    final b = _buffered.inMilliseconds.toDouble();
    double d = _duration.inMilliseconds.toDouble();
    if (d == 0.0 && audio.player.sequence != null) {
      final index = audio.player.currentIndex;
      final abc = audio.player.sequence!.elementAt(index!);
      AudioTrackType track = abc.tag.trackInfo;
      d = Duration(seconds: track.duration).inMilliseconds.toDouble();
    }

    if (isSeek) {
      if (d > p) {
        return d;
      }

      return p;
    }

    if (d > b) {
      return d;
    }

    return b;
  }

  double checkValue(Duration vCurrent, Duration vMax) {
    // _position.inMilliseconds.toDouble()
    // value >= min && value <= max
    final a = vCurrent.inMilliseconds.toDouble();
    final b = vMax.inMilliseconds.toDouble();

    if (a < 0.0) {
      debugPrint('??? less than  $a');
      return 0.0;
    }
    if (a > b) {
      debugPrint('??? greater  $a $b');
      return b;
    }

    return a;
  }

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
