import 'package:flutter/material.dart';
import 'package:lidea/view/main.dart';

import '/core/main.dart';

import 'main.dart' as root;

import 'launch/main.dart' as launch;
import 'launch/home/main.dart' as home;

import 'launch/recent_search/main.dart' as recent_search;
import 'launch/recent_play/main.dart' as recent_play;

import 'launch/library/main.dart' as music_library;
import 'launch/store/main.dart' as store;

import 'search/main.dart' as search_page;
import 'search/result/main.dart' as search_result;
import 'search/suggest/main.dart' as search_suggest;

import 'user/main.dart' as user;
// import 'read/main.dart' as reader;
import 'setting/main.dart' as setting;

import 'launch/album-list/main.dart' as album_list;
import 'launch/album-info/main.dart' as album_info;
import 'launch/artist-list/main.dart' as artist_list;
import 'launch/artist-info/main.dart' as artist_info;

class AppRoutes {
  static String rootInitial = root.Main.route;
  static Map<String, Widget Function(BuildContext)> rootMap = {
    root.Main.route: (BuildContext _) {
      return const root.Main();
    },
    // bible.Main.route: (BuildContext _) {
    //   return const bible.Main();
    // },
  };

  // static void showParallelList(BuildContext context) {
  //   // Navigator.of(context, rootNavigator: true).pushNamed(
  //   //   bible.Main.route,
  //   // );
  // }

  static GlobalKey<NavigatorState> homeNavigator = launch.Main.navigator;
  static GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  static String homeInitial({String? name}) => name ?? launch.Main.route;

  static Widget _homePage(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case search_page.Main.route:
        return search_page.Main(
          arguments: routeSettings.arguments,
          defaultRouteName: search_suggest.Main.route,
        );
      // case search_page.Main.route:
      //   return search_result.Main(arguments: route.arguments);
      // case search_suggest.Main.route:
      //   return search_suggest.Main(arguments: route.arguments);
      case search_suggest.Main.route:
        return search_page.Main(
          arguments: routeSettings.arguments,
          defaultRouteName: search_suggest.Main.route,
        );
      case search_result.Main.route:
        return search_page.Main(
          arguments: routeSettings.arguments,
          defaultRouteName: search_result.Main.route,
        );
      // case search_result.Main.route:
      //   return search_page.Main(arguments: route.arguments);

      // case search_result.Main.route:
      //   return search_result.Main(arguments: route.arguments);
      // case search_suggest.Main.route:
      //   return search_suggest.Main(arguments: route.arguments);

      case user.Main.route:
        return user.Main(arguments: routeSettings.arguments);
      case setting.Main.route:
        return setting.Main(arguments: routeSettings.arguments);

      case music_library.Main.route:
        return music_library.Main(arguments: routeSettings.arguments);
      case store.Main.route:
        return store.Main(arguments: routeSettings.arguments);
      case recent_search.Main.route:
        return recent_search.Main(arguments: routeSettings.arguments);
      case recent_play.Main.route:
        return recent_play.Main(arguments: routeSettings.arguments);

      case album_list.Main.route:
        return album_list.Main(arguments: routeSettings.arguments);
      case album_info.Main.route:
        return album_info.Main(arguments: routeSettings.arguments);
      case artist_list.Main.route:
        return artist_list.Main(arguments: routeSettings.arguments);
      case artist_info.Main.route:
        return artist_info.Main(arguments: routeSettings.arguments);

      case home.Main.route:
      default:
        // throw Exception('Invalid route: ${routeSettings.name}');
        return home.Main(arguments: routeSettings.arguments);
    }
  }

  // static Route<dynamic>? homeBuilder(RouteSettings route) {
  //   return MaterialPageRoute<void>(
  //     settings: route,
  //     fullscreenDialog: true,
  //     builder: (BuildContext context) {
  //       return _homePage(route);
  //     },
  //   );
  // }

  static Route<dynamic>? homeBuilder(RouteSettings routeSettings) {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (BuildContext _, Animation<double> _a, Animation<double> _b) {
        return _homePage(routeSettings);
      },
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (_, animation, _b, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      fullscreenDialog: true,
    );
  }

  static String searchInitial({String? name}) => name ?? search_result.Main.route;

  static Route<dynamic>? searchBuilder(RouteSettings routeSettings, Object? args) {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (BuildContext _, Animation<double> _a, Animation<double> _b) {
        switch (routeSettings.name) {
          case search_suggest.Main.route:
            return search_suggest.Main(arguments: args);
          case search_result.Main.route:
          default:
            return search_result.Main(arguments: args);
        }
      },
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      fullscreenDialog: true,
    );
  }
}

// AppPageView AppPageNavigation
class AppPageNavigation {
  // static final controller = PageController(keepPage: true);
  static List<ViewNavigationModel> button(Preference preference) {
    return [
      ViewNavigationModel(
        key: 0,
        icon: launch.Main.icon,
        name: launch.Main.name,
        description: preference.text.home,
      ),
      ViewNavigationModel(
        key: 1,
        icon: music_library.Main.icon,
        name: music_library.Main.name,
        description: preference.text.library(false),
      ),
      ViewNavigationModel(
        key: 2,
        icon: store.Main.icon,
        name: store.Main.name,
        description: preference.text.store,
      ),
      // ViewNavigationModel(
      //   key: 3,
      //   icon: setting.Main.icon,
      //   name: setting.Main.name,
      //   description: translate.setting(false),
      // ),
      const ViewNavigationModel(
        key: 3,
        icon: recent_play.Main.icon,
        name: recent_play.Main.name,
        description: 'Recent Play',
      ),
      // const ViewNavigationModel(
      //   key: 4,
      //   icon: search_page.Main.icon,
      //   name: search_page.Main.name,
      //   description: 'Search',
      // ),
      // ViewNavigationModel(
      //   key: 4,
      //   icon: Icons.expand_more,
      //   name: 'Toggle',
      //   description: preference.text.parallel,
      // ),
    ];
  }

  static List<Widget> page = [
    ViewKeepAlive(
      key: launch.Main.uniqueKey,
      child: const launch.Main(),
    ),
    ViewKeepAlive(
      key: music_library.Main.uniqueKey,
      child: const music_library.Main(),
    ),
    // ViewKeepAlive(
    //   key: recent_search.Main.uniqueKey,
    //   child: const recent_search.Main(),
    // ),
    ViewKeepAlive(
      key: store.Main.uniqueKey,
      child: const store.Main(),
    ),
    // ViewKeepAlive(
    //   key: search_page.Main.uniqueKey,
    //   child: const search_page.Main(),
    // ),
    // ViewKeepAlive(
    //   key: setting.Main.uniqueKey,
    //   child: const setting.Main(),
    // ),
    // ViewKeepAlive(
    //   key: recent_play.Main.uniqueKey,
    //   child: const recent_play.Main(),
    // ),
  ];
}
