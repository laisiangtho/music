// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/gestures.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/audio.dart';
import 'package:lidea/icon.dart';
// import 'package:lidea/extension.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'button_toggle.dart';
part 'seek_bar.dart';
part 'mode.dart';
part 'queue.dart';
part 'info.dart';
part 'other.dart';

class Player extends StatefulWidget {
  final List<ViewNavigationModel> pageButton;
  final void Function(int index) pageAction;
  const Player({
    Key? key,
    required this.pageButton,
    required this.pageAction,
  }) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> with TickerProviderStateMixin {
  late final AnimationController switchController = AnimationController(
    duration: const Duration(microseconds: 50),
    vsync: this,
  );
  late final Animation<double> switchAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(switchController);
  late final Animation<bool> boolAnimation = Tween(
    begin: true,
    end: false,
  ).animate(switchController);
  late final Animation<Color?> colorAnimation = ColorTween(
    begin: null,
    end: Theme.of(context).highlightColor,
  ).animate(switchController);

  late final AnimationController screenController = AnimationController(
    duration: const Duration(microseconds: 50),
    reverseDuration: const Duration(microseconds: 300),
    vsync: this,
  );
  late final Animation<Color?> statusBarColorAnimation = ColorTween(
    begin: Theme.of(context).highlightColor,
    end: Colors.transparent,
  ).animate(screenController);

  late final Core core = context.read<Core>();
  late final AudioPlayer player = core.audio.player;
  // late final ViewScrollNotify scrollNotify = Provider.of<ViewScrollNotify>(context, listen: false);
  late final ViewScrollNotify scrollNotify = context.read<ViewScrollNotify>();

  late ScrollController controller;
  late final DraggableScrollableController draggableController = DraggableScrollableController();
  // late BuildContext draggableContext;

  // NOTE: device height and width
  double get _dHeight => MediaQuery.of(context).size.height;
  // double get _dWidth => MediaQuery.of(context).size.width;
  double get _bPadding => MediaQuery.of(context).padding.bottom;
  double get _tPadding => MediaQuery.of(context).padding.top;

  // NOTE: statusBar height
  // double get _dsbHeight => MediaQuery.of(context).viewPadding.top;
  // double get _dsbHeight => MediaQueryData.fromWindow(context).padding.top;
  // double get _dsbHeight => MediaQuery.of(context).padding.top;

  // NOTE: update when scroll notify
  double sizeValueInitial = 0.0;
  late final sizeValueMin = (scrollNotify.kHeightMax + _bPadding) / _dHeight;
  // double get sizeValueMin => (scrollNotify.kHeightMax / _dHeight);
  final double sizeValueMid = 0.5;
  late final double sizeValueMax = (_dHeight - scrollNotify.kHeightMax + _tPadding) / _dHeight;
  // final double sizeValueMax = 0.91;
  // final double sizeValueMax = 1.0;

  bool get isSizeDefault => sizeValueInitial <= sizeValueMin;
  bool get isSizeShrink => sizeValueInitial < sizeValueMid;
  // double get offset => (sizeValueInitial - sizeValueMin).toDouble();
  // bool get showNavigation => offset <= 0.0;

  bool _scrollableNotification(DraggableScrollableNotification notification) {
    sizeValueInitial = notification.extent;
    scrollNotify.bottomPadding = sizeValueInitial * _dHeight;

    if (sizeValueInitial == sizeValueMax) {
      if (screenController.isCompleted) {
        screenController.reverse();
      }
    } else if (screenController.isDismissed) {
      screenController.forward();
    }

    onSwitchNavigationButton();

    return true;
  }

  void onToggle() {
    draggableController
        .animateTo(
      isSizeShrink ? sizeValueMid : sizeValueMin,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
    )
        .whenComplete(() {
      // debugPrint('isSizeShrink $isSizeShrink == false');
      if (isSizeShrink) {
        // NOTE: fix glitching on resize
        controller.jumpTo(0);
      }
    });

    // onSwitchNavigationButton();
  }

  void onSwitchNavigationButton() {
    if (isSizeDefault) {
      switchController.reverse();
    } else if (switchController.isDismissed) {
      switchController.forward();
    }
  }

  void Function()? buttonAction(ViewNavigationModel item, bool disable) {
    if (disable) {
      return null;
    } else if (item.action == null) {
      return () => widget.pageAction(item.key);
    } else {
      return item.action;
    }
  }

  @override
  void initState() {
    player.playbackEventStream.listen((e) {
      debugPrint('??? playbackEventStream');
    }, onDone: () {
      debugPrint('??? done');
    }, onError: (Object e, StackTrace stackTrace) {
      // debugPrint('??? errorEventStream: $e $stackTrace');
      Future.delayed(const Duration(milliseconds: 300), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('errorEventStream'),
          ),
        );
      });
    });
    super.initState();
    // NOTE: status bar height and reserved sheet top
    // scrollNotify.reservedHeight = 25;
    screenController.forward();
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Hello'),
    //     ),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableActuator(
      key: const ValueKey(88698),
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: _scrollableNotification,
        child: Selector<ViewScrollNotify, double>(
          selector: (_, e) => e.heightFactor,
          builder: (context, heightFactor, child) {
            if (isSizeDefault) {
              sizeValueInitial = sizeValueMin * heightFactor;
            }
            return DraggableScrollableSheet(
              // key: ValueKey<double>(sizeValueInitial),
              // key: UniqueKey(),
              key: const ValueKey<String>('draggableController'),
              expand: false,
              controller: draggableController,

              initialChildSize: sizeValueInitial,
              minChildSize: isSizeDefault ? sizeValueInitial : sizeValueMin,
              maxChildSize: sizeValueMax,
              // snap: true,
              // snapSizes: [sizeValueMid, sizeValueMax],
              builder: (BuildContext _, ScrollController ctl) {
                controller = ctl;
                return sheetDecoration(child: body());
              },
            );
          },
        ),
      ),
    );
  }

  Widget body() {
    return CustomScrollView(
      key: const ValueKey<String>('csvbs'),
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      // primary: false,
      // shrinkWrap: true,
      slivers: <Widget>[
        ViewHeaderSliverSnap(
          pinned: true,
          floating: false,
          // reservedPadding: 20,
          // reservedPadding: MediaQuery.of(context).padding.bottom,
          // heights: const [kBottomNavigationBarHeight],
          // padding: MediaQuery.of(context).viewPadding,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          heights: const [kBottomNavigationBarHeight],
          backgroundColor: Theme.of(context).primaryColor,

          overlapsBorderColor: Theme.of(context).shadowColor,
          builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
            return navControl();
            // return playerControl();
          },
        ),

        const SliverPadding(
          padding: EdgeInsets.only(top: 0),
          sliver: SliverToBoxAdapter(
            child: PlayerSeekBar(),
          ),
        ),
        const SliverToBoxAdapter(
          child: PlayerMode(),
        ),
        const SliverToBoxAdapter(
          child: PlayerInfo(),
        ),
        // const PlayerQueue(),
        // const PlayerOther(),
        // SliverList(
        //   delegate: SliverChildListDelegate(
        //     [],
        //   ),
        // ),
      ],
    );
  }

  Widget sheetDecoration({Widget? child}) {
    return Container(
      // margin: const EdgeInsets.only(top: 23),
      // padding: const EdgeInsets.only(bottom: 30),
      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        // color: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).primaryColor,
        // color: Colors.transparent,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
          // top: Radius.circular(2)
          // top: Radius.elliptical(15, 15),
        ),
        // border: Border.all(color: Colors.blueAccent),
        // border: Border(
        //   top: BorderSide(width: 0.5, color: Theme.of(context).shadowColor),
        // ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            // color: Theme.of(context).shadowColor.withOpacity(0.9),
            // color: Theme.of(context).backgroundColor.withOpacity(0.6),
            blurRadius: 0.2,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          )
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }

  Widget navControl() {
    return Consumer<NavigationNotify>(
      builder: (context, route, child) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Home/None
            Expanded(
              flex: 2,
              child: AnimatedBuilder(
                animation: switchController,
                builder: (context, child) {
                  if (switchAnimation.value == 0.0) {
                    return navControlPage(0);
                  }
                  return child!;
                },
                child: const SizedBox(),
              ),
            ),
            // Library/Previous
            Expanded(
              flex: 2,
              child: AnimatedBuilder(
                animation: switchController,
                builder: (_, child) {
                  if (switchAnimation.value == 0.0) {
                    return navControlPage(1);
                  }
                  return child!;
                },
                child: StreamBuilder<SequenceState?>(
                  stream: player.sequenceStateStream,
                  builder: (_, snapshot) => WidgetButton(
                    child: const WidgetLabel(
                      icon: Icons.skip_previous,
                      message: "Previous",
                    ),
                    onPressed: player.hasPrevious ? player.seekToPrevious : null,
                  ),
                ),
              ),
            ),
            // Play
            const Expanded(
              flex: 2,
              child: PlayerButtonToggle(),
            ),
            // Store/Next
            Expanded(
              flex: 2,
              child: AnimatedBuilder(
                animation: switchController,
                builder: (_, child) {
                  if (switchAnimation.value == 0.0) {
                    return navControlPage(2);
                  }
                  return child!;
                },
                child: StreamBuilder<SequenceState?>(
                  stream: player.sequenceStateStream,
                  builder: (_, snapshot) => WidgetButton(
                    child: const WidgetLabel(
                      icon: Icons.skip_next,
                      message: "Next",
                    ),
                    onPressed: player.hasNext ? player.seekToNext : null,
                  ),
                ),
              ),
            ),
            // Toggle
            Expanded(
              flex: 2,
              child: AnimatedBuilder(
                animation: switchController,
                builder: (_, child) {
                  return WidgetButton(
                    child: Icon(
                      // Icons.queue_music,
                      // switchAnimation.value == 0.0 ? Icons.expand_less : Icons.expand_more,
                      isSizeShrink ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: onToggle,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget navControlPage(int id) {
    return Selector<NavigationNotify, int>(
      selector: (_, e) => e.index,
      builder: (context, index, child) {
        final wi = widget.pageButton[id];
        return WidgetButton(
          child: WidgetLabel(
            icon: wi.icon,
            message: wi.description!,
          ),
          onPressed: buttonAction(wi, wi.action == null && wi.key == index),
        );
      },
    );
  }
}
