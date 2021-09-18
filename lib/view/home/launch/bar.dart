part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating:false,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: [kBottomNavigationBarHeight,40],
      overlapsBackgroundColor:Theme.of(context).primaryColor,
      overlapsBorderColor:Theme.of(context).shadowColor,
      // overlapsForce:true,
      // borderRadius: Radius.elliptical(20, 5),
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap){
        return Stack(
          // alignment: const Alignment(0,0),
          children: [

            // if (Navigator.canPop(context)) Positioned(
            //   left: 0,
            //   top: 8,
            //   child: const Hero(
            //     tag: 'appbar-left',
            //     child: Material(
            //       type: MaterialType.transparency,
            //     ),
            //   ),
            // ),

            Positioned(
              left: 0,
              top: 7,
              // height: 39,
              child: const CupertinoButton(
                padding: EdgeInsets.zero,
                child: Hero(
                  tag: 'appbar-left',
                  child: Material(
                    type: MaterialType.transparency,
                    child: LabelAttribute(),
                  ),
                ),
                onPressed: null,
              ),
            ),
            Align(
              alignment: Alignment.lerp(const Alignment(0,0), const Alignment(0,1), snap.shrink)!,
              child: Hero(
                tag: 'appbar-center',
                child: Material(
                  type: MaterialType.transparency,
                  child: PageAttribute(label: 'Zaideih',fontSize: (30*org.shrink).clamp(20, 30).toDouble()),
                ),
              ),
            ),
            /*
            Positioned(
              right: 0,
              top: 8,
              child: Hero(
                tag: 'appbar-right',
                child: Material(
                  type: MaterialType.transparency,
                  child: ButtonAttribute(
                    onPressed: () => core.navigate(to: '/search')
                  )
                ),
              ),
            ),
            */
            // Positioned(
            //   right: 0,
            //   top: 8,
            //   // height: 39,
            //   child: Hero(
            //     tag: 'appbar-right',
            //     child: Material(
            //       type: MaterialType.transparency,
            //       child: ButtonAttribute(
            //         // alignment: Alignment.centerRight,
            //         onPressed: () => core.navigate(to: '/search')
            //       )
            //     ),
            //   ),
            // ),
            Positioned(
              right: 0,
              top: 7,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Hero(
                  tag: 'appbar-right',
                  child: Material(
                    type: MaterialType.transparency,
                    child: LabelAttribute(
                      icon: ZaideihIcon.search,
                      // icon: CupertinoIcons.search,
                      // icon: Icons.search,
                    ),
                  ),
                ),
                onPressed: () => core.navigate(to: '/search'),
              )
            ),
          ]
        );
      },
    );
  }

  // Widget bar() {
  //   return SliverAppBar(
  //     title: Text('Zaideih Music Station'),
  //     centerTitle:true,
  //     // Allows the user to reveal the app bar if they begin scrolling
  //     // back up the list of items.
  //     floating: true,
  //     pinned: true,
  //     backgroundColor: core.nodeFocus?null:Theme.of(context).scaffoldBackgroundColor,
  //     elevation: 0.7,
  //     forceElevated: core.nodeFocus,
  //     shape: ContinuousRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(7), bottomRight: Radius.circular(7)
  //       )
  //     ),
  //     // Display a placeholder widget to visualize the shrinking size.
  //     // flexibleSpace: Placeholder(),
  //     // Make the initial height of the SliverAppBar larger than normal.
  //     expandedHeight: core.nodeFocus?40:100,
  //     // toolbarHeight:70,
  //     actions: [
  //       CupertinoButton(
  //         child: Icon(
  //           ZaideihIcon.search
  //         ),
  //         onPressed: ()=>null
  //       )
  //     ],
  //   );
  // }
  // final double _barShrinkSize = 10.0;
  // double get _barHeight => kBottomNavigationBarHeight-_barShrinkSize;
  // double get _barMaxHeight => 120;

  // Widget bar() {
  //   return new SliverPersistentHeader(
  //     pinned: true,
  //     floating:false,
  //     delegate: new ViewHeaderDelegate(
  //       // Navigator.canPop(context)?_barPopup:_barMain,
  //       _barMain,
  //       maxHeight: _barMaxHeight,
  //       // minHeight: _barHeight
  //       minHeight: _barHeight + MediaQuery.of(context).padding.top,
  //     )
  //   );
  // }

  // Widget _barMain(BuildContext context,double offset,bool overlaps, double shrink, double stretch){

  //   double snapExtent = _barMaxHeight - (_barHeight + MediaQuery.of(context).padding.top);
  //   double snapShrinkPercentage = 1.0 - (offset/snapExtent).clamp(0.0, 1.0).toDouble();
  //   double snapOffset = snapExtent-offset.clamp(0.0, snapExtent).toDouble();

  //   return ViewHeaderDecoration(
  //     // overlaps: stretch >= 0.5,
  //     overlaps: snapOffset == 0.0,
  //     // overlaps: true,
  //     // overlapsColor: true,
  //     reservedPadding: MediaQuery.of(context).padding.top,
  //     child: Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         if (Navigator.canPop(context))Positioned(
  //           left: 0,
  //           top: 6,
  //           child: ButtonWithLabelAttribute(
  //             onPressed: ()=>Navigator.of(context).pop(),
  //           ),
  //         ),
  //         Align(
  //           alignment: Alignment.lerp(Alignment(0,.5), Alignment(0,.8), snapShrinkPercentage)!,
  //           child: PageAttribute(label: 'Zaideih Music Station',fontSize: (27*shrink).clamp(20, 27).toDouble()),
  //         ),
  //         Positioned(
  //           right: 0,
  //           top: 6,
  //           child: ButtonAttribute()
  //         ),
  //       ]
  //     ),
  //   );
  // }
}
