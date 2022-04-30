// import 'dart:async';
// import 'dart:math';
// import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/audio.dart';
// import 'package:lidea/icon.dart';
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

class Player extends ViewDraggableSheetWidget {
  final List<ViewNavigationModel> pageButton;
  final void Function(int index) pageAction;
  const Player({
    Key? key,
    required this.pageButton,
    required this.pageAction,
  }) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends ViewDraggableSheetState<Player> {
  late final Core core = context.read<Core>();
  late final Audio audio = core.audio;
  late final Preference preference = context.read<Preference>();

  // @override
  // BorderRadius get borderRadius => const BorderRadius.vertical(
  //       top: Radius.circular(5),
  //     );

  void onToggle() {
    draggableController
        .animateTo(
      isSizeShrink ? midSize : minSize,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
    )
        .whenComplete(() {
      // debugPrint('isSizeShrink $isSizeShrink == false');
      if (isSizeShrink) {
        // NOTE: fix glitching on resize
        scrollController.jumpTo(0);
      }
    });

    // switchControllerWatch();
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
  List<Widget> sliverWidgets() {
    return <Widget>[
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        heights: const [kToolbarHeight],
        backgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: navControl,
      ),
      // const SliverPadding(
      //   padding: EdgeInsets.only(top: 0),
      //   sliver: SliverToBoxAdapter(
      //     child: PlayerSeekBar(),
      //   ),
      // ),
      // NOTE: require for iOS that doesn't have Home button
      SliverFadeTransition(
        opacity: switchAnimation,
        sliver: const SliverToBoxAdapter(child: PlayerSeekBar()),
      ),

      const SliverToBoxAdapter(
        child: PlayerMode(),
      ),
      const SliverToBoxAdapter(
        child: PlayerInfo(),
      ),
      const PlayerQueue(),
      // const PlayerOther(),
    ];
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
                  // if (switchAnimation.value == 0.0) {
                  //   return navControlPage(4);
                  // }
                  // return child!;
                  return WidgetButton(
                    child: Icon(
                      isSizeShrink ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: onToggle,
                  );
                },
                // child: WidgetButton(
                //   child: Icon(
                //     isSizeShrink ? Icons.expand_less : Icons.expand_more,
                //   ),
                //   onPressed: onToggle,
                // ),
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
