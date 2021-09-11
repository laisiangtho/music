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
            Positioned(
              left: 0,
              top: 8,
              child: ButtonWithLabelAttribute(
                onPressed: Navigator.canPop(context)?(){
                  Navigator.of(context).pop();
                }:null,
              ),
            ),
            Align(
              alignment: Alignment.lerp(const Alignment(0,0), const Alignment(0,.5), snap.shrink)!,
              child: PageAttribute(label: 'Album',fontSize: (30*org.shrink).clamp(20, 30).toDouble()),
            ),
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
