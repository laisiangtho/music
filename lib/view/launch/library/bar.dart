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
        label: preference.text.library(false),
        shrink: org.shrink,
      ),
      rightAction: [
        WidgetButton(
          child: const WidgetMark(
            icon: Icons.add_rounded,
          ),
          message: preference.text.addMore(preference.text.playlist(true)),
          onPressed: showEditor,
        ),
      ],
    );
  }
}
