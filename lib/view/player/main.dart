// import 'dart:async';
// import 'dart:math';
// import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/audio.dart';
// import 'package:lidea/icon.dart';
import 'package:lidea/extension.dart';

import '/core/main.dart';
import '/type/main.dart';
import '/widget/main.dart';

part 'button_toggle.dart';
part 'seek_bar.dart';
part 'mode.dart';
part 'queue.dart';
part 'info.dart';
part 'other.dart';

late final DraggableScrollableController draggableController = DraggableScrollableController();

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
  late final Audio audio = core.audio;

  // late final ViewScrollNotify scrollNotify = Provider.of<ViewScrollNotify>(context, listen: false);
  late final ViewScrollNotify scrollNotify = context.read<ViewScrollNotify>();

  late final Preference preference = core.preference;

  late ScrollController controller;
  // late final DraggableScrollableController draggableController = DraggableScrollableController();
  // late BuildContext draggableContext;

  // NOTE: device height and width
  double get _dHeight => MediaQuery.of(context).size.height;

  double get _bPadding => MediaQuery.of(context).padding.bottom;
  // NOTE: status bar height
  double get _kHeight => context.statusBarHeight;

  // NOTE: update when scroll notify
  double sizeValueInitial = 0.0;
  late final sizeValueMin = (scrollNotify.kHeight + _bPadding) / _dHeight;
  final double sizeValueMid = 0.5;
  late final double sizeValueMax = (_dHeight - _kHeight) / _dHeight;

  bool get isSizeDefault => sizeValueInitial <= sizeValueMin;
  bool get isSizeShrink => sizeValueInitial < sizeValueMid;

  bool _draggableNotification(DraggableScrollableNotification notification) {
    sizeValueInitial = notification.extent;
    // scrollNotify.bottomPadding = sizeValueInitial * _dHeight;

    if (sizeValueInitial == sizeValueMax) {
      if (screenController.isCompleted) {
        screenController.reverse();
      }
    } else if (screenController.isDismissed) {
      screenController.forward();
    }

    switchControllerWatch();

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

    // switchControllerWatch();
  }

  void switchControllerWatch() {
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
    super.initState();
    // NOTE: status bar height and reserved sheet top
    // scrollNotify.reservedHeight = 25;
    screenController.forward();

    audio.message.listen((msg) {
      if (msg.isNotEmpty) {
        if (msg.isNotEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  elevation: 0.5,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  behavior: SnackBarBehavior.floating,
                  content: WidgetLabel(
                    // icon: Icons.warning_rounded,
                    label: preference.language(msg),
                  ),
                ),
              )
              .closed
              .then((value) {
            audio.message.value = '';
            debugPrint('??? errorMessage $value');
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: snapback
    return DraggableScrollableActuator(
      key: const ValueKey(88698),
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: _draggableNotification,
        child: Selector<ViewScrollNotify, double>(
          selector: (_, e) => e.factor,
          builder: (context, factor, child) {
            if (isSizeDefault) {
              sizeValueInitial = sizeValueMin * factor;
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
      scrollBehavior: const ViewScrollBehavior(),
      slivers: <Widget>[
        ViewHeaderSliverSnap(
          pinned: true,
          floating: false,
          heights: const [kToolbarHeight],
          backgroundColor: Theme.of(context).primaryColor,
          overlapsBorderColor: Theme.of(context).shadowColor,
          builder: navControl,
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
        const PlayerQueue(),
        const PlayerOther(),
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

  Widget navControl(BuildContext context, ViewHeaderData org) {
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
                child: StreamBuilder<AudioQueueStateType>(
                  stream: audio.queueState,
                  builder: (context, snapshot) {
                    final state = snapshot.data ?? AudioQueueStateType.empty;
                    return WidgetButton(
                      child: const WidgetLabel(
                        icon: Icons.skip_previous,
                        iconSize: 40,
                      ),
                      message: preference.text.previousTo(preference.text.track(false)),
                      onPressed: state.hasPrevious ? audio.skipToPrevious : null,
                    );
                  },
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
                child: StreamBuilder<AudioQueueStateType>(
                  stream: audio.queueState,
                  builder: (context, snapshot) {
                    final state = snapshot.data ?? AudioQueueStateType.empty;
                    return WidgetButton(
                      child: const WidgetLabel(
                        icon: Icons.skip_next,
                        iconSize: 40,
                      ),
                      message: preference.text.nextTo(preference.text.track(false)),
                      onPressed: state.hasNext ? audio.skipToNext : null,
                    );
                  },
                ),
              ),
            ),
            // Toggle
            Expanded(
              flex: 2,
              child: AnimatedBuilder(
                animation: switchController,
                builder: (_, child) {
                  if (switchAnimation.value == 0.0) {
                    return navControlPage(4);
                  }
                  return child!;
                  // return WidgetButton(
                  //   child: Icon(
                  //     isSizeShrink ? Icons.expand_less : Icons.expand_more,
                  //   ),
                  //   onPressed: onToggle,
                  // );
                },
                child: WidgetButton(
                  child: Icon(
                    isSizeShrink ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: onToggle,
                ),
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
          ),
          message: wi.description!,
          onPressed: buttonAction(wi, wi.action == null && wi.key == index),
        );
      },
    );
  }
}
