part of 'main.dart';

mixin _Bar on _State {
  final double minHeight = kBottomNavigationBarHeight - 20;
  // final double maxHeight = kBottomNavigationBarHeight-minHeight;

  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      // reservedPadding: MediaQuery.of(context).padding.top,
      padding: MediaQuery.of(context).viewPadding,
      heights: [minHeight, kBottomNavigationBarHeight - minHeight],
      // overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org) {
        double width = MediaQuery.of(context).size.width / 2;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              // alignment: const Alignment(-1, 0),
              child: WidgetButton(
                padding: EdgeInsets.zero,
                child: WidgetLabel(
                  icon: Icons.bookmark_add,
                  iconSize: (org.shrink * 23).clamp(18, 23).toDouble(),
                  message: preference.text.back,
                ),
                onPressed: setBookMark,
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    child: AnimatedContainer(
                      key: keyBookButton,
                      duration: const Duration(milliseconds: 100),
                      constraints: BoxConstraints(maxWidth: width, minWidth: 30.0),
                      padding: EdgeInsets.symmetric(vertical: org.shrink * 12),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor.withOpacity(org.snapShrink),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.elliptical(20, 50),
                          ),
                        ),
                        child: _barButton(
                          label: preference.text.headline(true),
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          message: 'Book',
                          shrink: org.shrink,
                          onPressed: showBookList,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 10,
                    color: Theme.of(context).backgroundColor.withOpacity(org.stretch),
                  ),
                  Align(
                    child: AnimatedContainer(
                      key: keyChapterButton,
                      duration: const Duration(milliseconds: 100),
                      constraints: BoxConstraints(maxWidth: width, minWidth: 30.0),
                      padding: EdgeInsets.symmetric(vertical: org.shrink * 12),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor.withOpacity(org.snapShrink),
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.elliptical(20, 50),
                          ),
                        ),
                        child: _barButton(
                          label: '150',
                          message: 'Chapter',
                          shrink: org.shrink,
                          onPressed: showChapterList,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              // alignment: const Alignment(1, 0),
              child: AnimatedContainer(
                key: keyOptionButton,
                duration: const Duration(milliseconds: 0),
                constraints: BoxConstraints(maxWidth: width, minWidth: 30.0),
                padding: EdgeInsets.symmetric(vertical: org.snapShrink * 12),
                child: WidgetButton(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: WidgetLabel(
                    icon: LideaIcon.textSize,
                    iconSize: (org.shrink * 23).clamp(18, 23).toDouble(),
                    message: preference.text.signOut,
                  ),
                  onPressed: showOptionList,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _barButton(
      {Key? key,
      required double shrink,
      required String label,
      required String message,
      EdgeInsetsGeometry? padding = EdgeInsets.zero,
      required void Function()? onPressed}) {
    return Tooltip(
      message: message,
      child: WidgetButton(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(fontSize: (shrink * 19).clamp(15, 19)),
        ),
        onPressed: onPressed,
      ),
    );
  }

  void showOptionList() {
    Navigator.of(context)
        .push(
      PageRouteBuilder<int>(
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder:
            (BuildContext _, Animation<double> x, Animation<double> y, Widget child) =>
                FadeTransition(
          opacity: x,
          child: child,
        ),
        pageBuilder: (BuildContext _, x, y) => PopOptionList(
          render: keyOptionButton.currentContext!.findRenderObject() as RenderBox,
          setFontSize: setFontSize,
        ),
      ),
    )
        .whenComplete(() {
      // core.writeCollection();
    });
  }

  void showBookList() {
    // if (isNotReady) return null;
    // if(keyBookButton.currentContext!=null) return;

    Navigator.of(context)
        .push(
      PageRouteBuilder<Map<String?, int?>>(
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder:
            (BuildContext _, Animation<double> x, Animation<double> y, Widget child) =>
                FadeTransition(opacity: x, child: child),
        // barrierColor: Colors.white.withOpacity(0.4),
        // barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        pageBuilder: (BuildContext context, x, y) => PopBookList(
          render: keyBookButton.currentContext!.findRenderObject() as RenderBox,
        ),
      ),
    )
        .then((e) {
      if (e != null) {
        // debugPrint(e);
        // core.chapterChange(bookId: e['book'], chapterId: e['chapter']);
        // setBook(e);
      }
    });
  }

  void showChapterList() {
    // if (isNotReady) return null;
    Navigator.of(context)
        .push(
      PageRouteBuilder<int>(
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder:
            (BuildContext _, Animation<double> x, Animation<double> y, Widget child) =>
                FadeTransition(opacity: x, child: child),
        // barrierColor: Colors.white.withOpacity(0.4),
        // barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        pageBuilder: (BuildContext context, x, y) => PopChapterList(
          render: keyChapterButton.currentContext!.findRenderObject() as RenderBox,
        ),
      ),
    )
        .then((e) {
      // setChapter(e);
    });
  }
}
