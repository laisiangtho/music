part of data.type;

class Collection extends ClusterDocket {
  // audioBucket jsonBucket dataBucket
  late AudioBucketType cacheBucket;

  late final boxOfFilterCommon = BoxOfFilterCommon<FilterCommonType>();
  late final boxOfLibrary = BoxOfLibrary<LibraryType>();
  late final boxOfRecentPlay = BoxOfRecentPlay<RecentPlayType>();

  SuggestionType<OfRawType> cacheSuggestion = const SuggestionType();
  ConclusionType<OfRawType> cacheConclusion = const ConclusionType();

  // retrieve the instance through the app
  Collection.internal();
  // Collection.internal() : super.internal();

  @override
  Future<void> ensureInitialized() async {
    await super.ensureInitialized();

    boxOfFilterCommon.registerAdapter(FilterCommonAdapter());
    boxOfLibrary.registerAdapter(LibraryAdapter());
    boxOfRecentPlay.registerAdapter(RecentPlayAdapter());
  }

  @override
  Future<void> prepareInitialized() async {
    await super.prepareInitialized();

    await boxOfFilterCommon.open('filter');
    await boxOfLibrary.open('library');
    await boxOfRecentPlay.open('recentplay');

    if (boxOfFilterCommon.box.get('artist') == null) {
      boxOfFilterCommon.box.put('artist', FilterCommonType(date: DateTime.now()));
    }
    if (boxOfFilterCommon.box.get('album') == null) {
      boxOfFilterCommon.box.put('album', FilterCommonType(date: DateTime.now()));
    }

    // core.collection.boxOfLibrary.listenable()
  }

  /// recent-play UPDATE on exist, if not INSERT
  bool recentPlayUpdate(int id) {
    // if (id > 0) {
    //   final ob = favoriteExist(ord);
    //   ob.value.date = DateTime.now();
    //   if (ob.key == null) {
    //     boxOfFavoriteWord.add(ob.value);
    //   } else {
    //     boxOfFavoriteWord.put(ob.key, ob.value);
    //   }
    //   // print('recentSearchUpdate ${ob.value.hit}');
    //   return true;
    // }
    final ob = boxOfRecentPlay.entries.firstWhere((e) {
      return e.value.id == id;
    }, orElse: () {
      return MapEntry(null, RecentPlayType(id: id));
    });

    // debugPrint('ob.value.plays from: ${ob.value.plays}');

    ob.value.plays++;
    // debugPrint('ob.value.plays to: ${ob.value.plays}');
    // debugPrint('ob.value.date from: ${ob.value.date}');
    ob.value.date = DateTime.now();
    // debugPrint('ob.value.date to: ${ob.value.date}');
    if (ob.key == null) {
      boxOfRecentPlay.box.add(ob.value);
      // debugPrint('ob.value. updating');
      return true;
    } else {
      boxOfRecentPlay.box.put(ob.key, ob.value);
      // debugPrint('ob.value. updating');
    }
    return false;
  }

  // final abc = collection.env.url('track').uri(name: '4354', index: 1, scheme: 'http');
  // final abc = collection.env.url('track').cache('4354');
  String trackCache(int id) => env.url('track').cache(id);
  Uri trackLive(int id) => env.url('track').uri(id);

  LibraryType get _defaultValueQueue {
    return LibraryType(
      date: DateTime.now(),
      name: 'Queue',
      type: 0,
      list: [],
    );
  }

  LibraryType get _defaultValueLike {
    return LibraryType(
      date: DateTime.now(),
      name: 'Like',
      type: 1,
      list: [],
    );
  }

  LibraryType get valueOfLibraryLike {
    return boxOfLibrary.values.firstWhere(
      (e) {
        return e.type == 1;
      },
      orElse: () {
        boxOfLibrary.box.add(_defaultValueLike);
        return _defaultValueLike;
      },
    );
  }

  LibraryType get valueOfLibraryQueue {
    return boxOfLibrary.values.firstWhere(
      (e) {
        return e.type == 0;
      },
      orElse: () {
        boxOfLibrary.box.add(_defaultValueQueue);
        return boxOfLibrary.values.firstWhere((e) {
          return e.type == 0;
        });
      },
    );
  }

  Iterable<LibraryType> get listOfLibraryPlaylists {
    return boxOfLibrary.values.where(
      (e) {
        return e.type > 2;
      },
    );
  }
}
