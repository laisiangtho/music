part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      // reservedPadding: MediaQuery.of(context).padding.top,
      padding: MediaQuery.of(context).viewPadding,
      heights: const [kBottomNavigationBarHeight, 50],
      overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        return Stack(
          alignment: const Alignment(0, 0),
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: canPop ? 30 : 0, end: 0),
              duration: const Duration(milliseconds: 300),
              builder: (BuildContext context, double align, Widget? child) {
                return Positioned(
                  left: align,
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    child: canPop
                        ? (align == 0)
                            ? Hero(
                                tag: 'appbar-left-$canPop',
                                child: WidgetButton(
                                  // padding: EdgeInsets.zero,
                                  // minSize: 30,
                                  onPressed: () {
                                    arguments.navigator!.currentState!.maybePop();
                                  },
                                  child: WidgetLabel(
                                    icon: Icons.arrow_back_ios_new_rounded,
                                    label: preference.text.back,
                                  ),
                                ),
                              )
                            : WidgetLabel(
                                icon: CupertinoIcons.left_chevron,
                                label: preference.text.back,
                              )
                        : const SizedBox(),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.lerp(
                const Alignment(0, 0),
                const Alignment(0, .5),
                snap.shrink,
              )!,
              child: Hero(
                tag: 'appbar-center',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    'Album',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: (30 * org.shrink).clamp(22, 30).toDouble()),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
