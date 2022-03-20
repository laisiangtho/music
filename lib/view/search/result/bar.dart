part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return SliverLayoutBuilder(
      builder: (BuildContext context, constraints) {
        final innerBoxIsScrolled = constraints.scrollOffset > 0;
        return ViewHeaderSliverSnap(
          pinned: true,
          floating: false,
          padding: MediaQuery.of(context).viewPadding,
          heights: const [kBottomNavigationBarHeight],
          overlapsBackgroundColor: Theme.of(context).primaryColor,
          overlapsBorderColor: Theme.of(context).shadowColor,
          overlapsForce: innerBoxIsScrolled,
          builder: (BuildContext context, ViewHeaderData org) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: GestureDetector(
                      child: _barForm(),
                      onTap: () {
                        // Navigator.of(context).pushNamed('/search-suggest').then((word) {
                        //   onUpdate(word != null);
                        // });
                        args?.currentState!.pushNamed('/search-suggest').then((word) {
                          onUpdate(word != null);
                        });
                        // debugPrint('??? $args $hasArguments');
                        // Navigator.of(context)
                        //     .pushNamed('/search-suggest', arguments: false)
                        //     .then((word) {
                        //   onUpdate(word != null);
                        // });
                      },
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                //   child: args!.canPop
                //       ? WidgetButton(
                //           child: const WidgetLabel(icon: CupertinoIcons.home),
                //           onPressed: () {
                //             core.navigate(to: '/home', routePush: true);
                //           },
                //         )
                //       : null,
                // ),
                WidgetButton(
                  padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                  child: const WidgetLabel(
                    icon: CupertinoIcons.home,
                  ),
                  duration: const Duration(milliseconds: 300),
                  show: args!.hasParam,
                  onPressed: param?.currentState!.maybePop,
                  // show: hasArguments,
                  // onPressed: () {
                  //   core.navigate(to: '/home', routePush: true);
                  // },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _barForm() {
    return TextFormField(
      readOnly: true,
      enabled: false,
      maxLines: 1,
      // initialValue: initialValue,
      // textInputAction: TextInputAction.search,
      // keyboardType: TextInputType.text,
      controller: textController,
      // strutStyle: const StrutStyle(height: 1.4),
      decoration: InputDecoration(
        hintText: preference.text.aWordOrTwo,
        // hintStyle: const TextStyle(height: 1.3),
        prefixIcon: const Icon(LideaIcon.find),
        // prefixIcon: Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        //   margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).scaffoldBackgroundColor,
        //     borderRadius: const BorderRadius.all(
        //       Radius.circular(10),
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         blurRadius: 0.1,
        //         color: Theme.of(context).shadowColor,
        //         // spreadRadius: 0.1,
        //         offset: const Offset(0, 0),
        //       )
        //     ],
        //   ),
        //   child: Selector<Core, String>(
        //     selector: (BuildContext _, Core e) {
        //       return e.scripturePrimary.bible.info.langCode;
        //     },
        //     builder: (BuildContext _, String langCode, Widget? child) {
        //       return Text(
        //         langCode.toUpperCase(),
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontSize: 12,
        //           // fontWeight: FontWeight.bold,
        //           color: Theme.of(context).hintColor,
        //         ),
        //       );
        //     },
        //   ),
        // ),
        fillColor: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
      ),
    );
  }
}
