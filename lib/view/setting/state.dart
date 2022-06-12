part of 'main.dart';

abstract class MainState extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  List<String> get themeName => [
        preference.text.automatic,
        preference.text.light,
        preference.text.dark,
      ];

  @override
  void initState() {
    super.initState();

    // Future.microtask(() {
    //   final abc = Localizations.localeOf(context).languageCode;
    //   debugPrint('core.collection.locale: $abc');
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onClear() {
    Future.microtask(() {});
  }

  void onSearch(String word) {}

  void onDelete(String word) {
    Future.delayed(Duration.zero, () {});
  }
}
