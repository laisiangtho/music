part of "main.dart";

class Collection extends ClusterDocket {
  // audioBucket jsonBucket dataBucket
  late AudioBucketType cacheBucket;
  late Box<FavoriteWordType> boxOfFavoriteWord;
  late Box<FilterCommonType> boxOfFilterCommon;
  late Box<LibraryType> boxOfLibrary;
  late Box<RecentPlayType> boxOfRecentPlay;

  SuggestionType<OfRawType> cacheSuggestion = const SuggestionType();
  ConclusionType<OfRawType> cacheConclusion = const ConclusionType();

  // retrieve the instance through the app
  Collection.internal();

  @override
  Future<void> ensureInitialized() async {
    await super.ensureInitialized();
    Hive.registerAdapter(FavoriteWordAdapter());
    Hive.registerAdapter(FilterCommonAdapter());
    Hive.registerAdapter(LibraryAdapter());
    Hive.registerAdapter(RecentPlayAdapter());
  }

  @override
  Future<void> prepareInitialized() async {
    await super.prepareInitialized();
    boxOfFavoriteWord = await Hive.openBox<FavoriteWordType>('favorite');
    boxOfFilterCommon = await Hive.openBox<FilterCommonType>('filter');
    boxOfLibrary = await Hive.openBox<LibraryType>('library');
    boxOfRecentPlay = await Hive.openBox<RecentPlayType>('recentplay');

    if (boxOfFilterCommon.get('artist') == null) {
      boxOfFilterCommon.put('artist', FilterCommonType(date: DateTime.now()));
    }
    if (boxOfFilterCommon.get('album') == null) {
      boxOfFilterCommon.put('album', FilterCommonType(date: DateTime.now()));
    }

    // core.collection.boxOfLibrary.listenable()
  }

  // NOTE: Favorite
  /// get all favorite favoriteEntries
  Iterable<MapEntry<dynamic, FavoriteWordType>> get favorites {
    return boxOfFavoriteWord.toMap().entries;
  }

  /// favorite is EXIST by word
  MapEntry<dynamic, FavoriteWordType> favoriteExist(String ord) {
    return favorites.firstWhere(
      (e) => stringCompare(e.value.word, ord),
      orElse: () => MapEntry(null, FavoriteWordType(word: ord)),
    );
  }

  /// favorite UPDATE on exist, if not INSERT
  bool favoriteUpdate(String ord) {
    if (ord.isNotEmpty) {
      final ob = favoriteExist(ord);
      ob.value.date = DateTime.now();
      if (ob.key == null) {
        boxOfFavoriteWord.add(ob.value);
      } else {
        boxOfFavoriteWord.put(ob.key, ob.value);
      }
      // print('recentSearchUpdate ${ob.value.hit}');
      return true;
    }
    return false;
  }

  /// favorite DELETE by word
  bool favoriteDelete(String ord) {
    if (ord.isNotEmpty) {
      final ob = favoriteExist(ord);
      if (ob.key != null) {
        boxOfFavoriteWord.delete(ob.key);
        return true;
      }
    }
    return false;
  }

  /// favorite DELETE on exist, if not INSERT
  bool favoriteSwitch(String ord) {
    // if (ord.isNotEmpty) {
    //   final ob = favoriteExist(ord);
    //   if (ob.key != null) {
    //     favoriteDelete(ord);
    //   } else {
    //     return favoriteUpdate(ord);
    //   }
    // }
    return false;
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
    final ob = boxOfRecentPlay.toMap().entries.firstWhere((e) {
      return e.value.id == id;
    }, orElse: () {
      return MapEntry(null, RecentPlayType(id: id));
    });

    debugPrint('ob.value.plays from: ${ob.value.plays}');

    ob.value.plays++;
    debugPrint('ob.value.plays to: ${ob.value.plays}');
    debugPrint('ob.value.date from: ${ob.value.date}');
    ob.value.date = DateTime.now();
    debugPrint('ob.value.date to: ${ob.value.date}');
    if (ob.key == null) {
      boxOfRecentPlay.add(ob.value);
      debugPrint('ob.value. updating');
      return true;
    } else {
      boxOfRecentPlay.put(ob.key, ob.value);
      debugPrint('ob.value. updating');
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
        boxOfLibrary.add(_defaultValueLike);
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
        boxOfLibrary.add(_defaultValueQueue);
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
