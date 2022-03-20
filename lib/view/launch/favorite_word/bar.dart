part of 'main.dart';

mixin _Bar on _State {
  Widget bar(bool hasValue) {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      padding: MediaQuery.of(context).viewPadding,
      heights: const [kToolbarHeight, 50],
      overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org) {
        return Stack(
          alignment: const Alignment(0, 0),
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: WidgetButton(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: WidgetLabel(
                  icon: Icons.arrow_back_ios_new_rounded,
                  label: preference.text.back,
                ),
                duration: const Duration(milliseconds: 300),
                show: hasArguments,
                onPressed: args?.currentState!.maybePop,
              ),
            ),
            WidgetAppbarTitle(
              alignment: Alignment.lerp(
                const Alignment(0, 0),
                const Alignment(0, .5),
                org.snapShrink,
              ),
              label: preference.text.favorite(false),
              shrink: org.shrink,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: WidgetButton(
                padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                child: const WidgetLabel(
                  icon: Icons.clear_all_rounded,
                ),
                duration: const Duration(milliseconds: 300),
                enable: hasValue,
                onPressed: () {
                  doConfirmWithDialog(
                    context: context,
                    // message: 'Do you really want to delete all?',
                    message: preference.text.confirmToDelete('all'),
                  ).then((bool? confirmation) {
                    if (confirmation != null && confirmation) onClearAll();
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
