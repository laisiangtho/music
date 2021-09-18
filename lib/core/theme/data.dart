import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IdeaData {
  static const IdeaColor _lightColor = const IdeaColor(
    brightness: Brightness.light,
    focus: Colors.black,
    primaryScheme: Colors.black,

    primary: Color(0xFFf7f7f7),
    // primary: Color(0xFFffffff),
    scaffold: Color(0xFFffffff),
    highlight: Colors.orange,
    // background: Color(0xFFbdbdbd),
    background: Color(0xFFe8e8e8),
    // shadow: Colors.grey[400]!,
    // shadow: Colors.grey.shade400,
    shadow: Color(0xFFbdbdbd),
    button: Color(0xFFdedcdc)

  );
  static const IdeaColor _darkColor = const IdeaColor(
    brightness: Brightness.dark,
    focus: Colors.white,
    primaryScheme: Colors.white,

    primary: Color(0xFF9c9c9c),
    // primary: Color(0xFF737373),
    scaffold: Color(0xFFa6a6a6),
    highlight: Colors.orange,
    background: Color(0xFFbdbdbd),
    // shadow: Colors.grey[600]!,
    shadow: Color(0xFF8f8f8f),
    button: Color(0xFFd9d9d9)
  );

  static ThemeData light = theme(_lightColor);
  static ThemeData dark = theme(_darkColor);

  static ThemeData theme(IdeaColor color) {
    return ThemeData(
      colorScheme: color.scheme,
      brightness: color.brightness,
      textTheme: _textTheme,

      // fontFamily: "Lato, 'Paduak', sans-serif",
      // fontFamily: "Lato, Mm3Web",
      fontFamily: "Lato, Mm3Web, sans-serif",

      primaryColor: color.primary,
      shadowColor: color.shadow,
      canvasColor: color.canvas,
      scaffoldBackgroundColor: color.scaffold,
      backgroundColor: color.background,
      highlightColor: color.highlight,
      // buttonColor:color.button,

      iconTheme: IconThemeData(
        color: color.focus
      ),

      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          primaryColor: Colors.red,
          actionTextStyle:TextStyle(color: Colors.orange)
        )
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: color.background,
        // hoverColor: Colors.green,
        // focusColor: Colors.red,
        hintStyle: const TextStyle(color: Colors.grey),

        contentPadding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),

        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.3),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        border: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        )
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(3.5)),
        ),
        clipBehavior: Clip.hardEdge,
        // clipBehavior: Clip.antiAlias,
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        // modalBackgroundColor: color.background,
        modalBackgroundColor: color.primary,
        modalElevation:2.0,
        // backgroundColor: color.primary,
        backgroundColor: color.background,
        // backgroundColor: Colors.red,
        elevation:0.0,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.cyan
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.red
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: TextStyle(
            fontSize: 13
          )
        ),
      ),
      // primaryTextTheme: _textTheme
    );
  }

  static ColorScheme lightScheme = _lightColor.scheme;
  static ColorScheme darkScheme = _darkColor.scheme;

  static const _fontWeightThin = FontWeight.w300;
  static const _fontWeighRegular = FontWeight.w400;
  static const _fontWeighMedium = FontWeight.w500;
  static const _fontWeighSemiBold = FontWeight.w600;
  static const _fontWeighBold = FontWeight.w700;

  static const TextTheme _textTheme = const TextTheme(
    headline1: TextStyle(fontWeight: _fontWeighBold, fontSize: 26.0, height: 1.0),
    headline2: TextStyle(fontWeight: _fontWeighBold, fontSize: 24.0, height: 1.0),
    headline3: TextStyle(fontWeight: _fontWeighMedium, fontSize: 19.0, height: 1.0),
    headline4: TextStyle(fontWeight: _fontWeighMedium, fontSize: 17.0, height: 1.0),
    headline5: TextStyle(fontWeight: _fontWeighMedium, fontSize: 13.0, height: 1.0),
    headline6: TextStyle(fontWeight: _fontWeighMedium, fontSize: 11.0, height: 1.0),

    subtitle1: TextStyle(fontWeight: _fontWeighRegular, fontSize: 16.0, height: 1.0),
    subtitle2: TextStyle(fontWeight: _fontWeighMedium, fontSize: 14.0, height: 1.0),

    bodyText1: TextStyle(fontWeight: _fontWeighRegular, fontSize: 16.0, height: 1.0),
    bodyText2: TextStyle(fontWeight: _fontWeighRegular, fontSize: 13.0, height: 1.0),

    caption: TextStyle(fontWeight: _fontWeighSemiBold, fontSize: 16.0, height: 1.0),
    button: TextStyle(fontWeight: _fontWeightThin,fontSize: 14.0,height: 1.0),
    overline: TextStyle(fontWeight: _fontWeighMedium, fontSize: 12.0, height: 1.0)
  );

}

// Default color configuration is light, and translated into how human mind can interpreted the material color
class IdeaColor{
  final Brightness brightness;
  final Color focus;

  final Color primary;
  final Color scaffold;
  final Color highlight;
  final Color background;
  final Color shadow;
  final Color button;

  // schemePrimary primaryScheme
  final Color primaryScheme;

  const IdeaColor({
    this.brightness:Brightness.light,
    this.focus:Colors.black,

    this.primary:Colors.white,
    this.scaffold:Colors.white,
    this.highlight:Colors.blue,
    this.background:Colors.grey,
    this.shadow:Colors.grey,

    this.button:Colors.blue,


    this.primaryScheme:Colors.white,
  });

  // Color get shadow => scaffold.darken(amount: 0.2);
  Color get canvas => Colors.transparent;

  Color get focusOpacity => focus.withOpacity(0.12);
  Color get text => focus;

  ColorScheme get scheme => ColorScheme(
    brightness: brightness,
    primary: primaryScheme,
    primaryVariant: primaryScheme.darken(),
    secondary: primaryScheme,
    secondaryVariant: primaryScheme.darken(),
    background: scaffold,
    surface: scaffold.darken(),
    error: focusOpacity,

    onError: focusOpacity,
    onPrimary: focusOpacity,
    onSecondary: focusOpacity,
    onSurface: focusOpacity,
    onBackground: scaffold
  );

}

extension ColorDimExtension on Color {
  Color darken({double amount: .1}) {
    assert(amount >= 0 && amount <= 1);
    HSLColor color = HSLColor.fromColor(this);
    return color.withLightness((color.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  Color lighten({double amount: .1}) {
    assert(amount >= 0 && amount <= 1);
    HSLColor color = HSLColor.fromColor(this);
    return color.withLightness((color.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  // Color darken(Color color, [double amount = .1]) {
  //   assert(amount >= 0 && amount <= 1);
  //   final hsl = HSLColor.fromColor(color);
  //   final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  //   return hslDark.toColor();
  // }

  // Color lighten(Color color, [double amount = .1]) {
  //   assert(amount >= 0 && amount <= 1);
  //   final hsl = HSLColor.fromColor(color);
  //   final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  //   return hslLight.toColor();
  // }
}
// Color hexStringToColor(String hexColor) {
//   hexColor = hexColor.toUpperCase().replaceAll("#", "");
//   if (hexColor.length == 6) {
//     hexColor = "FF" + hexColor;
//   }
//   return Color(int.parse(hexColor, radix: 16));
// }
// {
    // Brightness? brightness,
    // VisualDensity? visualDensity,
    // MaterialColor? primarySwatch,
    // Color? primaryColor,
    // Brightness? primaryColorBrightness,
    // Color? primaryColorLight,
    // Color? primaryColorDark,
    // Color? accentColor,
    // Brightness? accentColorBrightness,
    // Color? canvasColor,
    // Color? shadowColor,
    // Color? scaffoldBackgroundColor,
    // Color? bottomAppBarColor, Color? cardColor, Color? dividerColor, Color?
    // focusColor, Color? hoverColor, Color? highlightColor,
    // Color? splashColor, InteractiveInkFeatureFactory? splashFactory,
    // Color? selectedRowColor, Color? unselectedWidgetColor,
    // Color? disabledColor, Color? buttonColor,
    // ButtonThemeData? buttonTheme, ToggleButtonsThemeData? toggleButtonsTheme,
    // Color? secondaryHeaderColor, Color? textSelectionColor,
    // Color? cursorColor, Color? textSelectionHandleColor,
    // Color? backgroundColor, Color? dialogBackgroundColor,
    // Color? indicatorColor, Color? hintColor, Color? errorColor,
    // Color? toggleableActiveColor, String? fontFamily,
    // TextTheme? textTheme,
    // TextTheme? primaryTextTheme,
    // TextTheme? accentTextTheme,
    // InputDecorationTheme? inputDecorationTheme,
    // IconThemeData? iconTheme, IconThemeData? primaryIconTheme, IconThemeData? accentIconTheme,
    // SliderThemeData? sliderTheme,
    // TabBarTheme? tabBarTheme, TooltipThemeData? tooltipTheme, CardTheme? cardTheme, ChipThemeData? chipTheme, TargetPlatform? platform,
    // MaterialTapTargetSize? materialTapTargetSize, bool? applyElevationOverlayColor, PageTransitionsTheme? pageTransitionsTheme,
    // AppBarTheme? appBarTheme, ScrollbarThemeData? scrollbarTheme, BottomAppBarTheme? bottomAppBarTheme,
    // ColorScheme? colorScheme, DialogTheme? dialogTheme, FloatingActionButtonThemeData? floatingActionButtonTheme,
    // NavigationRailThemeData? navigationRailTheme, Typography? typography, NoDefaultCupertinoThemeData? cupertinoOverrideTheme,
    // SnackBarThemeData? snackBarTheme, BottomSheetThemeData? bottomSheetTheme, PopupMenuThemeData? popupMenuTheme, MaterialBannerThemeData? bannerTheme,
    // DividerThemeData? dividerTheme, ButtonBarThemeData? buttonBarTheme, BottomNavigationBarThemeData? bottomNavigationBarTheme, TimePickerThemeData? timePickerTheme,
    // TextButtonThemeData? textButtonTheme, ElevatedButtonThemeData? elevatedButtonTheme, OutlinedButtonThemeData? outlinedButtonTheme,
    // TextSelectionThemeData? textSelectionTheme, DataTableThemeData? dataTableTheme, CheckboxThemeData? checkboxTheme, RadioThemeData? radioTheme,
    // SwitchThemeData? switchTheme, bool? fixTextFieldOutlineLabel, bool? useTextSelectionTheme
// }