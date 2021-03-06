part of data.core;

class Search {
  final Collection collection;
  final Preference preference;

  Search({required this.collection, required this.preference});

  // late AudioBucketType cache = collection.cacheBucket;
  // late String suggestQuery = collection.suggestQuery;

  AudioBucketType get cache => collection.cacheBucket;
  String get suggestQuery => collection.suggestQuery.asString;
  SuggestionType<OfRawType> get cacheSuggestion => collection.cacheSuggestion;
  set cacheSuggestion(SuggestionType<OfRawType> o) {
    collection.cacheSuggestion = o;
  }

  String get searchQuery => collection.searchQuery.asString;
  ConclusionType<OfRawType> get cacheConclusion => collection.cacheConclusion;
  set cacheConclusion(ConclusionType<OfRawType> o) {
    collection.cacheConclusion = o;
  }

  void tmpOrg() {
    // collection.cacheConclusion
    // suggestQuery = 'abc';
    // collection.cacheSuggestion = SuggestionType(
    //   query: collection.suggestQuery,
    //   raw: List.generate(12, (_) => {'word': '?? $suggestQuery'}),
    // );
  }

  void suggestion() {
    cacheSuggestion = SuggestionType(
      query: suggestQuery,
      raw: [],
    );

    // final eachWord = RegExp("\\b" + suggestQuery + "\\b", caseSensitive: false);
    final eachChar = RegExp(suggestQuery, caseSensitive: false);

    final matchTrack = cache.track.where(
      // (e)=> e.title.contains( RegExp(r'$suggestQuery', caseSensitive: false))
      // (e) => e.title.contains(eachChar),
      (e) => suggestQuery.length == 1 ? e.title.startsWith(eachChar) : e.title.contains(eachChar),
    );

    final matchArtist = cache.artist.where(
      (e) =>
          e.name.contains(eachChar) ||
          e.thesaurus
              .where(
                (i) => i.contains(eachChar),
              )
              .isNotEmpty,
    );

    final matchAlbum = cache.album.where(
      (e) => e.name.contains(eachChar),
    );

    if (matchTrack.isNotEmpty) {
      int limitTrack = 7;
      if (matchArtist.isEmpty) {
        limitTrack = 12;
      }
      if (matchAlbum.isEmpty) {
        limitTrack = 15;
      }
      if (matchArtist.isEmpty && matchAlbum.isEmpty) {
        limitTrack = 20;
      }
      cacheSuggestion.raw.add(OfRawType(
        term: preference.text.track(matchTrack.length > 1),
        count: matchTrack.length,
        type: 0,
        kid: matchTrack.map((e) => e.id).toList(),
        // uid: matchTrack.map((e) => e.title).toList(),
        limit: limitTrack,
      ));
    }

    if (matchArtist.isNotEmpty) {
      cacheSuggestion.raw.add(OfRawType(
        term: preference.text.artist(matchArtist.length > 1),
        count: matchArtist.length,
        type: 1,
        kid: matchArtist.map((e) => e.id).toList(),
        // uid: matchArtist.map((e) => e.name).toList(),
        limit: 6,
      ));
    }

    if (matchAlbum.isNotEmpty) {
      cacheSuggestion.raw.add(OfRawType(
        term: preference.text.album(matchAlbum.length > 1),
        count: matchAlbum.length,
        type: 2,
        // uid: matchAlbum.map((e) => e.uid).toList(),
        uid: matchAlbum.map((e) => e.uid).take(50).toList(),
        limit: 4,
      ));
    }
  }

  void conclusion() {
    cacheConclusion = ConclusionType(
      query: searchQuery,
      raw: [],
    );

    // final eachWord = RegExp("\\b" + suggestQuery + "\\b", caseSensitive: false);
    final eachChar = RegExp(searchQuery, caseSensitive: false);

    final matchTrack = cache.track.where(
      // (e)=> e.title.contains( RegExp(r'$suggestQuery', caseSensitive: false))
      // (e) => e.title.contains(eachChar),
      (e) => searchQuery.length == 1 ? e.title.startsWith(eachChar) : e.title.contains(eachChar),
    );

    final matchArtist = cache.artist.where(
      (e) =>
          e.name.contains(eachChar) ||
          e.thesaurus
              .where(
                (i) => i.contains(eachChar),
              )
              .isNotEmpty,
    );

    final matchAlbum = cache.album.where(
      (e) => e.name.contains(eachChar),
    );

    if (matchTrack.isNotEmpty) {
      int limitTrack = 7;
      if (matchArtist.isEmpty) {
        limitTrack = 12;
      }
      if (matchAlbum.isEmpty) {
        limitTrack = 15;
      }
      if (matchArtist.isEmpty && matchAlbum.isEmpty) {
        limitTrack = 20;
      }
      cacheConclusion.raw.add(OfRawType(
        term: preference.text.track(matchTrack.length > 1),
        count: matchTrack.length,
        type: 0,
        // uid: matchTrack.map((e) => e.title).take(limit).toList(),
        kid: matchTrack.map((e) => e.id).toList(),
        limit: limitTrack,
      ));
    }

    if (matchArtist.isNotEmpty) {
      cacheConclusion.raw.add(OfRawType(
        term: preference.text.artist(matchArtist.length > 1),
        count: matchArtist.length,
        type: 1,
        kid: matchArtist.map((e) => e.id).toList(),
        limit: 6,
      ));
    }

    if (matchAlbum.isNotEmpty) {
      cacheConclusion.raw.add(OfRawType(
        term: preference.text.album(matchAlbum.length > 1),
        count: matchAlbum.length,
        type: 2,
        uid: matchAlbum.map((e) => e.uid).take(4).toList(),
        limit: 4,
      ));
    }
  }
}
