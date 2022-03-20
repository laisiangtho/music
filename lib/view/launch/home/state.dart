part of 'main.dart';

abstract class _State extends WidgetState with TickerProviderStateMixin {
  late final args = argumentsAs<ViewNavigationArguments>();

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeIn,
  );

  late final Box<RecentPlayType> box = collection.boxOfRecentPlay;
  late final langList = cacheBucket.langAvailable();

  // Iterable<AudioMetaType> get trackMeta => core.audio.metaById([3384,3876,77,5,7,8]);
  // Iterable<int> get trackMeta => [3384,3876,77,5,7,8];
  Iterable<int> get trackMeta => cacheBucket.track.take(7).map((e) => e.id);
  Iterable<AudioCategoryLang> get language => cacheBucket.langAvailable();
  // Iterable<AudioArtistType> artistPopularByLang(int id) => cacheBucket.artistPopularByLang(id);
  Iterable<int> artistPopularByLang(int id) => cacheBucket.artistPopularByLang(id);
  Iterable<AudioAlbumType> get albumPopular => cacheBucket.album.take(17);

  // bool _showModal = false;
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  // late PersistentBottomSheetController? _bottomSheetController;

  @override
  void initState() {
    super.initState();
    // Future.microtask((){});
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // _scrollController.addListener(() {
      //   print('scrolling');
      // });
      // _scrollController.position.isScrollingNotifier.dispose();

      scrollController.position.isScrollingNotifier.addListener(() {
        if (!scrollController.position.isScrollingNotifier.value) {
          // if (_animationController.isDismissed && snap.shrink == 1.0) {
          //   _animationController.forward();
          // } else if (_animationController.isCompleted && snap.shrink < 1.0) {
          //   _animationController.reverse(from: snap.shrink);
          // }
          final userScrollIndex = scrollController.position.userScrollDirection.index;
          // final userScrollName = _scrollController.position.userScrollDirection.name;
          if (userScrollIndex == 1 && _animationController.value < 1.0) {
            _animationController.forward(from: _animationController.value);
          } else if (userScrollIndex == 2 && _animationController.value > 0.0) {
            _animationController.reverse(from: _animationController.value);
          }
        }
      });
    });
  }

  // void onClear() {
  //   Future.microtask(() {});
  // }

  void onSearch(String ord) {
    suggestQuery = ord;
    searchQuery = suggestQuery;

    Future.microtask(() {
      core.conclusionGenerate();
    });
    core.navigate(to: '/search-result');
  }

  // void onDelete(String word) {
  //   Future.delayed(Duration.zero, () {});
  // }

  // bool get canPop => Navigator.of(context).canPop();
}
