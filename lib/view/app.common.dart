import 'dart:math';

import 'package:flutter/material.dart';

class PlaySeekBar extends StatefulWidget {
  final double opacity;
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  PlaySeekBar({
    required this.opacity,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _PlaySeekState createState() => _PlaySeekState();
}

class _PlaySeekState extends State<PlaySeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  Duration get _duration => widget.duration;
  Duration get _position => widget.position;
  Duration get _remaining => _duration -_position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 0.5,
      activeTrackColor: Theme.of(context).backgroundColor,
      inactiveTrackColor: Theme.of(context).shadowColor,
      // inactiveTrackColor: Colors.grey,
      thumbColor: Theme.of(context).backgroundColor,
      trackShape: RectangularSliderTrackShape(),
      // trackHeight: 6.0,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
      overlayColor: Colors.red.withAlpha(32),
      // overlayShape: RoundSliderOverlayShape(overlayRadius: (widget.opacity == 0.0)?15.0:0.0),
    );
  }

  bool get isCollapsed => widget.opacity == 0.0;

  @override
  Widget build(BuildContext context) {
    // print(widget.position.inMilliseconds/widget.duration.inMilliseconds);
    return Stack(
      children: [
        Align(
          alignment: Alignment(0.90,-1.0),
          child: Opacity(
            opacity: widget.opacity,
            child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch("$_duration")?.group(1) ??'$_duration',
              style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: 12
              )
            ),
          ),
        ),
        Opacity(
          opacity: widget.opacity,
          child: Align(
            alignment: Alignment(-.90,-1.0),
            child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch("$_remaining")?.group(1) ??'$_remaining',
              style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: 12
              )
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            overlayShape: RoundSliderOverlayShape(overlayRadius: isCollapsed?0.0:15.0),
            trackHeight: isCollapsed?0.2:3,
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
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: isCollapsed?2.0:5.0),
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
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
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