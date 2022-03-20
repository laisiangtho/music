part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  late final Box<RecentPlayType> box = collection.boxOfRecentPlay;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void onClear() {
  //   box.clear();
  // }
}
