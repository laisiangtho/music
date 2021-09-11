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
        print(arguments.canPop);
        return Stack(
          alignment: const Alignment(0,0),
          children: [
            /*
            Positioned(
              left: 0,
              top: 8,
              child: ButtonWithLabelAttribute(
                onPressed: Navigator.canPop(context)?(){
                  Navigator.of(context).pop();
                }:null,
              ),
            ),
            */
            Positioned(
              left: 0,
              top: 8,
              width: MediaQuery.of(context).size.width/2,
              child: TweenAnimationBuilder<Alignment>(
                tween: Tween<Alignment>(begin: Alignment(arguments.canPop?-1:-.3,0), end: const Alignment(-1,0)),
                duration: const Duration(milliseconds: 150),
                builder: (BuildContext context, Alignment align, Widget? child) {
                  return Align(
                    alignment: align,
                    child: child
                  );
                },
                child: ButtonWithLabelAttribute(
                  onPressed: () => Navigator.of(context).pop()
                )
              )
            ),
            // SizedBox(
            //   height: kBottomNavigationBarHeight,
            //   child: TweenAnimationBuilder<Alignment>(
            //     tween: Tween<Alignment>(begin: const Alignment(-.3,-1), end: const Alignment(-1,-1)),
            //     duration: const Duration(milliseconds: 150),
            //     builder: (BuildContext context, Alignment align, Widget? child) {
            //       return Align(
            //         alignment: align,
            //         child: child
            //       );
            //     },
            //     child: ButtonWithLabelAttribute(
            //       onPressed: () => Navigator.of(context).pop()
            //     )
            //   ),
            // ),
            // TweenAnimationBuilder<Alignment>(
            //   tween: Tween<Alignment>(begin: const Alignment(-.3,0), end: const Alignment(-1,0)),
            //   duration: const Duration(milliseconds: 150),
            //   builder: (BuildContext context, Alignment align, Widget? child) {
            //     return Align(
            //       alignment: align,
            //       child: child
            //     );
            //   },
            //   child: ButtonWithLabelAttribute(
            //     onPressed: () => Navigator.of(context).pop()
            //   )
            // ),
            Align(
              alignment: Alignment.lerp(const Alignment(0,0), const Alignment(0,.5), snap.shrink)!,
              child: PageAttribute(label: 'Discography',fontSize: (30*org.shrink).clamp(20, 30).toDouble()),
            ),
            Positioned(
              right: 0,
              top: 8,
              child: ButtonAttribute()
            ),
          ]
        );

      }
    );
  }
}
