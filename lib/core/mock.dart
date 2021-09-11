part of 'main.dart';

/// check
mixin _Mock on _Abstract {

  Future<dynamic> mockTest() async {
    Stopwatch mockWatch = new Stopwatch()..start();
    debugPrint('mockTest in ${mockWatch.elapsedMilliseconds} Milliseconds');
  }


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

  Future<void> suggestionGenerate() async {
    if (collection.cacheSuggestion.query != collection.searchQuery){
      collection.cacheSuggestion = SuggestionType(
        query: collection.searchQuery,
        // raw: await _sql.suggestion()
      );
      notify();
    }
  }

  // ignore: todo
  // TODO: definition on multi words
  // see
  Future<void> definitionGenerate() async {
    Stopwatch definitionWatch = new Stopwatch()..start();
    if (collection.cacheDefinition.query != collection.searchQuery){
      collection.cacheDefinition = DefinitionType(
        query: collection.searchQuery,
        // raw: await _definitionGenerator()
      );
      notify();
    }
    // collection.searchQueryUpdate(word);
    // collection.searchQuery = word;
    debugPrint('definitionTest in ${definitionWatch.elapsedMilliseconds} Milliseconds');
    analyticsSearch(collection.searchQuery);
  }

}
