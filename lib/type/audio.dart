part of 'main.dart';

class AudioBucketType {
  final List<AudioAlbumType> album;
  final List<AudioTrackType> track;
  final AudioCategoryType category;
  List<AudioArtistType> artist;

  AudioBucketType({
    required this.album,
    required this.track,
    required this.category,
    required this.artist,
  });

  factory AudioBucketType.fromJSON(Map<String, dynamic> o) {
    debugPrint('AudioBucketType');
    return AudioBucketType(
      album: o["album"].map<AudioAlbumType>((e) => AudioAlbumType.fromJSON(e)).toList(),
      // track: (o["album"] as List).map(
      //   (e) => (e["tk"] as List).map<AudioTrackType>((i) => AudioTrackType.fromJSON(i,uid: e["ui"])).toList()
      // ).expand((i) => i).toList(),
      track: (o["album"] as List)
          .map(
            (alb) => (alb["tk"] as List)
                .map<AudioTrackType>(
                  (i) => AudioTrackType.fromJSON(i, alb: alb),
                )
                .toList(),
          )
          .expand((i) => i)
          .toList(),
      category: AudioCategoryType.fromJSON(o["category"]),
      // artist: o["artist"].map<AudioArtistType>((e) => AudioArtistType.fromJSON(e)).toList(),
      // artist: o["artist"]
      //     .asMap()
      //     .mapIndexed<AudioArtistType>((i, e) => AudioArtistType.fromJSON(i, e))
      //     .toList(),
      // artist: List.generate(adsfasdf.length, (i) => AudioArtistType.fromJSON(i, adsfasdf[i])),
      artist: o["artist"]
          .asMap()
          .entries
          .map<AudioArtistType>((e) => AudioArtistType.fromJSON(e.key, e.value))
          .toList(),
      // genre: o["genre"].map<AudioCategoryGenre>((e) => AudioCategoryGenre.fromJSON(e)).toList(),
      // lang: o["lang"].map<AudioCategoryLang>((e) => AudioCategoryLang.fromJSON(e)).toList(),
    );
  }

  // Map<String, dynamic> toJSON() {
  //   return {
  //     "album":album.map((e)=>e.toJSON()).toList(),
  //     "track":track.map((e)=>e.toJSON()).toList(),
  //     "artist":artist.map((e)=>e.toJSON()).toList(),
  //     "genre":genre.map((e)=>e.toJSON()).toList(),
  //     "lang":lang.map((e)=>e.toJSON()).toList()
  //   };
  // }

  Future<void> artistInit() async {
    // for (var index = 0; index < artist.length; index++) {
    //   artistRefresh(artist[index]);
    // }
    artist.sort((a, b) => b.plays.compareTo(a.plays));
    // artist.sort((a, b) => a.name.compareTo(b.name));
  }

  // artistQuery
  AudioArtistType artistRefresh(AudioArtistType q) {
    if (q.track < 1) {
      // .indexOf(q.id) >= 0)
      // .contains(q.id)
      List<AudioTrackType> trk = track.where((e) => e.artists.contains(q.id)).toList();
      Map<String, int> sum = trk.fold<Map<String, int>>(
        {'plays': 0, 'duration': 0, 'track': 0},
        (i, e) => {
          // "plays": (i['plays'] as int) + e.plays,
          // "duration": (i['duration'] as int) + e.duration,
          // "track": (i['track'] as int) + 1,
          // "album":(i['album'] as int)+ trk.map((e) => e.uid).toSet().length,
          "plays": i['plays']! + e.plays,
          "duration": i['duration']! + e.duration,
          "track": i['track']! + 1,
        },
      );

      // final abc = itemsByFrequency(trk.map((e) => e.lang.toString()).toList()).map((e) => int.parse(e));
      q.updateWith(
        // id: index,
        // duration: trk.fold<int>(0, (value, e) => value + e.duration),
        // plays: trk.fold<int>(0, (value, e) => value + e.plays),

        duration: sum['duration'],
        plays: sum['plays'],
        track: sum['track'],
        album: trk.map((e) => e.uid).toSet().length,
        lang: trk.map((e) => e.lang).toSet().toList(),
      );
    }
    // print(' artist.id: ${q.id} ${q.duration}');
    return q;
  }

  Future<void> trackInit() async {
    return track.sort((a, b) => b.plays.compareTo(a.plays));
  }

  Future<void> albumInit() async {
    return album.sort((a, b) => b.plays.compareTo(a.plays));
  }

  Future<void> langInit() async {
    for (var lg in category.lang) {
      List<AudioAlbumType> alb = album.where((e) => e.lang == lg.id).toList();
      lg.updateWith(
        album: alb.length,
        plays: alb.fold<int>(0, (value, e) => value + e.plays),
        duration: alb.fold<int>(0, (value, e) => value + e.duration),
        track: alb.fold<int>(0, (value, e) => value + e.track),
      );
    }
    // return kind.lang.sort((a, b) => b.plays.compareTo(a.plays));
  }

  AudioAlbumType albumById(String id) {
    return album.firstWhere((e) => e.uid == id);
  }
  // Iterable<AudioAlbumType> albumByArtist(String id) => album.where((e) => e.uid == id);

  // Iterable<AudioAlbumType> albumPopular() => album.take(17);

  AudioTrackType trackById(int id) {
    return track.firstWhere((e) => e.id == id);
  }

  Iterable<AudioTrackType> trackByUid(Iterable<String> ids) {
    return track.where((e) => ids.contains(e.uid));
  }

  Iterable<AudioTrackType> trackByIds(Iterable<int> ids) {
    return track.where((e) => ids.contains(e.id));
  }

  // artist.elementAt(index);
  AudioArtistType artistById(int index) {
    return artist.firstWhere((e) => e.id == index);
  }

  Iterable<AudioArtistType> artistList(List<int> indexes) {
    return indexes.toSet().map((index) => artistById(index)).toSet();
  }

  // Iterable<AudioArtistType> artistPopularByLang(int id) => track.where(
  //   (s) => s.lang == id
  // ).map((e) => e.artists).expand((i) => i).toSet().take(15).map(
  //   (e) => artistById(e)
  // );

  // Iterable<AudioArtistType> artistPopularByLang(int id) => artist.where((e) => e.lang.length > 0 && e.lang.first == id).take(17);
  Iterable<int> artistPopularByLang(int id) {
    return artist
        .where(
          (e) => e.lang.isNotEmpty && e.lang.first == id,
        )
        .take(17)
        .map(
          (e) => e.id,
        );
  }

  AudioCategoryGenre genreByIndex(int index) => category.genre.elementAt(index);

  Iterable<AudioCategoryGenre> genreList(List<int> indexes) {
    return indexes.map((index) => genreByIndex(index)).toSet();
  }

  // lang.elementAt(index);
  AudioCategoryLang langById(int id) => category.lang.firstWhere((e) => e.id == id);
  AudioCategoryCommon genderById(int id) => category.artist.firstWhere((e) => e.id == id);

  Iterable<AudioCategoryLang> langList(List<int> indexes) =>
      indexes.map((index) => langById(index)).toSet();

  Iterable<AudioCategoryLang> langAvailable() => category.lang.where((e) => e.album > 0);

  AudioMetaType meta(int trackId) {
    AudioTrackType track = trackById(trackId);
    return AudioMetaType(
      trackInfo: track,
      albumInfo: albumById(track.uid),
      artistInfo: artistList(track.artists),
    );
  }

  // 1:05:00, 5:00
  String duration(int seconds) {
    final duration = Duration(seconds: seconds);
    final result = [];
    if (duration.inHours > 0) {
      result.add(duration.inHours);
    }
    if (duration.inMinutes > 0) {
      if (duration.inHours > 0) {
        result.add(duration.inMinutes.remainder(60).toString().padLeft(2, '0'));
      } else {
        result.add(duration.inMinutes.remainder(60));
      }
    }
    if (duration.inSeconds > 0) {
      result.add(duration.inSeconds.remainder(60).toString().padLeft(2, '0'));
    }

    return result.join(':');
  }

  // List<String> itemsByFrequency(List<String> input) => [
  //     ...(input
  //             .fold<Map<String, int>>(
  //                 <String, int>{},
  //                 (map, letter) => map
  //                   ..update(letter, (value) => value + 1, ifAbsent: () => 1))
  //             .entries
  //             .toList()
  //               ..sort((e1, e2) => e2.value.compareTo(e1.value)))
  //         .map((e) => e.key)
  //   ];
}

// NOTE: only type, AudioBucketType child {ui:'?', ab:'?', gr:[], yr:[], lg:0, tk:[]},
class AudioAlbumType {
  final String uid;
  final String name;
  final List<int> genre;
  // NOTE: todo? Could not parse year list to int
  final List<String> year;
  final int lang;
  // final List<AudioTrackType> track;
  final int track;
  final int duration;
  final int plays;

  AudioAlbumType({
    required this.uid,
    required this.name,
    required this.genre,
    required this.year,
    required this.lang,
    required this.track,
    required this.duration,
    required this.plays,
  });

  factory AudioAlbumType.fromJSON(Map<String, dynamic> o) {
    final trk = o["tk"] as List;
    return AudioAlbumType(
      uid: o["ui"],
      name: o["ab"],
      genre: ((o["gr"] ?? []) as List<dynamic>).map((e) => (e ?? 0) as int).toList(),
      year: ((o["yr"] ?? []) as List<dynamic>)
          .map((e) => e.toString().replaceAll('null', ''))
          .toSet()
          .toList(),
      lang: (o["lg"] ?? 0) as int,
      // track: trk.map<AudioTrackType>((e) => AudioTrackType.fromJSON(e)).toList()

      track: trk.length,
      duration: trk.fold(0, (previousValue, e) => previousValue + (e["d"] ?? 0) as int),
      plays: trk.fold(0, (previousValue, e) => previousValue + (e["p"] ?? 0) as int),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "uid": uid,
      "name": name,
      "genre": genre,
      "year": year,
      "lang": lang,
      // "track":track.map((e)=>e.toJSON()).toList()

      "track": track,
      "duration": duration,
      "plays": plays,
    };
  }
}

// NOTE: only type, AudioBucketType child {i:'?', t:'?', a:[], d: 0, p: 1}
class AudioTrackType {
  final int id;
  // final dynamic alb;
  final String uid;
  final String title;
  final List<int> artists;
  final int duration;
  final int plays;
  final int lang;

  bool queued;
  bool playing;
  bool loading;
  bool available;

  AudioTrackType({
    required this.id,
    required this.uid,
    required this.title,
    required this.artists,
    required this.duration,
    required this.plays,
    required this.lang,
    this.queued = false,
    this.playing = false,
    this.loading = false,
    this.available = false,
  });

  factory AudioTrackType.fromJSON(Map<String, dynamic> o, {required dynamic alb}) {
    return AudioTrackType(
      id: o["i"] as int,
      // uid: uid,
      uid: alb["ui"] as String,
      title: o["t"],
      artists: ((o['a'] ?? []) as List<dynamic>).map((e) => (e ?? 0) as int).toSet().toList(),
      duration: (o["d"] ?? 0) as int,
      plays: (o["p"] ?? 0) as int,
      lang: (alb["lg"] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "uid": uid,
      "title": title,
      "artists": artists.toList(),
      "duration": duration,
      "plays": plays,
      "lang": lang,
    };
  }

  // NOTE: is queued
  // bool get queued => isQueued;
  // set queued(bool value) => notifyIf<bool>(isQueued, isQueued = value);

  // // NOTE: is playing
  // bool get playing => isPlaying;
  // set playing(bool value) => notifyIf<bool>(isPlaying, isPlaying = value);

  // // NOTE(?): is loading, downloading, buffer
  // bool get loading => isLoading;
  // set loading(bool value) => notifyIf<bool>(isLoading, isLoading = value);

  // // NOTE(?): is available for offline
  // bool get available => isAvailable;
  // set available(bool value) => notifyIf<bool>(isAvailable, isAvailable = value);
}

// NOTE: only type, AudioBucketType child {"name":"Cing Khai","correction":[],"thesaurus":[],"aka":?}
class AudioArtistType {
  final String name;
  final List<String> correction;
  final List<String> thesaurus;
  final String aka;
  final int type;

  int id;
  int track;
  int album;
  int duration;
  int plays;
  List<int> lang;

  AudioArtistType({
    required this.name,
    required this.correction,
    required this.thesaurus,
    required this.aka,
    required this.type,
    this.id = 0,
    this.track = 0,
    this.album = 0,
    this.duration = 0,
    this.plays = 0,
    this.lang = const [],
  });

  factory AudioArtistType.fromJSON(int index, Map<String, dynamic> o) {
    // print('artist index $index ${o["name"]}');

    return AudioArtistType(
      id: index,
      name: o["name"],
      correction: o["correction"].map<String>((e) => e.toString()).toList(),
      thesaurus: o["thesaurus"].map<String>((e) => e.toString()).toList(),
      // correction: List.from((o['correction']??[]).map<String>((e) => e.toString())),
      // thesaurus: List.from((o['thesaurus']??[]).map<String>((e) => e.toString())),
      aka: o["aka"] ?? "",
      type: o["type"] as int,

      track: o["t"] as int,
      album: o["a"] as int,
      duration: o["d"] as int,
      plays: o["p"] as int,
      lang: ((o["l"] ?? []) as List<dynamic>).map((e) => (e ?? 0) as int).toList(),
    );
  }

  void updateWith({
    int? id,
    int? duration,
    int? plays,
    int? track,
    int? album,
    List<int>? lang,
  }) {
    this.duration = duration ?? this.duration;
    this.plays = plays ?? this.plays;
    this.track = track ?? this.track;
    this.album = album ?? this.album;
    this.id = id ?? this.id;
    this.lang = lang ?? this.lang;
  }

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "correction": correction.toList(),
      "thesaurus": thesaurus.toList(),
      "aka": aka,
      "duration": duration,
      "plays": plays,
      "track": track,
      "album": album,
      "lang": lang,
      "id": id,
    };
  }
}

// NOTE: only type, AudioBucketType child
class AudioCategoryLang {
  final int id;
  final String name;
  int album;
  int track;
  int plays;
  int duration;

  AudioCategoryLang({
    required this.id,
    required this.name,
    this.album = 0,
    this.track = 0,
    this.plays = 0,
    this.duration = 0,
  });

  factory AudioCategoryLang.fromJSON(Map<String, dynamic> o) {
    return AudioCategoryLang(id: o["id"] as int, name: o["name"] as String);
  }

  void updateWith({
    int? album,
    int? track,
    int? plays,
    int? duration,
  }) {
    this.album = album ?? this.album;
    this.track = track ?? this.track;
    this.plays = plays ?? this.plays;
    this.duration = duration ?? this.duration;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "name": name,
      "album": album,
      "track": track,
      "plays": plays,
      "duration": duration
    };
  }
}

// NOTE: only type, AudioBucketType child
class AudioMetaType {
  final AudioTrackType trackInfo;
  final AudioAlbumType albumInfo;
  final Iterable<AudioArtistType> artistInfo;
  final String? cover;

  AudioMetaType({
    required this.trackInfo,
    required this.albumInfo,
    required this.artistInfo,
    this.cover,
  });

  String get title => trackInfo.title;
  String get album => albumInfo.name;
  String get artist => artistInfo.map((e) => e.name).join(', ');
  String get artwork =>
      cover ?? "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg";
}

// NOTE: only type, AudioBucketType child
class AudioCategoryType {
  final List<AudioCategoryLang> lang;
  final List<AudioCategoryCommon> artist;
  final List<AudioCategoryCommon> album;
  final List<AudioCategoryGenre> genre;

  AudioCategoryType({
    required this.lang,
    required this.artist,
    required this.album,
    required this.genre,
  });

  factory AudioCategoryType.fromJSON(Map<String, dynamic> o) {
    // ..entries.map((e) => '${e.key} - ${e.value}');
    // AudioCategoryCommon
    // AudioCategoryGenre
    // AudioCategoryLang
    return AudioCategoryType(
      lang: o["lang"].map<AudioCategoryLang>((e) => AudioCategoryLang.fromJSON(e)).toList(),
      artist: o["artist"].map<AudioCategoryCommon>((e) => AudioCategoryCommon.fromJSON(e)).toList(),
      album: o["album"].map<AudioCategoryCommon>((e) => AudioCategoryCommon.fromJSON(e)).toList(),
      genre: o["genre"].map<AudioCategoryGenre>((e) => AudioCategoryGenre.fromJSON(e)).toList(),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": 0,
    };
  }
}

// NOTE: only type, AudioCategoryType child
class AudioCategoryCommon {
  final int id;
  final String name;

  AudioCategoryCommon({
    required this.id,
    required this.name,
  });

  factory AudioCategoryCommon.fromJSON(Map<String, dynamic> o) {
    return AudioCategoryCommon(id: o["id"] as int, name: o["name"] as String);
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "name": name,
    };
  }
}

// NOTE: only type, AudioBucketType child
class AudioCategoryGenre {
  final String name;
  final List<String> correction;
  final List<String> thesaurus;

  AudioCategoryGenre({required this.name, required this.correction, required this.thesaurus});

  factory AudioCategoryGenre.fromJSON(Map<String, dynamic> o) {
    return AudioCategoryGenre(
      name: o["name"],
      // correction: o["correction"].map<int>((e) => e as String).toList(),
      // thesaurus: o["thesaurus"].map<int>((e) => e as String).toList()
      correction: List.from((o['correction'] ?? []).map<String>((e) => e.toString())),
      thesaurus: List.from((o['thesaurus'] ?? []).map<String>((e) => e.toString())),
    );
  }

  Map<String, dynamic> toJSON() {
    return {"name": name, "correction": correction.toList(), "thesaurus": thesaurus.toList()};
  }
}

// class AudioCategoryFilter {
//   List<String> artistCharList = [];
//   List<int> artistLangList = [];

//   List<String> albumCharList = [];
//   List<int> albumLangList = [];
//   List<int> albumGenreList = [];
//   // List<String> artistFilterCharList = [];
//   // List<int> artistFilterLangList = [];
//   // List<String> albumFilterCharList = [];
//   // List<int> albumFilterLangList = [];
//   // List<int> albumFilterGenreList = [];
// }

class AudioPositionType {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  AudioPositionType(this.position, this.bufferedPosition, this.duration);
}
