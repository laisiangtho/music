part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: true,
      // reservedPadding: MediaQuery.of(context).padding.top,
      padding: MediaQuery.of(context).viewPadding,
      heights: const [kBottomNavigationBarHeight, 40],
      // overlapsBackgroundColor:Theme.of(context).primaryColor.withOpacity(0.8),
      overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: kBottomNavigationBarHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 30, end: 0),
                    duration: const Duration(milliseconds: 300),
                    builder: (BuildContext context, double align, Widget? child) {
                      return Positioned(
                        left: align,
                        top: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                          child: (align == 0)
                              ? Hero(
                                  tag: 'appbar-left',
                                  child: WidgetButton(
                                    duration: const Duration(milliseconds: 150),
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: WidgetLabel(
                                      icon: Icons.arrow_back_ios_new_rounded,
                                      label: preference.text.back,
                                    ),
                                  ),
                                )
                              : WidgetLabel(
                                  icon: Icons.arrow_back_ios_new_rounded,
                                  label: preference.text.back,
                                ),
                        ),
                      );
                    },
                  ),

                  // TweenAnimationBuilder<double>(
                  //   tween: Tween<double>(begin: 100, end: 0),
                  //   duration: const Duration(milliseconds: 150),
                  //   builder: (BuildContext context, double align, Widget? child) {
                  //     return Positioned(
                  //       left: align,
                  //       top: 7,
                  //       child: child!
                  //     );
                  //   },
                  //   child: WidgetButton(
                  //     padding: const EdgeInsets.only(left:7),
                  //     child: const Hero(
                  //       tag: 'appbar-left',
                  //       child: LabelAttribute(
                  //         // icon: Icons.arrow_back_ios_new,
                  //         icon: Icons.arrow_back_ios_new_rounded,
                  //         label: 'Back',
                  //       ),
                  //     ),
                  //     onPressed: () => Navigator.of(context).pop()
                  //   )
                  // ),

                  Align(
                    alignment: const Alignment(0, 0),
                    child: Hero(
                      tag: 'appbar-center',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          'Artists',
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 0,
                    top: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
                      child: Hero(
                        tag: 'appbar-right',
                        child: WidgetButton(
                          child: WidgetLabel(
                            // icon: Icons.tune,
                            icon: Icons.tune_rounded,
                            // icon: LideaIcon.sliders,
                            label: preference.text.filter(false),
                          ),
                          onPressed: showFilter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: snap.shrink,
              child: SizedBox(
                height: snap.offset,
                width: double.infinity,
                child: _barOptional(snap.shrink),
              ),
            )
          ],
        );
      },
    );
  }

  // Start with "M, C" in "Myanmar, Mizo" at "*" has (79)
  // Start with (*) in (*) at (*) matched (2074)
  // Artists (2074) begin with (*) in (*)
  // Artists (2074) begin with (*)
  Widget _barOptional(double stretch) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7 * stretch, horizontal: 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        children: [
          Text.rich(
            TextSpan(
              text: 'Artists ',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18 * stretch),
              children: [
                const TextSpan(text: '('),
                TextSpan(
                    text: artist.length.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                const TextSpan(text: ')'),
                if (filter.character.isNotEmpty) const TextSpan(text: ' start with '),
                TextSpan(
                    text: filter.character.take(6).join(', '),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                if (filter.language.isNotEmpty) const TextSpan(text: ' in '),
                TextSpan(
                    text: filter.language
                        .map((e) => cache.langById(e).name.substring(0, 2).toUpperCase())
                        .join(', '),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                const TextSpan(text: '...'),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showFilter() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => const _SheetFilter(),
      barrierColor: Theme.of(context).shadowColor.withOpacity(0.6),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      elevation: 10,
      useRootNavigator: true,
    ).whenComplete(
      () => Future.delayed(
        const Duration(milliseconds: 300),
        () => setState(artistInit),
      ),
    );
  }
}
