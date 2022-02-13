// NOTE: Flutter: material
import 'package:flutter/material.dart';
// NOTE: SystemUiOverlayStyle
import 'package:flutter/services.dart';
// NOTE: Locale delegation
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// NOTE: Privider: state management
import 'package:lidea/provider.dart';
// NOTE: Scroll
import 'package:lidea/view/main.dart';

import '/core/main.dart';
import '/coloration.dart';

import '/view/routes.dart';

// const bool isProduction = bool.fromEnvironment('dart.vm.product');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  // }

  final core = Core();
  await core.ensureInitialized();
  // authentication.stateObserver(core.userObserver);

  runApp(Zaideih(core: core));
}

class Zaideih extends StatelessWidget {
  final Core core;

  const Zaideih({Key? key, required this.core}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Core>(
          create: (context) => core,
        ),
        ChangeNotifierProvider<Preference>(
          create: (context) => core.preference,
        ),
        ChangeNotifierProvider<Authentication>(
          create: (context) => core.authentication,
        ),
        ChangeNotifierProvider<NavigationNotify>(
          create: (context) => core.navigation,
          // create: (context) => NavigationNotify(),
        ),
        ChangeNotifierProvider<ViewScrollNotify>(
          create: (context) => ViewScrollNotify(),
        ),
      ],
      child: start(),
    );
  }

  Widget start() {
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: core.preference,
      builder: (BuildContext context, Widget? child) {
        // debugPrint('${settings.themeMode}');
        return MaterialApp(
          showSemanticsDebugger: false,
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'lidea',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: core.preference.locale,
          // locale: Localizations.localeOf(context),
          supportedLocales: const [
            // English
            Locale('en', 'GB'),
            // Norwegian
            Locale('no', 'NO'),
            // Myanmar
            Locale('my', ''),
          ],
          darkTheme: Coloration.dark(context),
          theme: Coloration.light(context),
          themeMode: core.preference.themeMode,
          onGenerateTitle: (BuildContext context) => core.collection.env.name,
          initialRoute: AppRoutes.rootInitial,
          routes: AppRoutes.rootMap,
          navigatorObservers: [
            NavigationObserver(
                // Provider.of<NavigationNotify>(
                //   context,
                //   listen: false,
                // ),
                core.navigation),
          ],
          builder: (BuildContext context, Widget? view) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                systemNavigationBarColor: Theme.of(context).primaryColor,
                // systemNavigationBarDividerColor: Colors.transparent,
                // systemNavigationBarDividerColor: Colors.red,
                systemNavigationBarIconBrightness: core.preference.resolvedSystemBrightness,
                systemNavigationBarContrastEnforced: false,
                statusBarColor: Colors.transparent,
                statusBarBrightness: core.preference.systemBrightness,
                statusBarIconBrightness: core.preference.resolvedSystemBrightness,
                systemStatusBarContrastEnforced: false,
              ),
              child: view!,
            );
          },
          /*
          home: Builder(
            builder: (BuildContext context) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  systemNavigationBarColor: Theme.of(context).primaryColor,
                  systemNavigationBarDividerColor: Colors.transparent,
                  systemNavigationBarIconBrightness: settings.resolvedSystemBrightness,
                  systemNavigationBarContrastEnforced: true,
                  statusBarColor: Colors.transparent,
                  statusBarBrightness: settings.resolvedSystemBrightness,
                  statusBarIconBrightness: settings.resolvedSystemBrightness,
                  systemStatusBarContrastEnforced: true,
                ),
                child: AppMain(settings: settings),
              );
            },
          ),
          onGenerateRoute: (RouteSettings route) => PageRouteBuilder<void>(
            settings: route,
            pageBuilder: (BuildContext context, Animation<double> a, Animation<double> b) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  systemNavigationBarColor: Theme.of(context).primaryColor,
                  systemNavigationBarDividerColor: Colors.transparent,
                  systemNavigationBarIconBrightness: settings.resolvedSystemBrightness,
                  systemNavigationBarContrastEnforced: true,
                  statusBarColor: Colors.transparent,
                  statusBarBrightness: settings.resolvedSystemBrightness,
                  statusBarIconBrightness: settings.resolvedSystemBrightness,
                  systemStatusBarContrastEnforced: true,
                ),
                child: AppMain(settings: settings),
              );
            },
          ),
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                controller.context = context;
                switch (routeSettings.name) {
                  case AppMain.routeName:
                  default:
                    return AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle(
                        systemNavigationBarColor: Theme.of(context).primaryColor,
                        systemNavigationBarDividerColor: Colors.transparent,
                        systemNavigationBarIconBrightness: controller.resolvedSystemBrightness,
                        systemNavigationBarContrastEnforced: true,
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: controller.resolvedSystemBrightness,
                        statusBarIconBrightness: controller.resolvedSystemBrightness,
                        systemStatusBarContrastEnforced: true,
                      ),
                      child: const AppMain(),
                    );
                }
              },
            );
          },
          */
        );
      },
    );
  }
}
