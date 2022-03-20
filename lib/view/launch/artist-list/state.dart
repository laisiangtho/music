part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  @override
  void initState() {
    super.initState();
    artistInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void onClear() {
  //   Future.microtask(() {});
  // }

  // void onSearch(String word) {}

  // void onDelete(String word) {
  //   Future.delayed(Duration.zero, () {});
  // }

  late final FilterCommonType filter = core.artistFilter;
  late Iterable<AudioArtistType> artist;

  void artistInit() {
    artist = core.artistList();
  }
}
