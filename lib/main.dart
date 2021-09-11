import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter/scheduler.dart' show timeDilation;

// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/idea.dart';
// import 'package:lidea/connectivity.dart';

import 'package:music/core.dart';
// import 'package:music/model.dart';
import 'package:music/theme.dart';
import 'package:music/view/app.dart';
import 'package:lidea/view/notify.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  return runApp(Zaideih());
}

class Zaideih extends StatelessWidget {
  Zaideih({Key? key, this.initialRoute}) : super(key: key);

  final String? initialRoute;

  @override
  Widget build(BuildContext context){
    return IdeaModel(
      initialModel: IdeaTheme(
        themeMode: ThemeMode.system,
        textFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTesting: true
      ),
      child: appProvider()
    );
  }

  Widget appProvider(){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotifyViewScroll>(
          create: (context) => NotifyViewScroll(),
        ),
        ChangeNotifierProvider<Core>(
          create: (context) => Core(),
        )
      ],
      child:  app()
    );
  }
  Widget app(){
    return Builder(
      builder: (context) => uiOverlayStyle(
        context: context,
        isBrightness: IdeaTheme.of(context).resolvedSystemBrightness == Brightness.light,
        brightness: IdeaTheme.of(context).resolvedSystemBrightness,
        child: MaterialApp(
          title: "Zaideih",
          // title: Core.instance.collection.env.name,
          showSemanticsDebugger: false,
          debugShowCheckedModeBanner: false,
          darkTheme: IdeaData.dark.copyWith(
            platform: IdeaTheme.of(context).platform,
            brightness: IdeaTheme.of(context).systemBrightness
          ),
          theme: IdeaData.light.copyWith(
            platform: IdeaTheme.of(context).platform,
            brightness: IdeaTheme.of(context).systemBrightness
          ),
          themeMode: IdeaTheme.of(context).themeMode,
          locale: IdeaTheme.of(context).locale,
          // supportedLocales: GalleryLocalizations.supportedLocales,
          // localizationsDelegates: const [
          //   ...GalleryLocalizations.localizationsDelegates,
          //   LocaleNamesLocalizationsDelegate()
          // ],
          localeResolutionCallback: (locale, supportedLocales) => locale,
          // initialRoute: initialRoute,
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
            builder: (context) => ApplyTextOptions(
              child: AppMain(key: key)
            ),
            settings: settings
          )
          // onUnknownRoute: RouteConfiguration.onUnknownRoute,
        )
      )
    );
  }

  Widget uiOverlayStyle({required BuildContext context, required Brightness brightness, required bool isBrightness, required Widget child}){
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness,
        statusBarBrightness: isBrightness?Brightness.dark:Brightness.light,
        // systemNavigationBarColor: isBrightness?IdeaData.darkScheme.primary:IdeaData.lightScheme.primary,
        systemNavigationBarColor: isBrightness?IdeaData.dark.primaryColor:IdeaData.light.primaryColor,
        // systemNavigationBarColor: isBrightness?IdeaData.dark.scaffoldBackgroundColor:IdeaData.light.scaffoldBackgroundColor,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: brightness
      ),
      child: child
    );
  }
}
