part of 'main.dart';

class AppView extends MainState with _BottomNavigator {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initiator,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return launched();
          default:
            return const ScreenLauncher();
        }
      },
    );
  }

  Widget launched() {
    return Scaffold(
      key: _scaffoldKey,
      primary: true,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        bottom: true,
        // maintainBottomViewPadding: true,
        // onUnknownRoute: routeUnknown,
        child: PageView.builder(
          controller: _pageController,
          // onPageChanged: _pageChanged,
          pageSnapping: false,
          // allowImplicitScrolling: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => _pageView[index],
          itemCount: _pageView.length,
        ),
        // child: Padding(
        //   padding: EdgeInsets.only(bottom: bottomPadding),
        //   child: PageView.builder(
        //     controller: _pageController,
        //     // onPageChanged: _pageChanged,
        //     pageSnapping: false,
        //     // allowImplicitScrolling: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemBuilder: (BuildContext context, int index) => _pageView[index],
        //     itemCount: _pageView.length,
        //   ),
        // ),
        // child: Selector<ViewScrollNotify, double>(
        //   selector: (_, e) => e.bottomPadding,
        //   builder: (context, bottomPadding, child) {
        //     return Padding(
        //       padding: EdgeInsets.only(bottom: bottomPadding),
        //       child: PageView.builder(
        //         controller: _pageController,
        //         // onPageChanged: _pageChanged,
        //         pageSnapping: false,
        //         // allowImplicitScrolling: true,
        //         physics: const NeverScrollableScrollPhysics(),
        //         itemBuilder: (BuildContext context, int index) => _pageView[index],
        //         itemCount: _pageView.length,
        //       ),
        //     );
        //   },
        // ),
      ),
      extendBody: true,
      // extendBodyBehindAppBar: true,
      bottomNavigationBar: bottomNavigator(),
      // bottomSheet: bottomNavigator(),
    );
  }
}
