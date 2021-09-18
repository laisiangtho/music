import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:just_audio/just_audio.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/connectivity.dart';
import 'package:lidea/view.dart';
import 'package:lidea/keepAlive.dart';

// import 'package:music/notifier.dart';
import 'package:music/core.dart';
import 'package:music/widget.dart';
import 'package:music/icon.dart';
import 'package:music/model.dart';

import 'package:music/view/home/main.dart' as Home;
import 'package:music/view/search/main.dart' as Search;
import 'package:music/view/note/main.dart' as Note;
import 'package:music/view/more/main.dart' as More;
// import 'package:music/view/album/main.dart' as Album;
// import 'package:music/view/album/main.dart' as Artist;
// import 'package:music/view/app.nestedScroll.dart' as More;

import 'app.common.dart';
// import 'app.controller.dart';

part 'app.launcher.dart';
part 'app.view.dart';
part 'app.player.dart';
part 'app.player.control.dart';
part 'app.player.info.dart';
part 'app.player.queue.dart';

class AppMain extends StatefulWidget {
  const AppMain({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => AppView();
}

abstract class _State extends State<AppMain> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final pageController = PageController(keepPage: true);
  final _controller = ScrollController();
  final viewNotifyNavigation = NotifyNavigationButton.navigation;

  // final GlobalKey<Home.View> _home = GlobalKey<Home.View>();
  // final GlobalKey<Note.View> _note = GlobalKey<Note.View>();
  // final GlobalKey<More.View> _more = GlobalKey<More.View>();

  final _homeGlobal = GlobalKey<ScaffoldState>();
  final _homeNavigate = GlobalKey<NavigatorState>();
  final _searchGlobal = GlobalKey<ScaffoldState>();
  final _noteGlobal = GlobalKey<ScaffoldState>();
  final _moreGlobal = GlobalKey<ScaffoldState>();
  final _albumGlobal = GlobalKey<ScaffoldState>();
  final _artistGlobal = GlobalKey<ScaffoldState>();

  final _homeKey = UniqueKey();
  final _searchKey = UniqueKey();
  final _noteKey = UniqueKey();
  final _moreKey = UniqueKey();
  final _albumKey = UniqueKey();
  final _artistKey = UniqueKey();

  final List<Widget> _pageView = [];
  final List<ViewNavigationModel> _pageButton = [];

  late Core core;
  late Future<void> initiator;
  late StreamSubscription<ConnectivityResult> connection;

  @override
  void initState() {
    super.initState();
    // Provider.of<Core>(context, listen: false);
    core = context.read<Core>();
    core.navigate = navigate;
    // core.navigation = _homeNavigate;
    initiator = core.init();
    // initiator = new Future.delayed(new Duration(seconds: 1));
    connection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      // ConnectivityResult.mobile
      // ConnectivityResult.wifi
      // ConnectivityResult.none
    });
    if (_pageView.length == 0){
      _pageButton.addAll([
        // ViewNavigationModel(icon:ZaideihIcon.chapter_previous, name:"Previous", description: "Previous search", action: onPreviousHistory() ),
        ViewNavigationModel(icon:ZaideihIcon.home, name:"Home", description: "Home", key: 0),

        // ViewNavigationModel(icon:ZaideihIcon.chapter_next, name:"Next", description: "Next search", action: onNextHistory()),

        // ViewNavigationModel(icon:ZaideihIcon.layers, name:"History", description: "Recent searches", key: 2),
        ViewNavigationModel(icon:ZaideihIcon.layers, name:"Tmp", description: "Tmp list", key: 1),
        ViewNavigationModel(icon:ZaideihIcon.layers, name:"PlayList", description: "PlayList", key: 2),
        ViewNavigationModel(icon:Icons.settings, name:"Setting", description: "Setting", key: 3),
        ViewNavigationModel(icon:ZaideihIcon.search, name:"Search", description: "Search dictionary", key: 4),
        // ViewNavigationModel(icon:ZaideihIcon.dot_horiz, name:"More", description: "More information", key: 2),
      ]);
      _pageView.addAll([
        WidgetKeepAlive(key:_homeKey, child: new Home.Main(key: _homeGlobal, navigateKey: _homeNavigate,)),
        WidgetKeepAlive(key:_searchKey, child: new Search.Main(key: _searchGlobal)),
        WidgetKeepAlive(key:_albumKey, child: new Note.Main(key: _albumGlobal)),
        WidgetKeepAlive(key:_moreKey, child: new More.Main(key: _moreGlobal)),
        WidgetKeepAlive(key:_artistKey, child: new Note.Main(key: _artistGlobal)),
        WidgetKeepAlive(key:_noteKey, child: new Note.Main(key: _noteGlobal)),
        // WidgetKeepAlive(child: new  TestView())
      ]);
    }

    viewNotifyNavigation.addListener((){
      int index = viewNotifyNavigation.value;
      // navigator.currentState.pushReplacementNamed(index.toString());
      print('page.addListener $index');

      ViewNavigationModel page = _pageButton.firstWhere((e) => e.key == index, orElse: () => _pageButton.first);
      core.analyticsScreen(page.name,'${page.name}State');
      // NOTE: check State isMounted
      // if(page.key.currentState != null){
      //   page.key.currentState.setState(() {});
      // }
      pageController.jumpToPage(index);

      // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuart);
      // pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.linear);
      // navigator.currentState.pushNamed(index.toString());
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => Note(),
      // ));
      // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => Bible(), maintainState: false));
      // Navigator.of(context, rootNavigator: false).pushNamed(index.toString());
      // Navigator.of(context, rootNavigator: false).pushReplacementNamed(index.toString());
    });
  }

  @override
  void dispose() {
    // core.store?.subscription?.cancel();
    _controller.dispose();
    viewNotifyNavigation.dispose();
    super.dispose();
    connection.cancel();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }


  void _navView(int index){
    // _controller.master.bottom.pageChange(index);
    viewNotifyNavigation.value = index;
  }

  void navigate({int? at:0, String? to, Object? args, bool routePush:false}){
    NotifyNavigationButton.navigation.value = at!;
    if (at == 0 && to != null && _homeNavigate.currentState != null) {
      final canPop = _homeNavigate.currentState!.canPop();
      // final canPop = Navigator.canPop(context);

      final arguments = NavigatorArguments(canPop:canPop, meta: args);
      if (routePush){
        debugPrint('routePush true');
        // _homeNavigate.currentState!.pushReplacementNamed(to, arguments: args);
        _homeNavigate.currentState!.pushReplacementNamed(to, arguments: arguments);
        // Navigator.of(context).pushReplacementNamed(to, arguments: arguments);
      } else {
        // _homeNavigate.currentState!.pushNamed(to, arguments: args);
        _homeNavigate.currentState!.pushNamed(to, arguments: arguments);
        // Navigator.of(context).pushNamed(to, arguments: arguments);
      }
    }
    // pushReplacementNamed will execute the enter animation and popAndPushNamed will execute the exit animation.
    // Navigator.of(context).pushReplacementNamed('/screen4');
    // Navigator.popAndPushNamed(context, '/screen4')

    // Navigator.pushNamed(context, '/album')
    // widget.home.currentState!.pushNamed('/artist');
    // widget.home.currentState!.popAndPushNamed('/artist');
    // widget.home.currentState!.pushReplacementNamed('/artist');
    // widget.home.currentState!.pushNamedAndRemoveUntil('/artist', (route) => false);
    // final abc = ModalRoute.of(context)!.settings.name;
    // print(abc);
  }

  int history = 0;

  void Function()? onPreviousHistory(){
    // _controller.master.bottom.pageChange(index);
    debugPrint('onPreviousHistory');

    // final items = core.collection.boxOfHistory;
    // var abc = items.valuesBetween(startKey:1, endKey: 10);
    // debugPrint(abc.map((e) => e.word));
    //   final items = core.collection.boxOfHistory.toMap().values.toList();
    //   items.sort((a, b) => b.date!.compareTo(a.date!));

    // if (items.length > history) {
    //   return (){
    //     // debugPrint(items.first.word);
    //     debugPrint(items.map((e) => e.word));
    //     onSearch(items.elementAt(1).word);
    //   };
    // }

    return null;
  }

  void Function()? onNextHistory(){
    // _controller.master.bottom.pageChange(index);
    debugPrint('onNextHistory');
    return null;
  }

  // void onSearch(String word){
  //   NotifyNavigationButton.navigation.value = 0;
  //   core.collection.searchQuery = word;
  //   Future.delayed(const Duration(milliseconds: 200), () {
  //     core.definitionGenerate();
  //   });
  //   Future.delayed(Duration.zero, () {
  //     core.collection.historyUpdate(word);
  //   });
  // }

  // void _pageChanged(int index){
  //   // _controller.master.bottom.pageChange(index);
  //   viewNotifyNavigation.value = index;
  // }
}
