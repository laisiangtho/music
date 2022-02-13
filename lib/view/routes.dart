import 'package:flutter/material.dart';
import 'package:lidea/view/main.dart';

import '/core/main.dart';

import 'main.dart' as root;

// import 'launch/main.dart' as launch;
// import 'blog/main.dart' as blog;
// import 'article/main.dart' as article;
// import '../search/main.dart' as search;
// import '../user/main.dart' as user;
// import '../read/main.dart' as read;
// import 'reorderable/main.dart' as reorderable;
// import 'dismissible/main.dart' as dismissible;
// import 'recent_search/main.dart' as recent_search;

import 'launch/main.dart' as launch;
import 'launch/home/main.dart' as home;
import 'launch/blog/main.dart' as blog;
import 'launch/article/main.dart' as article;
import 'launch/reorderable/main.dart' as reorderable;
import 'launch/dismissible/main.dart' as dismissible;
import 'launch/recent_search/main.dart' as recent_search;
import 'launch/recent_play/main.dart' as recent_play;
import 'launch/note/main.dart' as note;
import 'launch/favorite_word/main.dart' as favorite_word;
import 'launch/library/main.dart' as music_library;
import 'launch/store/main.dart' as store;

import 'search/main.dart' as search_page;
import 'search/result/main.dart' as search_result;
import 'search/suggest/main.dart' as search_suggest;

import 'user/main.dart' as user;
import 'read/main.dart' as reader;
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

  // static GlobalKey<NavigatorState> homeNavigator = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> homeNavigator = launch.Main.navigator;
  static GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  static String homeInitial({String? name}) => name ?? launch.Main.route;

  static Widget _homePage(RouteSettings route) {
    switch (route.name) {
      case search_page.Main.route:
        return search_page.Main(
          arguments: route.arguments,
          defaultRouteName: search_suggest.Main.route,
        );
      // case search_page.Main.route:
      //   return search_result.Main(arguments: route.arguments);
      // case search_suggest.Main.route:
      //   return search_suggest.Main(arguments: route.arguments);
      case search_suggest.Main.route:
        return search_page.Main(
          arguments: route.arguments,
          defaultRouteName: search_suggest.Main.route,
        );
      case search_result.Main.route:
        return search_page.Main(
          arguments: route.arguments,
          defaultRouteName: search_result.Main.route,
        );
      // case search_result.Main.route:
      //   return search_page.Main(arguments: route.arguments);

      // case search_result.Main.route:
      //   return search_result.Main(arguments: route.arguments);
      // case search_suggest.Main.route:
      //   return search_suggest.Main(arguments: route.arguments);

      case user.Main.route:
        return user.Main(arguments: route.arguments);
      case setting.Main.route:
        return setting.Main(arguments: route.arguments);
      case reader.Main.route:
        return reader.Main(arguments: route.arguments);
      case note.Main.route:
        return note.Main(arguments: route.arguments);
      case favorite_word.Main.route:
        return favorite_word.Main(arguments: route.arguments);
      case music_library.Main.route:
        return music_library.Main(arguments: route.arguments);
      case store.Main.route:
        return store.Main(arguments: route.arguments);
      case recent_search.Main.route:
        return recent_search.Main(arguments: route.arguments);
      case recent_play.Main.route:
        return recent_play.Main(arguments: route.arguments);

      case blog.Main.route:
        return blog.Main(arguments: route.arguments);
      case article.Main.route:
        return article.Main(arguments: route.arguments);
      case reorderable.Main.route:
        return reorderable.Main(arguments: route.arguments);
      case dismissible.Main.route:
        return dismissible.Main(arguments: route.arguments);

      case album_list.Main.route:
        return album_list.Main(arguments: route.arguments);
      case album_info.Main.route:
        return album_info.Main(arguments: route.arguments);
      case artist_list.Main.route:
        return artist_list.Main(arguments: route.arguments);
      case artist_info.Main.route:
        return artist_info.Main(arguments: route.arguments);

      case home.Main.route:
      default:
        // throw Exception('Invalid route: ${route.name}');
        return home.Main(arguments: route.arguments);
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

  static Route<dynamic>? homeBuilder(RouteSettings route) {
    return PageRouteBuilder(
      settings: route,
      pageBuilder: (BuildContext _, Animation<double> _a, Animation<double> _b) {
        return _homePage(route);
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (_, animation, _b, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      fullscreenDialog: true,
    );
  }

  // static GlobalKey<NavigatorState> searchNavigator = search_page.Main.navigator;
  // static GlobalKey<NavigatorState> searchNavigator => GlobalKey<NavigatorState>();

  static String searchInitial({String? name}) => name ?? search_result.Main.route;

  static Route<dynamic>? searchBuilder(RouteSettings route, Object? args) {
    // final arguments = ViewNavigationArguments(
    //   navigator: searchNavigator,
    //   args: args,
    // );
    return PageRouteBuilder(
      settings: route,
      pageBuilder: (BuildContext _, Animation<double> _a, Animation<double> _b) {
        switch (route.name) {
          case search_suggest.Main.route:
            return search_suggest.Main(arguments: args);
          case search_result.Main.route:
          default:
            return search_result.Main(arguments: args);
        }
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
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
    // WidgetKeepAlive(
    //   key: setting.Main.uniqueKey,
    //   child: const setting.Main(),
    // ),
    // ViewKeepAlive(
    //   key: recent_play.Main.uniqueKey,
    //   child: const recent_play.Main(),
    // ),
  ];
}
