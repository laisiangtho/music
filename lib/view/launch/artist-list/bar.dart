part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     Positioned(
    //       left: 0,
    //       top: 0,
    //       child: WidgetButton(
    //         padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
    //         child: WidgetLabel(
    //           icon: Icons.arrow_back_ios_new_rounded,
    //           label: preference.text.back,
    //         ),
    //         duration: const Duration(milliseconds: 300),
    //         show: hasArguments,
    //         onPressed: args!.currentState!.maybePop,
    //       ),
    //     ),
    //     Positioned(
    //       top: 12,
    //       child: WidgetAppbarTitle(
    //         label: preference.text.artist(true),
    //       ),
    //     ),
    //     Positioned(
    //       right: 0,
    //       top: 0,
    //       child: WidgetButton(
    //         padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
    //         child: WidgetLabel(
    //           icon: Icons.tune_rounded,
    //           label: preference.text.filter(false),
    //         ),
    //         duration: const Duration(milliseconds: 300),
    //         onPressed: showFilter,
    //       ),
    //     ),
    //     Align(
    //       alignment: const Alignment(0, .7),
    //       child: Opacity(
    //         opacity: org.snapShrink,
    //         child: SizedBox(
    //           height: org.snapHeight,
    //           width: double.infinity,
    //           child: _barOptional(org.snapShrink),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
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
      primary: Positioned(
        top: 15.5,
        child: WidgetAppbarTitle(
          label: preference.text.artist(true),
        ),
      ),
      rightAction: [
        WidgetButton(
          child: const WidgetMark(
            icon: Icons.tune_rounded,
          ),
          message: preference.text.filter(false),
          onPressed: showFilter,
        )
      ],
      secondary: Align(
        alignment: const Alignment(0, .7),
        child: Opacity(
          opacity: org.snapShrink,
          child: SizedBox(
            height: org.snapHeight,
            width: double.infinity,
            child: _barOptional(org.snapShrink),
          ),
        ),
      ),
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
                        .map((e) => cacheBucket.langById(e).name.substring(0, 2).toUpperCase())
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
