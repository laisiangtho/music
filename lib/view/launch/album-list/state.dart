part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  late final FilterCommonType filter = core.albumFilter;
  late Iterable<AudioAlbumType> album;

  @override
  void initState() {
    super.initState();
    albumInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void albumInit() {
    album = core.albumList();
  }
}
