part of 'main.dart';

class Audio extends UnitAudio {
  final Collection cluster;

  Audio({
    required void Function() notify,
    required this.cluster,
  }) : super(notify: notify);

  AudioBucketType get cache => cluster.cacheBucket;
  Box<LibraryType> get boxOfLibrary => cluster.boxOfLibrary;
  // Box<RecentPlayType> get boxOfRecentPlay => cluster.boxOfRecentPlay;

  LibraryType get libraryQueue {
    return cluster.valueOfLibraryQueue;
  }

  final errorMessage = ValueNotifier<String>('');

  // @override
  // Future<void> init() async {
  //   super.init();
  // }

  @override
  void playerNotify({bool currentIndexChange = false}) {
    super.playerNotify();
    if (queue.length > 0) {
      AudioMetaType tag = queue.sequence.elementAt(player.currentIndex!).tag;
      tag.trackInfo.playing = player.playing;

      if (currentIndexChange) {
        final ob = cache.track.where((e) {
          return e.playing == true && e.id != tag.trackInfo.id;
        });
        for (final e in ob) {
          e.playing = false;
        }
        cluster.recentPlayUpdate(tag.trackInfo.id);
        // debugPrint('recentPlayUpdate ${tag.trackInfo.id}');
      }
    }
  }

  @override
  Future<void> queueRemoveAtIndex(int index) async {
    final tag = queue.sequence.elementAt(index).tag;
    tag.trackInfo.queued = false;
    libraryQueue.listRemove(tag.trackInfo.id);
    // libraryQueueRemove(tag.trackInfo.id);
    super.queueRemoveAtIndex(index);
  }

  // NOTE: seed Queue by trackId and play if already playing then pause
  // final a = player.sequence;
  // final b = queue.sequence;
  Future<void> queuePlayAtId(int id) async {
    int index = queue.sequence.indexWhere((e) => e.tag.trackInfo.id == id);
    if (index == player.currentIndex) {
      await playOrPause();
    } else {
      await queuePlayAtIndex(index);
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<AudioPositionType> get streamPositionData {
    return Rx.combineLatest3<Duration, Duration, Duration?, AudioPositionType>(
      player.positionStream,
      player.bufferedPositionStream,
      player.durationStream,
      (position, bufferedPosition, duration) => AudioPositionType(
        position,
        bufferedPosition,
        duration ?? Duration.zero,
      ),
    );
  }

  // NOTE: NOTE: Queue insert from Ablum
  // NOTE: List<String> ids = ["526d19360995c41dcae9"];
  Future<void> queuefromAlbum(List<String> ids) async {
    // await player.stop();
    // await queue.clear();
    // cache.track.where((e) => e.queued == true).forEach((e) {
    //   e.queued = false;
    // });
    // libraryQueueClear();
    // await queuefromTrack(cache.trackByUid(ids).map((e) => e.id).toList());
    await queuefromTrack(cache.trackByUid(ids).map((e) => e.id), group: true);
    // await queueRefresh(force: true);
    // await player.play();
  }

  // NOTE: play queue, if empty play random
  Future<void> queuefromRandom() async {
    Iterable<int> randomIds = libraryQueue.list;
    if (randomIds.isEmpty) {
      randomIds = cache.track.take(7).map((e) => e.id);
    }
    await queuefromTrack(randomIds, group: true);
  }

  // queueRandon queueAlbum queueArtist queueTrack
  // toQueueRandon toQueueAlbum toQueueArtist toQueueTrack
  // NOTE: Queue update or insert from Track
  // NOTE: List<int> ids = [8,20000];
  // group: album, playlist or any collection such as (artist tracks)
  // await queuefromTrack([999]).then((_)  => queueRefresh());
  // int index = player.sequence!.indexWhere((e) => e.tag.trackInfo.id == track.id);
  Future<void> queuefromTrack(Iterable<int> ids, {bool group = false}) async {
    bool force = queue.sequence.isEmpty;
    Iterable<int> toAdd = ids;
    final qid = queue.sequence.map<int>((e) => e.tag.trackInfo.id).toSet();
    if (force == false || group) {
      toAdd = ids.toSet().difference(qid).toList();
      if (group) {
        final toRemove = qid.toSet().difference(ids.toSet());
        for (var rid in toRemove) {
          // cache.track.where((e) => e.id == rid).forEach((e) {
          //   e.queued = false;
          //   e.playing = false;
          // });

          final index = queue.sequence.indexWhere((e) => e.tag.trackInfo.id == rid);
          if (index >= 0) {
            queue.sequence[index].tag.trackInfo.queued = false;
            queue.sequence[index].tag.trackInfo.playing = false;
            await queue.removeAt(index);
          }
          if (index == player.currentIndex) {
            // NOTE: set to stop from playing, idle
            await player.stop();
          }
        }
      }
    }

    libraryQueue.listUpdate(ids);

    // debugPrint('??? processingState ${player.processingState.name}');
    // debugPrint('??? playerState ${player.playerState.playing}');

    for (AudioTrackType track in cache.trackByIds(toAdd)) {
      libraryQueue.listAdd(track.id);

      LockCachingAudioSource audioSource = await queueSourceCache(track.id);
      // AudioSource audioSource = await queueSourceUri(track.id);

      track.queued = true;
      int index = queue.sequence.indexWhere((e) => e.tag.trackInfo.id == track.id);
      if (index >= 0) {
        await queue.removeAt(index);
        await queue.insert(index, audioSource);
      } else {
        await queue.add(audioSource);
      }
    }
    await queueRefresh(force: force).then((value) {
      if (player.playerState.playing == false) {
        player.play();
      }
    }).catchError((e) {
      player.stop();
      errorMessage.value = e;
      // debugPrint('??? errorAudioSource $e');
    });
  }

  // NOTE: track check offline
  Future<File> trackAvailable(int id) {
    return UtilDocument.file(cluster.trackCache(id)).then((file) async {
      if (await file.exists()) {
        return file;
      }
      throw Error();
      // throw 'Unavailable';
      // throw Future.error('Unavailable');
    }).catchError((e) {
      throw e;
    });
  }

  // NOTE: track get URI
  // https://www.zaideih.com
  // asset:///assets/tmp/#.mp3
  // file:///data/user/0/?/?/#.mp3
  Future<Uri> trackUrlById(int id) {
    return trackAvailable(id).then((file) {
      return file.uri;
    }).catchError((e) {
      return cluster.trackLive(id);
    });
  }

  // NOTE: get AudioSource for Queue
  // await queuefromTrack([999]).then((_)  => queueRefresh());
  Future<AudioMetaType> queueSourceCommon(int trackId) async {
    return cache.meta(trackId);
  }

  // NOTE: get AudioSource for uri
  Future<AudioSource> queueSourceUri(int trackId) {
    return queueSourceCommon(trackId).then((tag) async {
      return AudioSource.uri(await trackUrlById(trackId), tag: tag);
    }).catchError((e) {
      throw e;
    });
  }

  // NOTE: get AudioSource for caching
  Future<LockCachingAudioSource> queueSourceCache(int trackId) {
    return queueSourceCommon(trackId).then((tag) async {
      return LockCachingAudioSource(
        await trackUrlById(trackId),
        // cluster.trackLive(trackId),
        tag: tag,
        cacheFile: await UtilDocument.file(cluster.trackCache(trackId)),
      );
    }).catchError((e) {
      throw e;
    });
  }

  // ids = [89,3384,7];
  // 7/7 * 1.0
  Future<void> trackDownload(List<int> ids) async {
    final items = cache.trackByIds(ids);
    int total = items.length;
    Map<int, double> progressMapping = {};
    double progress = 0.0;
    for (AudioTrackType track in items) {
      await queueSourceCommon(track.id).then((tag) async {
        final uri = await trackUrlById(track.id);
        final isAvailable = !uri.path.contains('audio');
        if (isAvailable == false) {
          final req = LockCachingAudioSource(
            uri,
            tag: tag,
            cacheFile: await UtilDocument.file(cluster.trackCache(track.id)),
          );
          req.clearCache();
          req.downloadProgressStream.listen((event) {
            progressMapping[track.id] = event.toDouble();
            progress = progressMapping.entries.map<double>((e) => e.value).reduce((a, b) => a + b);
            double percentage = (progress / total * 1.0).toDouble();
            debugPrint('percentage: $percentage');
          });

          await req.request().catchError((e) {
            debugPrint('request catchError $e');
          });
        } else {
          progressMapping[track.id] = 1.0;
        }
      }).catchError((e) {
        throw e;
      });
    }
  }

  // 7/7 * 1.0
  // curentIndex/ids.lengtg*1.0
  Future<void> trackDelete(List<int> ids) async {
    final items = cache.trackByIds(ids);
    for (AudioTrackType track in items) {
      await trackAvailable(track.id).then((file) async {
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
    return cache.trackByIds(ids).map((e) => cache.meta(e.id));
  }

  Iterable<AudioMetaType> trackMetaByUd(List<String> ids) {
    return cache.trackByUid(ids).map((e) => cache.meta(e.id));
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
    // debugPrint(tmptrack.length);
    cache.track.getRange(0, 4).forEach((e) {
      debugPrint('${e.toJSON()}');
    });
    // final abcdd = cache.duration(121);
    // debugPrint(abcdd);
  }

  void testPopularAlbum() {
    // final List<Map<String, dynamic>> tmpalbum = cache.album.map((e) => {
    //   'uid':e.uid,
    //   'plays':cache.trackByUid([e.uid]).fold<int>(0, (plays, a) => plays + a.plays)
    // }).toList();

    // tmpalbum.sort((a, b) => b['plays'].compareTo(a['plays']));
    // debugPrint(tmpalbum.length);
    cache.album.getRange(0, 4).forEach((e) {
      debugPrint('${e.toJSON()}');
    });
    // final abcdd = cache.duration(121);
    // debugPrint(abcdd);
  }

  void testPopularArtist() {
    Stopwatch mockWatch = Stopwatch()..start();

    cache.artist.getRange(0, 4).forEach((e) {
      debugPrint('${e.toJSON()}');
    });
    debugPrint('mockTest ${cache.artist.length} in ${mockWatch.elapsedMilliseconds} Milliseconds');
  }

  void testLanguageBlock() {
    // Stopwatch mockWatch = Stopwatch()..start();
    // cache.lang.forEach((e) {
    //   debugPrint('${e.toJSON()}');
    // });
    // debugPrint('mockTest ${cache.lang.length} in ${mockWatch.elapsedMilliseconds} Milliseconds');
  }

  void testPopularArtistLang() {
    Stopwatch mockWatch = Stopwatch()..start();

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
    // debugPrint([1, 2, 3, 4, 5].reduce(max));
    // final abdd = cache.artist.map((e) => e.lang).expand((i) => i).toSet();
    // debugPrint(abdd);
    final abdd = cache.artist.where((e) => e.lang.isNotEmpty && e.lang.first == 4);
    // final abdd = cache.artist.where((s) => s.lang.elementAt(0) == 2);
    // // final abdd = cache.artist.where((s) => s.lang.reduce(min) == 4).take(4);
    // // final abdd = [].take(4);

    debugPrint('${abdd.length}');

    abdd.take(15).forEach((e) {
      debugPrint('${e.plays} ${e.name} ${e.lang}');
    });
    // cache.artist.getRange(2, 5).forEach((e) {
    //   debugPrint('${e.plays} ${e.name} ${e.lang}');
    // });
    // cache.artist.take(10).forEach((e) {
    //   debugPrint('${e.plays} ${e.name}');
    // });

    // test.forEach((e) {
    //   // final lg = e['lang'] as AudioLangType;
    //   // debugPrint(lg.toJSON());
    //   final ar = e['artist'] as List;
    //   // debugPrint(ar.map((e) => e.toJSON()));
    //   ar.forEach((e) {
    //     debugPrint(e);
    //   });
    //   // debugPrint(e['artist']);
    // });
    debugPrint('mockTest in ${mockWatch.elapsedMilliseconds} Milliseconds');
  }

  // NOTE:(??) track Download if unavailable
  // String fileName, List<int> bytes, bool? flush List<int> Uint8List
  // Future<void> trackDownloadById(int id) => trackAvailable(id).catchError((e) async{
  //   await UtilClient(collection.trackLive(id)).get<Uint8List>().then((bytes) async{
  //     if (bytes.isNotEmpty) {
  //       await UtilDocument.writeAsByte(collection.trackCache(id),bytes,false).catchError((e) {
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
  //       debugPrint(file.uri.toString());
  //     }).catchError((e) async{
  //     });
  //   }
  // }
}
