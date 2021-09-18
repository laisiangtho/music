part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating:false,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: [kBottomNavigationBarHeight,50],
      overlapsBackgroundColor:Theme.of(context).primaryColor,
      overlapsBorderColor:Theme.of(context).shadowColor,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap){
        return Stack(
          alignment: const Alignment(0,0),
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: arguments.canPop?0:60, end: 0),
              duration: const Duration(milliseconds: 300),
              builder: (BuildContext context, double align, Widget? child) {
                return Positioned(
                  left: align,
                  top: 6,
                  child: (align == 0)?CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                    child: const Hero(
                      tag: 'appbar-left',
                      child: LabelAttribute( icon: CupertinoIcons.left_chevron, label: 'Back',),
                    ),
                    onPressed: () => Navigator.of(context).pop()
                  ):const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                    child: LabelAttribute( icon: CupertinoIcons.left_chevron, label: 'Back',)
                  )
                );
              },
            ),

            Align(
              alignment: Alignment.lerp(const Alignment(0,0), const Alignment(0,.5), snap.shrink)!,
              // child: PageAttribute(label: 'Album',fontSize: (30*org.shrink).clamp(20, 30).toDouble()),
              child: Hero(
                tag: 'appbar-center',
                child: Material(
                  type: MaterialType.transparency,
                  child: PageAttribute(label: 'Discography',fontSize: (30*org.shrink).clamp(20, 30).toDouble()),
                )
              ),
            ),
            // Positioned(
            //   left: 0,
            //   top: 8,
            //   width: MediaQuery.of(context).size.width,
            //   child: TweenAnimationBuilder<Alignment>(
            //     tween: Tween<Alignment>(begin: Alignment(arguments.canPop?-1:-.3,0), end: const Alignment(-1,0)),
            //     duration: const Duration(milliseconds: 300),
            //     builder: (BuildContext context, Alignment align, Widget? child) {
            //       return Align(
            //         alignment: align,
            //         child: child
            //       );
            //     },
            //     child: ButtonWithLabelAttribute(
            //       onPressed: () => Navigator.of(context).pop()
            //     )
            //   )
            // ),
            // Align(
            //   alignment: Alignment.lerp(const Alignment(0,0), const Alignment(0,.5), snap.shrink)!,
            //   // child: PageAttribute(label: 'Discography',fontSize: (30*org.shrink).clamp(20, 30).toDouble()),
            //   child: Hero(
            //     tag: 'appbar-center',
            //     child: Material(
            //       type: MaterialType.transparency,
            //       child: PageAttribute(label: 'Discography',fontSize: (30*org.shrink).clamp(20, 30).toDouble()),
            //     )
            //   ),
            // ),
            // Positioned(
            //   right: 0,
            //   top: 8,
            //   child: ButtonAttribute()
            // ),
          ]
        );

      }
    );
  }
}
