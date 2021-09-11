# ?

```dart
part of 'app.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, 'page2'),
          child: Text('Go to Page2'),
        ),
      ),
    );
  }
}
class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Page2')));
}

class AppView extends _State with _Player {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
        ],
      ),
      body: Navigator(
        onGenerateRoute: (settings) {
          Widget page = Page1();
          if (settings.name == 'page2') page = Page2();
          return MaterialPageRoute(builder: (_) => page);
        },
      ),
    );
    // return FutureBuilder(
    //   future: initiator,
    //   builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    //         return launched();
    //       // return ScreenLauncher();
    //       default:
    //         return ScreenLauncher();
    //     }
    //   }
    // );
  }

  Widget launched() {
    return Scaffold(
      key: scaffoldKey,
      primary: true,
      resizeToAvoidBottomInset: true,
      // body: Navigator(key: navigator, onGenerateRoute: _routeGenerate, onUnknownRoute: _routeUnknown ),
      body: SafeArea(
        top: false,
        bottom: true,
        maintainBottomViewPadding: true,
        // onUnknownRoute: routeUnknown,
        child: new PageView.builder(
          controller: pageController,
          // onPageChanged: _pageChanged,
          allowImplicitScrolling: false,
          // physics: new NeverScrollableScrollPhysics(),
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (BuildContext context, int index) => _pageView[index],
          itemCount: _pageView.length
        )
      ),
      bottomNavigationBar: showPlayer()
    );
  }

  // Widget navButton({
  //   String label:'',
  //   required void Function()? onPressed,
  //   required Widget child,
  // }) {
  //   return ElevatedButton(
  //     style: ButtonStyle(
  //       minimumSize:MaterialStateProperty.all<Size>(
  //         Size(20, 20)
  //       ),
  //       padding:MaterialStateProperty.all<EdgeInsets>(
  //         EdgeInsets.zero
  //       ),
  //       // foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
  //       backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
  //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //         RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(100.0),
  //           // side: BorderSide(color: Colors.red,width: 0.0)
  //         )
  //       )
  //     ),
  //     child: child,
  //     onPressed: onPressed
  //   );
  // }

  // Widget bottom() {
  //   return Consumer<NotifyViewScroll>(
  //     builder: (context, scrollNavigation, child) {
  //       scrollNavigation.bottomPadding = MediaQuery.of(context).padding.bottom;
  //       return AnimatedContainer(
  //         duration: Duration(milliseconds: scrollNavigation.milliseconds),
  //         height: scrollNavigation.height,
  //         child: ViewNavigation(
  //           items: _pageButton,
  //           itemDecoration: ({required BuildContext context, Widget? child}){
  //             return DecoratedBox(
  //               decoration: BoxDecoration(
  //                 // color: Theme.of(context).scaffoldBackgroundColor,
  //                 color: Theme.of(context).primaryColor,
  //                 // color: Theme.of(context).backgroundColor,
  //                 // border: Border(
  //                 //   top: BorderSide(
  //                 //     color: Theme.of(context).backgroundColor.withOpacity(0.2),
  //                 //     width: 0.5,
  //                 //   ),
  //                 // ),
  //                 borderRadius: BorderRadius.vertical(
  //                   top: Radius.elliptical(3, 2),
  //                   // bottom: Radius.elliptical(3, 2)
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     blurRadius: 0.0,
  //                     color: Theme.of(context).backgroundColor.withOpacity(0.3),
  //                     // color: Colors.black38,
  //                     spreadRadius: 0.1,
  //                     offset: Offset(0, -.1),
  //                   )
  //                 ]
  //               ),
  //               child: Padding(
  //                 padding:EdgeInsets.only(bottom: scrollNavigation.bottomPadding),
  //                 // padding: EdgeInsets.only(bottom:0),
  //                 child: AnimatedOpacity(
  //                   opacity: scrollNavigation.heightFactor,
  //                   duration: Duration.zero,
  //                   child: child
  //                 )
  //               )
  //             );
  //           },
  //           itemBuilder: buttonItem
  //         )
  //       );
  //     },
  //   );
  // }

  // Widget buttonItem({required BuildContext context, required int index, required ViewNavigationModel item, required bool disabled, required bool route}) {
  //   return Semantics(
  //     label: route ? "Page navigation" : "History navigation",
  //     namesRoute: route,
  //     enabled: route && !disabled,
  //     child: Tooltip(
  //       message: item.description,
  //       excludeFromSemantics: true,
  //       child: CupertinoButton(
  //           minSize: 30,
  //           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 1),
  //           child: AnimatedContainer(
  //               curve: Curves.easeIn,
  //               duration: Duration(milliseconds: 300),
  //               padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
  //               child: Icon(
  //                 item.icon,
  //                 size: route ? 26 : 18,
  //                 semanticLabel: item.name,
  //               )),
  //           disabledColor: route
  //               ? CupertinoColors.quaternarySystemFill
  //               : Theme.of(context).hintColor,
  //           // onPressed: current?null:()=>route?_navView(index):item.action(context)
  //           onPressed: buttonPressed(context, item, disabled)),
  //     ),
  //   );
  // }

  // void Function()? buttonPressed(BuildContext context, ViewNavigationModel item, bool disable) {
  //   if (disable) {
  //     return null;
  //   } else if (item.action == null && item.key != null) {
  //     return () => _navView(item.key!);
  //   } else {
  //     // final items = core.collection.boxOfHistory.toMap().values.toList();
  //     // items.sort((a, b) => b.date!.compareTo(a.date!));
  //     // debugPrint(items.map((e) => e.word));
  //     // return ()=>item.action!(context);
  //     // return () {
  //     //   history
  //     // };
  //     // _controller.master.bottom.pageChange(0);
  //     // return ()=>item.action(context);
  //     // core.collection.history.length;
  //     // debugPrint(core.collection.history.length);
  //     // debugPrint(asdfasdfasd.toString());
  //     // debugPrint(core.counter.toString());
  //     // int total = asdfasdfasd;
  //     // // int currentPosition=0;
  //     // // int nextButton = 1;
  //     // // int previousButton = -1;
  //     // if (total > 0){
  //     //   return () {
  //     //     if (_controller.master.bottom.pageNotify.value != 0){
  //     //       _navView(0);
  //     //     }
  //     //     item.action(context);
  //     //   };

  //     // }
  //     return item.action;
  //     // return null;
  //   }
  //   // int abc = context.watch<HistoryNotifier>().current;
  //   // int abc = context.watch<HistoryNotifier>().next;
  // }
}
