import 'package:flutter/material.dart';
// import 'package:lidea/provider.dart';

// import 'package:music/core.dart';
// import 'package:music/widget.dart';

import 'launch/main.dart' as Launch;
import 'album/main.dart' as Album;
import 'album-info/main.dart' as AlbumInfo;
import 'artist/main.dart' as Artist;
import 'artist-info/main.dart' as ArtistInfo;

class Main extends StatefulWidget {
  Main({Key? key, required this.navigateKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigateKey;

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Main> with SingleTickerProviderStateMixin {
  // late Core core;

  final GlobalKey<State> key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // core = context.read<Core>();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: widget.navigateKey,
        initialRoute: '/',

        onGenerateRoute: (RouteSettings settings) {
          // You can also return a PageRouteBuilder and
          // define custom transitions between pages
          // albumName artistName artistInfo, albumInfo

          // Map<String, dynamic> args={};

          // if (settings.arguments != null){
          //   args = Map<String, dynamic>.from(settings.arguments as Map<String, dynamic>);
          // }
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) {
              switch (settings.name) {
                case '/artist':
                  return Artist.Main(arguments: settings.arguments,);
                case '/album':
                  return Album.Main(arguments: settings.arguments,);
                case '/album/id':
                  return AlbumInfo.Main(arguments: settings.arguments,);
                case '/artist/id':
                  return ArtistInfo.Main(arguments: settings.arguments,);
                case '/':
                  return Launch.Main(arguments: settings.arguments,);
                default:
                  throw Exception('Invalid route: ${settings.name}');
              }
            },
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
            // transitionsBuilder: (_, animation, __, child) => SlideTransition(
            //   position: Tween<Offset>(
            //     begin: const Offset(1, 0),
            //     end: Offset.zero,
            //   ).animate(animation),
            //   child: child,
            // ),
            // transitionsBuilder: (_, animation, __, child) => Stack(
            //   children: <Widget>[
            //     SlideTransition(
            //       position: new Tween<Offset>(
            //         begin: const Offset(0.0, 0.0),
            //         end: const Offset(-1.0, 0.0),
            //       ).animate(animation),
            //       child: child,
            //     ),
            //     SlideTransition(
            //       position: new Tween<Offset>(
            //         begin: const Offset(1.0, 0.0),
            //         end: Offset.zero,
            //       ).animate(animation),
            //       child: child,
            //     )
            //   ],
            // ),
            fullscreenDialog: true
          );
          // return PageRouteBuilder(
          //   settings: settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
          //   pageBuilder: (_, __, ___) => Launch.Main(arguments: settings.arguments,),
          //   transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)
          // );
          // print('args: $args ${args.isEmpty}');
          // return PageRouteBuilder(
          //   builder: (BuildContext context) {
          //     switch (settings.name) {
          //       case '/artist':
          //         return Artist.Main(arguments: settings.arguments,);
          //       case '/album':
          //         return Album.Main(arguments: settings.arguments,);
          //       case '/album/id':
          //         return AlbumInfo.Main(arguments: settings.arguments,);
          //       case '/artist/id':
          //         return ArtistInfo.Main(arguments: settings.arguments,);
          //       case '/':
          //         return Launch.Main(arguments: settings.arguments,);
          //       default:
          //         throw Exception('Invalid route: ${settings.name}');
          //     }
          //   },
          //   settings: settings,
          //   maintainState: true
          // );
          // return MaterialPageRoute(
          //   builder: (BuildContext context) {
          //     switch (settings.name) {
          //       case '/artist':
          //         return Artist.Main(arguments: settings.arguments,);
          //       case '/album':
          //         return Album.Main(arguments: settings.arguments,);
          //       case '/album/id':
          //         return AlbumInfo.Main(arguments: settings.arguments,);
          //       case '/artist/id':
          //         return ArtistInfo.Main(arguments: settings.arguments,);
          //       case '/':
          //         return Launch.Main(arguments: settings.arguments,);
          //       default:
          //         throw Exception('Invalid route: ${settings.name}');
          //     }
          //   },
          //   settings: settings,
          //   maintainState: true
          // );
        }
      )
    );
  }

}
