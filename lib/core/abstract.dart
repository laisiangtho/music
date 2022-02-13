part of 'main.dart';

abstract class _Abstract extends UnitEngine with _Utility {
  final Collection collection = Collection.internal();

  late final Preference preference = Preference(collection);
  late final Authentication authentication = Authentication();
  late final NavigationNotify navigation = NavigationNotify();
  late final Analytics analytics = Analytics();

  late final store = Store(notify: notify, collection: collection);
  late final _sql = SQLite(collection: collection);
  late final audio = Audio(notify: notify, cluster: collection);
  late final search = Search(preference: preference, collection: collection);

  /// Initiate collection, preference, authentication
  Future<void> ensureInitialized() async {
    Stopwatch initWatch = Stopwatch()..start();

    await collection.ensureInitialized();
    await collection.prepareInitialized();
    await preference.ensureInitialized();
    await authentication.ensureInitialized();

    // if (authentication.id.isNotEmpty && authentication.id != collection.setting.userId) {
    //   final ou = collection.setting.copyWith(userId: authentication.id);
    //   await collection.settingUpdate(ou);
    // }

    debugPrint('ensureInitialized in ${initWatch.elapsedMilliseconds} ms');
  }

  String get searchQuery => collection.searchQuery;
  set searchQuery(String ord) {
    notifyIf<String>(searchQuery, collection.searchQuery = ord);
  }

  String get suggestQuery => collection.suggestQuery;
  set suggestQuery(String ord) {
    final word = ord.replaceAll(RegExp(' +'), ' ').trim();
    notifyIf<String>(suggestQuery, collection.suggestQuery = word);
  }

  // dataInitialized
  Future<void> dataInitialized() async {
    final localData = collection.env.api.where(
      (e) => e.local.isNotEmpty && !e.local.contains('mp3'),
    );
    if (collection.requireInitialized) {
      APIType api = collection.env.api.firstWhere((e) => e.asset.isNotEmpty);
      await UtilArchive.extractBundle(api.asset);
    }
    collection.cacheBucket = AudioBucketType.fromJSON(
      Map.fromEntries(
        await Future.wait(
          localData.map(
            (e) async => MapEntry(
              e.uid,
              // await UtilDocument.readAsJSON<List<dynamic>>(e.local),
              await UtilDocument.readAsJSON<dynamic>(e.local),
            ),
          ),
        ),
      ),
    );
    Stopwatch initArtistWatch = Stopwatch()..start();
    await collection.cacheBucket.artistInit();
    debugPrint('--artist-init: ${initArtistWatch.elapsedMilliseconds} ms');

    Stopwatch initTrackWatch = Stopwatch()..start();
    await collection.cacheBucket.trackInit();
    debugPrint('--track-init: ${initTrackWatch.elapsedMilliseconds} ms');

    Stopwatch initAlbumWatch = Stopwatch()..start();
    await collection.cacheBucket.albumInit();
    debugPrint('--album-init: ${initAlbumWatch.elapsedMilliseconds} ms');

    Stopwatch initLangWatch = Stopwatch()..start();
    await collection.cacheBucket.langInit();
    debugPrint('--lang-init: ${initLangWatch.elapsedMilliseconds} ms');
  }

  FilterCommonType get artistFilter {
    return collection.boxOfFilterCommon.get('artist')!;
  }

  Iterable<AudioArtistType> artistList() {
    return collection.cacheBucket.artist
        .where(
          (e) => artistFilter.character.isNotEmpty
              ? e.name.isEmpty
                  ? artistFilter.character.contains('#')
                  : artistFilter.character.contains(e.name[0])
              : collection.cacheBucket.artistRefresh(e).name.isNotEmpty,
        )
        .where(
          (e) => artistFilter.gender.isNotEmpty ? artistFilter.gender.contains(e.type) : true,
        )
        .where(
          (e) => artistFilter.language.isNotEmpty
              ? e.lang
                  .where(
                    (i) => artistFilter.language.contains(i),
                  )
                  .isNotEmpty
              : true,
        );
  }

  FilterCommonType get albumFilter {
    return collection.boxOfFilterCommon.get('album')!;
  }

  Iterable<AudioAlbumType> albumList() {
    return collection.cacheBucket.album
        .where(
          (e) => albumFilter.character.isNotEmpty
              ? e.name.isEmpty
                  ? albumFilter.character.contains('#')
                  : albumFilter.character.contains(e.name[0])
              : true,
        )
        .where(
          (e) => albumFilter.language.isNotEmpty ? albumFilter.language.contains(e.lang) : true,
        )
        .where(
          (e) => albumFilter.genre.isNotEmpty
              ? e.genre.where((i) => albumFilter.genre.contains(i)).isNotEmpty
              : true,
        );
  }

  // Future<void> initBible() async {
  //   if (collection.requireInitialized) {
  //     APIType api = collection.env.api.firstWhere(
  //       (e) => e.asset.isNotEmpty,
  //     );
  //     await UtilArchive.extractBundle(api.asset);
  //   }
  //   // if (requireInitialized) {
  //   //   final localData = collection.env.api.where((e) => e.asset.isNotEmpty);
  //   //   for (APIType api in localData) {
  //   //     await UtilArchive.extractBundle(api.asset).then((_) {
  //   //       debugPrint('Ok ${api.uid}');
  //   //     }).catchError((e) {
  //   //       debugPrint('Error ${api.uid} $e');
  //   //     });
  //   //   }
  //   // }
  // }

  // Future<void> initDictionary() async {
  //   if (collection.requireInitialized) {
  //     APIType api = collection.env.api.firstWhere(
  //       (e) => e.asset.isNotEmpty,
  //     );
  //     await UtilArchive.extractBundle(api.asset);
  //   }
  // }

  // Future<void> initMusic() async {
  //   final localData = collection.env.api.where(
  //     (e) => e.local.isNotEmpty && !e.local.contains('!'),
  //   );
  //   if (collection.requireInitialized) {
  //     APIType api = collection.env.api.firstWhere((e) => e.asset.isNotEmpty);
  //     await UtilArchive.extractBundle(api.asset);
  //   }
  //   collection.cacheBucket = AudioBucketType.fromJSON(
  //     Map.fromEntries(
  //       await Future.wait(
  //         localData.map(
  //           (e) async => MapEntry(
  //             e.uid,
  //             await UtilDocument.readAsJSON<List<dynamic>>(e.local),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Future<void> deleteOldLocalData(Iterable<APIType> localData) async {
  //   if (requireInitialized) {
  //     for (APIType api in localData) {
  //       await UtilDocument.exists(api.localName).then((String e) {
  //         if (e.isNotEmpty) {
  //           UtilDocument.delete(e);
  //         }
  //       });
  //     }
  //   }
  // }
}
