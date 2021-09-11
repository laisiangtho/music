part of 'main.dart';

// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:music/model.dart';
/// Backwards compatible extensions on rxdart's ValueStream

/// Backwards compatible extensions on rxdart's ValueStream
// extension _ValueStreamExtension<T> on ValueStream<T> {
//   /// Backwards compatible version of valueOrNull.
//   T? get nvalue => hasValue ? value : null;
// }


class Audio {
  late AudioSession session;

  final Collection collection;
  final void Function<T>(T element, T value) notifyIf;
  final AudioPlayer player = AudioPlayer();
  final ConcatenatingAudioSource queue = ConcatenatingAudioSource(children: []);

  Audio({required this.notifyIf, required this.collection});

  AudioBucketType get cache => collection.cacheBucket;

  int _queueIndex = -1;
  bool _queueEditMode = false;
  bool get queueEditMode => _queueEditMode;
  set queueEditMode(bool value) => notifyIf<bool>(_queueEditMode, _queueEditMode = value);
  int get queueCount => player.sequence?.length??0;

  Future<void> init() async {
    session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // await player.setShuffleModeEnabled(true);
    await player.setLoopMode(LoopMode.all);
    await queueRefresh();

    player.playbackEventStream.listen(
      (e) {
        _queueIndex = e.currentIndex!;
      },
      onError: (Object e, StackTrace stackTrace) {
        debugPrint('A stream error occurred: $e');
      }
    );
    player.sequenceStream.listen((e) {
      notifyIf<int>(0,1);
    });

    // player.processingStateStream.listen((e) {
    //   print('player.processingStateStream ${e.index}');
    // });

    player.currentIndexStream.listen((e) {
      _queueIndex = e!;
      playerNotify(true);
    });

    player.playerStateStream.listen((evt) {
      // _queuePlaying = e.playing;
      // _queueState = e.processingState;
      playerNotify(evt.playing);
    });
  }

  void playerNotify(bool isPlaying){
    if (queue.length > 0) {
      cache.track.where((e) => e.playing == true).forEach((e) {
        e.playing = false;
      });
      // queue.sequence.where((e) => e.tag.trackInfo.playing == true).forEach((e) {
      //   e.tag.trackInfo.playing = false;
      //   // print('${e.tag.trackInfo.title} ${e.tag.trackInfo.playing}');
      // });
      AudioMetaType tag = queue.sequence.elementAt(_queueIndex).tag;
      // AudioMetaType tag = audioSource.tag;
      // print(tag.title);
      tag.trackInfo.playing = isPlaying;
      notifyIf<bool>(true, false);
      // IndexedAudioSource audioSource = queue.sequence.elementAt(_queueIndex);
      // if (audioSource.tag != null){
      // }
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<AudioPositionType> get streamPositionData => Rx.combineLatest3<Duration, Duration, Duration?, AudioPositionType>(
    player.positionStream,
    player.bufferedPositionStream,
    player.durationStream,
    (position, bufferedPosition, duration) => AudioPositionType(
      position, bufferedPosition, duration ?? Duration.zero
    )
  );
  // Stream<AudioPositionType> get _positionDataStream => Rx.combineLatest3<Duration, double, Duration?, AudioPositionType>(
  //     player.positionStream,
  //     cacheAudio.downloadProgressStream,
  //     player.durationStream,
  //     (position, downloadProgress, reportedDuration) {
  //   final duration = reportedDuration ?? Duration.zero;
  //   final bufferedPosition = duration * downloadProgress;
  //   return AudioPositionType(position, bufferedPosition, duration);
  // });

  // NOTE: Update Queue
  Future<void> queueRefresh({bool preload:false, bool force:false}) async{
    if (force || player.playerState.playing == false) {
      await player.setAudioSource(queue, preload: preload).catchError(
        (e){
          print('setAudioSource $e');
        }
      );
    }
  }

  // NOTE: remove
  Future<void> queueRemoveAtIndex(int index) async{
    AudioMetaType tag = queue.sequence.elementAt(index).tag;
    tag.trackInfo.queued = false;
    // AudioQueueType tag = queue.sequence.elementAt(index).tag;
    // // tag.trackId
    // final abc = cache.trackById(tag.trackId);
    // abc.queued = false;
    await queue.removeAt(index);
    await queueRefresh();
  }

  // NOTE: play
  Future<void> queuePlayAtIndex(int index) async{
    await player.seek(Duration.zero, index: index).then(
      (_) => player.play()
    );
  }

  // NOTE: seed Queue by trackId and play if already playing then pause
  // final a = player.sequence;
  // final b = queue.sequence;
  Future<void> queuePlayAtId(int id) async{
    int index = queue.sequence.indexWhere((e) => e.tag.trackInfo.id == id);
    if (index == _queueIndex){
      await playOrPause();
    } else {
      await queuePlayAtIndex(index);
    }
  }

  // NOTE: play
  Future<void> playOrPause() async{
    // player.seek(Duration.zero, index: player.effectiveIndices!.first).then()
    if (queue.length == 0) {
      await player.stop();
    } else if (player.playerState.playing != true) {
      await player.play();
    } else {
      await player.pause();
    }
  }

  // NOTE: pause
  // Future<void> pauses() async{
  //   await player.pause();
  // }

  // NOTE: NOTE: Queue insert from Ablum
  // NOTE: List<String> ids = ["526d19360995c41dcae9"];
  Future<void> queuefromAlbum(List<String> ids) async{
    await player.stop();
    await queue.clear();
    cache.track.where((e) => e.queued == true).forEach((e) {
      e.queued = false;
    });
    await queuefromTrack(cache.trackByUid(ids).map((e) => e.id).toList());
    await queueRefresh(force: true);
    await player.play();
  }

  // NOTE: Queue update or insert from Track
  // NOTE: List<int> ids = [8,20000];
  // await queuefromTrack([999]).then((_)  => queueRefresh());
  // int index = player.sequence!.indexWhere((e) => e.tag.trackInfo.id == track.id);
  Future<void> queuefromTrack(List<int> ids) async{
    for (AudioTrackType track in cache.trackByIds(ids)) {
      LockCachingAudioSource audioSource = await queueSourceCache(track.id);
      track.queued = true;
      int index = queue.sequence.indexWhere((e) => e.tag.trackInfo.id == track.id);
      // AudioSource audioSource = await queueSourceUri(track.id);
      if (index >= 0){
        await queue.removeAt(index);
        await queue.insert(index, audioSource);
      } else {
        await queue.add(audioSource);
      }
    }
    await queueRefresh();
  }

  // NOTE: track check offline
  Future<File> trackAvailable(int id) => UtilDocument.file(collection.env.bucketAPI.trackCache(id)).then((file) async {
    if (await file.exists()){
      return file;
    }
    throw 'Unavailable';
  }).catchError((e) {
    throw e;
  });

  // NOTE: track get URI
  // https://www.zaideih.com
  // asset:///assets/tmp/#.mp3
  // file:///data/user/0/?/?/#.mp3
  Future<Uri> trackUrlById(int id) => trackAvailable(id).then((file) {
    return file.uri;
  }).catchError((e) {
    return Uri.parse(collection.env.bucketAPI.trackLive(id));
  });

  // NOTE: get AudioSource for Queue
  // await queuefromTrack([999]).then((_)  => queueRefresh());
  Future<AudioMetaType> queueSourceCommon(int trackId) async{
    return cache.meta(
      trackId
    );
  }

  // NOTE: get AudioSource for uri
  Future<AudioSource> queueSourceUri(int trackId) => queueSourceCommon(trackId).then((tag) async{
    return AudioSource.uri(
      await trackUrlById(trackId),
      tag: tag
    );
  }).catchError((e){
    throw e;
  });

  // NOTE: get AudioSource for caching
  Future<LockCachingAudioSource> queueSourceCache(int trackId) => queueSourceCommon(trackId).then((tag) async{
    return LockCachingAudioSource(
      await trackUrlById(trackId),
      tag: tag,
      cacheFile: await UtilDocument.file(collection.env.bucketAPI.trackCache(trackId))
    );
  }).catchError((e){
    throw e;
  });

  // ids = [89,3384,7];
  // 7/7 * 1.0
  Future<void> trackDownload(List<int> ids) async{
    final items = cache.trackByIds(ids);
    int total = items.length;
    Map<int, double> progressMapping = {};
    double progress = 0.0;
    for (AudioTrackType track in items) {
      await queueSourceCommon(track.id).then((tag) async{
        final uri = await trackUrlById(track.id);
        final isAvailable = !uri.path.contains('audio');
        if (isAvailable == false){
          final req = LockCachingAudioSource(
            uri,
            tag: tag,
            cacheFile: await UtilDocument.file(collection.env.bucketAPI.trackCache(track.id))
          );
          req.clearCache();
          req.downloadProgressStream.listen((event) {
            progressMapping[track.id] = event.toDouble();
            progress = progressMapping.entries.map<double>((e) => e.value).reduce((a, b) => a + b);
            double percentage = (progress/total*1.0).toDouble();
            print('percentage: $percentage');
          });

          await req.request().catchError((e){
            print('request catchError $e');
          });
        } else {
          progressMapping[track.id] = 1.0;
        }
      }).catchError((e){
        throw e;
      });
    }
  }

  // 7/7 * 1.0
  // curentIndex/ids.lengtg*1.0
  Future<void> trackDelete(List<int> ids) async{
    final items = cache.trackByIds(ids);
    for (AudioTrackType track in items) {
      await trackAvailable(track.id).then((file) async{
        await file.delete().catchError((e) {
          throw e;
        });
      }).catchError((e) {
        // debugPrint('deleted $e');
        return;
      });
    }
  }

  // trackMetaById trackMetaByUd

  Iterable<AudioMetaType> trackMetaById(List<int> ids) {
    return cache.trackByIds(ids).map(
      (e) => cache.meta(e.id)
    );
  }

  Iterable<AudioMetaType> trackMetaByUd(List<String> ids) {
    return cache.trackByUid(ids).map(
      (e) => cache.meta(e.id)
    );
  }

  void albumMetaByArtist(List<String> ids) {}
  void albumMetaByTmp(List<String> ids) {}

  void artistMetaByArtist(List<String> ids) {}
  void artistMetaByTmp(List<String> ids) {}

  void testPopularTrack() {
    // cache.track.sort((AudioTrackType a, AudioTrackType b) => b.plays.compareTo(a.plays));
    // final List<Map<String, dynamic>> tmptrack = cache.track.map((e) => {
    //   'id':e.id,
    //   'uid':e.uid,
    //   'artist':e.artists,
    //   'plays':e.plays,
    // }).toList();
    // tmptrack.sort((a, b) => b['plays'].compareTo(a['plays']));
    // print(tmptrack.length);
    cache.track.getRange(0, 4).forEach((e) {
      print(e.toJSON());
    });
    // final abcdd = cache.duration(121);
    // print(abcdd);
  }

  void testPopularAlbum() {
    // final List<Map<String, dynamic>> tmpalbum = cache.album.map((e) => {
    //   'uid':e.uid,
    //   'plays':cache.trackByUid([e.uid]).fold<int>(0, (plays, a) => plays + a.plays)
    // }).toList();

    // tmpalbum.sort((a, b) => b['plays'].compareTo(a['plays']));
    // print(tmpalbum.length);
    cache.album.getRange(0, 4).forEach((e) {
      print(e.toJSON());
    });
    // final abcdd = cache.duration(121);
    // print(abcdd);
  }

  void testPopularArtist() {

    Stopwatch mockWatch = new Stopwatch()..start();

    cache.artist.getRange(0, 4).forEach((e) {
      print(e.toJSON());
    });
    debugPrint('mockTest ${cache.artist.length} in ${mockWatch.elapsedMilliseconds} Milliseconds');
  }

  void testLanguageBlock() {
    Stopwatch mockWatch = new Stopwatch()..start();
    cache.lang.forEach((e) {
      print(e.toJSON());
    });
    debugPrint('mockTest ${cache.lang.length} in ${mockWatch.elapsedMilliseconds} Milliseconds');
  }

  void testPopularArtistLang() {
    Stopwatch mockWatch = new Stopwatch()..start();

    // List abc =[];
    // final test = cache.lang.where(
    //   (e) => e.album > 0
    // ).map(
    //   (e) => {
    //     "lang":e,
    //     "artist":cache.track.where(
    //       (s) => s.lang == e.id
    //     ).map(
    //       (e) => e.artists
    //     ).expand((i) => i).toList().getRange(0, 4).map((eb) => cache.artistById(eb))
    //   }
    // );
    // final abdd = cache.track.where((s) => s.lang == 3).map((e) => e.artists).toSet().toList().getRange(0, 4).map((e) => cache.artistList(e));
    // final abdd = cache.track.where((s) => s.lang == 1).map((e) => e.artists).expand((i) => i).toList().getRange(0, 4).map((eb) => cache.artistById(eb));
    // final abdd = cache.track.where((s) => s.lang == 2).map((e) => e.artists).expand((i) => i).toSet().toList().getRange(0, 4).map(
    //   (eb) => cache.artistById(eb)
    // ).toList();
    // cache.artist.sort((a, b) => a.plays.compareTo(b.plays));
    // final abdd = cache.track.where((s) => s.lang == 2).map((e) => e.artists).expand((i) => i).toSet().toList().take(17).map(
    //   (eb) => cache.artistById(eb)
    // );
    // final abdd = cache.track.where((s) => s.lang == 2).map((e) => e.artists).expand((i) => i).toSet().map(
    //   (eb) => cache.artistById(eb)
    // ).toList()..sort((a, b) => b.plays.compareTo(a.plays));
    // print([1, 2, 3, 4, 5].reduce(max));
    // final abdd = cache.artist.map((e) => e.lang).expand((i) => i).toSet();
    // print(abdd);
    final abdd = cache.artist.where((e) => e.lang.length > 0 && e.lang.first == 4);
    // final abdd = cache.artist.where((s) => s.lang.elementAt(0) == 2);
    // // final abdd = cache.artist.where((s) => s.lang.reduce(min) == 4).take(4);
    // // final abdd = [].take(4);

    print(abdd.length);

    abdd.take(15).forEach((e) {
      print('${e.plays} ${e.name} ${e.lang}');
    });
    // cache.artist.getRange(2, 5).forEach((e) {
    //   print('${e.plays} ${e.name} ${e.lang}');
    // });
    // cache.artist.take(10).forEach((e) {
    //   print('${e.plays} ${e.name}');
    // });

    // test.forEach((e) {
    //   // final lg = e['lang'] as AudioLangType;
    //   // print(lg.toJSON());
    //   final ar = e['artist'] as List;
    //   // print(ar.map((e) => e.toJSON()));
    //   ar.forEach((e) {
    //     print(e);
    //   });
    //   // print(e['artist']);
    // });
    debugPrint('mockTest in ${mockWatch.elapsedMilliseconds} Milliseconds');
  }

  // NOTE:(??) track Download if unavailable
  // String fileName, List<int> bytes, bool? flush List<int> Uint8List
  // Future<void> trackDownloadById(int id) => trackAvailable(id).catchError((e) async{
  //   await UtilClient(collection.env.bucketAPI.trackLive(id)).get<Uint8List>().then((bytes) async{
  //     if (bytes.isNotEmpty) {
  //       await UtilDocument.writeAsByte(collection.env.bucketAPI.trackCache(id),bytes,false).catchError((e) {
  //         throw e;
  //       });
  //     }
  //   }).catchError((e) {
  //     throw e;
  //   });
  // });

  // NOTE:(??) track Delete if available
  // Future<void> trackDeleteById(int id) => trackAvailable(id).then((file) async{
  //   await file.delete().catchError((e) {
  //     throw e;
  //   });
  // }).catchError((e) {
  //   debugPrint('deleted');
  // });

  // NOTE:(??) tracks Download
  // Future<void> trackDownloadMulti(List<int> ids) async{
  //   for (var id in ids) {
  //     await trackAvailable(id).then((file){
  //       print(file.uri.toString());
  //     }).catchError((e) async{
  //     });
  //   }
  // }
}
