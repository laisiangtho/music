part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();
  late final Box<LibraryType> box = collection.boxOfLibrary.box;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  LibraryType get likes {
    return collection.valueOfLibraryLike;
  }

  LibraryType get queues {
    return collection.valueOfLibraryQueue;
  }

  Iterable<LibraryType> get playlists {
    return collection.listOfLibraryPlaylists;
  }

  void clearAll() {
    box.clear();
  }

  void showDetail(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) => WidgetDraggableLibraryModel(index: index),
    );
    // showModalBottomSheet(
    //   context: context,
    //   // builder: (BuildContext context) => TrackOption(
    //   //   trackId: track.trackInfo.id,
    //   // ),
    //   builder: (BuildContext context) {
    //     return AnnotatedRegion<SystemUiOverlayStyle>(
    //       // value: SystemUiOverlayStyle.light.copyWith(
    //       //   systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
    //       //   systemNavigationBarDividerColor: Theme.of(context).focusColor,
    //       // ),
    //       value: SystemUiOverlayStyle(
    //         // systemNavigationBarColor: Theme.of(context).primaryColor,
    //         systemNavigationBarDividerColor: Theme.of(context).focusColor,
    //         // systemNavigationBarIconBrightness: Brightness.dark,
    //       ),
    //       child: TrackOption(
    //         trackId: track.trackInfo.id,
    //       ),
    //     );
    //   },
    //   barrierColor: Theme.of(context).shadowColor.withOpacity(0.6),
    //   // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //   // backgroundColor: Theme.of(context).primaryColor,
    //   isScrollControlled: true,
    //   elevation: 10,
    //   useRootNavigator: true,
    // ).whenComplete(
    //   () => Future.delayed(
    //     const Duration(milliseconds: 300),
    //     () => {},
    //   ),
    // );
  }

  void showEditor() {
    doConfirmWithWidget(
      context: context,
      child: const PlayListsEditor(),
    );
  }
}
