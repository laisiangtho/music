// ignore_for_file: sort_child_properties_last

part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    return ViewHeaderLayoutStack(
      leftAction: [
        WidgetButton(
          child: WidgetMark(
            icon: Icons.arrow_back_ios_new_rounded,
            label: preference.text.back,
          ),
          show: hasArguments,
          onPressed: args?.currentState!.maybePop,
        ),
      ],
      primary: WidgetAppbarTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          org.snapShrink,
        ),
        label: preference.text.recentPlay(false),
        shrink: org.shrink,
      ),
    );
  }
}
