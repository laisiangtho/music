part of 'main.dart';

/// check
mixin _Mock on _Abstract {
  Future<dynamic> mockTest1() async {
    Stopwatch mockWatch = Stopwatch()..start();

    final a3 = UtilDocument.encodeJSON({'hello': 'hello!!'});
    collection.gist.updateFile(file: userFile, content: a3).then((e) {
      debugPrint('$e');
    }).catchError((e) async {
      if (e == 'Failed to load') {
        await collection.tokenUpdate().then((e) {
          debugPrint('done');
        }).catchError((e) {
          debugPrint('$e');
        });
      } else {
        debugPrint('$e');
      }
    });

    // await gist.gitFiles().then((res) {
    //   debugPrint('result $res');
    // }).catchError((e) {
    //   debugPrint('error $e');
    // });
    // await gist.updateFile('other.csv', 'id,\nfirst-,\nsecond-,').then((res) {
    //   debugPrint('result $res');
    // }).catchError((e) {
    //   debugPrint('error $e');
    // });
    // await gist.removeFile('others.csv').then((res) {
    //   debugPrint('result $res');
    // }).catchError((e) {
    //   debugPrint('error $e');
    // });

    debugPrint('mockTest in ${mockWatch.elapsedMilliseconds} ms');
  }

  Future<dynamic> mockTest2() async {
    // final gist = GistData(
    //   owner: 'collection.env.configure.owns',
    //   repo: 'collection.env.configure.name',
    // );
    // final gist = userGist;

    // final gitUri = await gist.gitContent<Uri>(
    //   // owner: 'me',
    //   // repo: 'lai',
    //   file: 'bfe/abc.json',
    //   debug: true,
    // );
    // uri request local, get nameLive getCache
    // final tmpLive = collection.env.repo.live(2147);
    // final tmpCache = collection.env.repo.local(2147);
    // final tmpLive = collection.env.repo.local(2147);
    // final tmpCache = collection.env.repo.local(2147);

    // final api = collection.env.api.firstWhere((e) => e.uid == 'bible');
    // final bibleUri = gist.rawContentUri(
    //   owner: collection.env.repo.owns,
    //   repo: collection.env.repo.name,
    //   file: api.repoName('fe'),
    // );
    // debugPrint(' repo: $bibleUri');

    // comLive, comCache

    // final trackLive = collection.env.track.liveName(2147);
    // final trackCache = collection.env.track.cacheName(2147);
    // debugPrint('-live: $trackLive \n-cache: $trackCache');

    // debugPrint(' ${gitUri.toString()}');
    // debugPrint(' ${rawUri.toString()}');
    // debugPrint(' ${liveUri.toString()}');
    // debugPrint(' ${gist.gitContentUri}');
    // debugPrint(' ${gist.rawContentUri}');

    // final urlParse = Uri.parse(url);
    // debugPrint(
    //     'parse $urlParse ${urlParse.authority} ${urlParse.path} ${urlParse.queryParametersAll}');
    // final urlParseHttp = Uri.https(urlParse.authority, urlParse.path, urlParse.queryParameters);
    // debugPrint(
    //     'http $urlParseHttp ${urlParseHttp.authority} ${urlParseHttp.path} ${urlParseHttp.queryParameters}');

    // final asdf = 'com+';
    // final adf = Uri.parse('api/audio/#?d1v=l1&ad=2');
    // debugPrint(' $adf ${adf.path} ${adf.queryParameters}');
    // final adf1 = collection.env.apis
    //     .firstWhere((e) => e.uid == 'track')
    //     .parseUriTest(collection.env.domain, 5);
    // debugPrint(' $adf1');

    // final fee = collection.env.apis.firstWhere((e) => e.uid == 'track');
    // final fee1 = collection.env.urlTest(fee.liveName(45));
    // debugPrint(' $fee1');
    // for (var api in collection.env.api) {
    //   debugPrint(' ${api.uid} \n -src ${api.src}');
    // }

    // final uriFirst = collection.env.url('word').uri('4354');
    // final uriSecond = collection.env.url('word').uri('4354', index: 1, scheme: 'http');
    // final cache = collection.env.url('word').cache('4354');
    // debugPrint('\n live $uriFirst \n cache $cache \n second $uriSecond');

    final uriFirst = collection.env.url('bible').uri('4354');
    final uriSecond = collection.env.url('bible').uri('4354', index: 1, scheme: 'http');
    final cache = collection.env.url('bible').cache('4354');
    debugPrint('\n live $uriFirst \n cache $cache \n second $uriSecond');

    // final bible = collection.env.url('bible');
    // final bibleLive = bible.uri('4354');
    // final bibleCache = bible.cache('4354');
    // debugPrint('---------\n bibleLive $bibleLive \n bibleCache $bibleCache');
    // debugPrint('assetName ${bible.assetName}');
    // debugPrint('localName ${bible.localName}');
    // debugPrint('repoName ${bible.repoName}');
  }

  String get userFile => authentication.id.isNotEmpty ? '${authentication.id}.json' : '';

  // Future<bool> initArchive() async{
  //   bool toChecks = false;
  //   for (var item in collection.env.listOfDatabase) {
  //     toChecks = await UtilDocument.exists(item.file).then(
  //       (e) => e.isEmpty
  //     ).catchError((_)=>true);
  //     if (toChecks){
  //       // stop checking at ${item.uid}
  //       debugPrint('stop checking at ${item.uid}');
  //       break;
  //     }
  //     // continuous checking on ${item.uid}
  //     debugPrint('continuous checking on ${item.uid}');
  //   }
  //   if (toChecks) {
  //     return await loadArchiveMock(collection.env.primary).then((e) => true).catchError((_)=>false);
  //   }
  //   // Nothing to unpack so everything is Ok!
  //   debugPrint('Nothing to unpack, everything seems fine!');
  //   return true;
  // }

  // // Archive: extract File
  // Future<List<String>> loadArchiveMock(APIType id) async{
  //   for (var item in id.src) {
  //     List<int>? bytes;
  //     bool _validURL = Uri.parse(item).isAbsolute;
  //     if (_validURL){
  //       bytes = await UtilClient(item).get<Uint8List?>().catchError((_) => null);
  //     } else {
  //       bytes = await UtilDocument.loadBundleAsByte(item).then(
  //         (value) => UtilDocument.byteToListInt(value).catchError((_) => null)
  //       ).catchError((e) => null);
  //     }
  //     if (bytes != null && bytes.isNotEmpty) {
  //       // load at $item
  //       debugPrint('load at $item');
  //       final res = await UtilArchive().extract(bytes).catchError((_) => null);
  //       if (res != null) {
  //         // loaded file $res
  //         debugPrint('loaded file $res');
  //         return res;
  //       }
  //     }
  //   }
  //   return Future.error("Failed to load");
  // }

  /// ```dart
  /// [query: String, raw: List<Map<String, Object?>>]
  /// ```
  /// typeof [SuggestionType]
  // Future<void> suggestionGenerate() async {
  //   Stopwatch suggestionWatch = Stopwatch()..start();
  //   int randomNumber = Random().nextInt(100);
  //   collection.cacheSuggestion = SuggestionType(
  //     query: collection.suggestQuery,
  //     // raw: await _sql.suggestion()
  //     raw: List.generate(randomNumber, (_) => {'word': 'random $randomNumber ${collection.suggestQuery}'}),
  //   );
  //   notify();
  //   debugPrint('suggestionGenerate in ${suggestionWatch.elapsedMilliseconds} ms');
  // }

  Future<void> suggestionGenerate() async {
    // this.suggestionList = await _sql.suggestion(collection.searchQuery);
    // if (collection.cacheSuggestion.query != collection.suggestQuery) {
    //   collection.cacheSuggestion = SuggestionType(
    //     query: collection.suggestQuery,
    //     raw: await _sql.suggestion(),
    //   );
    //   notify();
    // }
    // debugPrint('suggestionGenerate in ${suggestionWatch.elapsedMilliseconds} ms');
    // int randomNumber = Mock.randomNumber(100);
    // String randomString = Mock.randomString();
    // collection.cacheSuggestion = SuggestionType(
    //   query: collection.suggestQuery,
    //   raw: List.generate(randomNumber, (_) => {'word': '$randomString $suggestQuery'}),
    // );

    search.suggestion();

    notify();
  }

  /// ```dart
  /// [query: String, raw: List<Map<String, Object?>>]
  /// ```
  /// typeof [ConclusionType]
  Future<void> conclusionGenerate({bool init = false}) async {
    if (collection.cacheConclusion.query != collection.searchQuery) {
      search.conclusion();
      collection.recentSearchUpdate(collection.searchQuery);
      if (!init) {
        analytics.search(collection.searchQuery);
        notify();
      }
    }
  }
}
