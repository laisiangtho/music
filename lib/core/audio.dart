part of data.core;

class Audio extends UnitAudio {
  final Collection cluster;

  // ignore: close_sinks
  final BehaviorSubject<List<AudioCacheType>> _cacheProgress = BehaviorSubject.seeded([]);

  Audio({
    required this.cluster,
  });

  AudioBucketType get _bucket => cluster.cacheBucket;

  @override
  Future<void> prepareInitialized() async {
    await super.prepareInitialized();

    // Listen to Index change
    Rx.combineLatest2<List<MediaItem>, PlaybackState, String?>(
      queue,
      playbackState,
      (q, state) {
        final index = state.queueIndex;
        return (index != null && index < q.length) ? q[index].id : null;
      },
    ).whereType<String?>().distinct().listen((trackId) {
      if (trackId != null) {
        cluster.recentPlayUpdate(int.parse(trackId));
        // queue.value.firstWhere((e) => e.id == trackId);
      }
    });
  }

  Future<Audio> init() {
    return AudioService.init(
      builder: () => this,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.zaideih.app.audiochannel',
        androidNotificationChannelName: 'Zaideih',
        androidNotificationOngoing: true,
      ),
    );
  }

  /// and update boxOfLibrary.queue
  @override
  Future<AudioSource> generateAudioSourceItem(MediaItem item) async {
    final id = int.parse(item.id);
    _library.listAdd(id);
    final src = await _getAudioUriLive(id);
    expandoMediaItem[src] = item;
    return src;
  }

  Stream<AudioMediaStateType> trackState(int trackId) {
    return Rx.combineLatest4<List<MediaItem>, PlaybackState, List<AudioCacheType>, double,
        AudioMediaStateType>(
      queue,
      playbackState,
      _cacheProgress,
      Stream.fromFuture(_cachedExist(trackId)),
      (queue, state, _progress, cached) {
        final sid = trackId.toString();
        final index = state.queueIndex;
        final queued = queue.indexWhere((e) => e.id == sid) >= 0;
        final id = (index != null && index < queue.length) ? queue[index].id : null;
        final playing = (id != null && id == sid) ? state.playing : false;

        final cache = _progress.firstWhere((e) {
          return e.id == trackId;
        }, orElse: () {
          return AudioCacheType(id: trackId, caching: cached);
        });

        return AudioMediaStateType(
          id: trackId,
          index: index,
          queued: queued,
          playing: playing,
          cache: cache,
          // cached: cached,
        );
      },
    );
  }

  // Generate MediaItem using trackId
  MediaItem generateMediaItem(int trackId) {
    final tag = meta(trackId);
    return MediaItem(
      id: tag.trackInfo.id.toString(),
      title: tag.title,
      artist: tag.artist,
      album: tag.album,
      duration: Duration(seconds: tag.trackInfo.duration),
      artUri: Uri.parse(tag.artwork),
      playable: true,
    );
  }

  /// NOTE: get AudioSource for uri using _uriById
  Future<AudioSource> _getAudioUriLive(int trackId) async {
    return AudioSource.uri(await _uriById(trackId));
  }

  /// NOTE: get AudioSource for caching
  Future<LockCachingAudioSource> _getAudioUriCache(int trackId) async {
    return LockCachingAudioSource(
      await _uriById(trackId),
      // cluster.trackLive(trackId),
      cacheFile: await UtilDocument.file(cluster.trackCache(trackId)),
    );
  }

  /// NOTE: track get Uri
  // api/audio/?
  // asset:///assets/tmp/#.mp3
  // file:///data/user/0/?/?/#.mp3
  Future<Uri> _uriById(int id) {
    return _isOfflineAvailable(id).then((file) {
      return file.uri;
    }).catchError((e) {
      return cluster.trackLive(id);
    });
  }

  // NOTE: track check offline
  // isOfflineAvailable
  Future<File> _isOfflineAvailable(int id) {
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

  Stream<AudioMetaType?> get streamMeta {
    return Rx.combineLatest2<List<MediaItem>, PlaybackState, AudioMetaType?>(
      queue,
      playbackState,
      (queue, state) {
        final index = state.queueIndex;
        final id = (index != null && index < queue.length) ? queue[index].id : null;
        // final playing = (id != null) ? state.playing : false;
        if (id == null) return null;
        return meta(int.parse(id));
      },
    );
  }

  AudioMetaType? get currentMeta {
    final index = playbackState.value.queueIndex;
    final q = queue.value;
    final id = (index != null && index < q.length) ? q[index].id : null;
    if (id == null) return null;
    return meta(int.parse(id));
  }

  AudioMetaType meta(int id) {
    return _bucket.meta(id);
  }

  List<AudioMetaType> metaById(List<int> ids) {
    return _bucket.trackByIds(ids).map((e) => meta(e.id)).toList();
  }

  Iterable<AudioMetaType> metaByUd(List<String> ids) {
    return _bucket.trackByUid(ids).map((e) => meta(e.id));
  }

  LibraryType get _library => cluster.valueOfLibraryQueue;

  Future<void> queuefromAlbum(List<String> ids) async {
    await queuefromTrack(_bucket.trackByUid(ids).map((e) => e.id), group: true);
  }

  Future<void> queuefromRandom() async {
    Iterable<int> randomIds = _library.list;
    if (randomIds.isEmpty) {
      randomIds = _bucket.track.take(7).map((e) => e.id);
    }
    await queuefromTrack(randomIds, group: true);
  }

  Future<void> queuefromTrack(Iterable<int> ids, {bool group = false}) async {
    final queueValue = queue.value;
    bool force = queueValue.isEmpty;
    Iterable<int> toAdd = ids;
    final qid = queueValue.map<int>((e) => int.parse(e.id)).toSet();

    if (group) {
      final removeFromLibrary = _library.list.toSet().difference(ids.toSet()).toList();
      _library.listRemove(removeFromLibrary);
    }
    if (force == false || group) {
      toAdd = ids.toSet().difference(qid);

      final removeFromQueue = qid.toSet().difference(ids.toSet()).toList();
      if (group) {
        for (var rid in removeFromQueue) {
          final id = rid.toString();
          final index = queueValue.indexWhere((e) => e.id == id);
          if (index == playbackState.value.queueIndex) {
            await stop();
          }
          if (index >= 0) {
            await removeQueueItem(queueValue.firstWhere((e) => e.id == id));
          }
        }
      }
    }
    await addQueueItems(toAdd.map(generateMediaItem).toList());

    if (!playbackState.value.playing) {
      // await play();
      await skipToQueueItem(0);
    }
  }

  // Check cached by trackId
  // Stream<bool> _cachedCheck(String trackId) async* {
  //   final uri = await _uriById(int.parse(trackId));
  //   final isAvailable = !uri.path.contains('audio');
  //   yield isAvailable;
  // }

  Future<double> _cachedExist(int trackId) async {
    final uri = await _uriById(trackId);
    return uri.path.contains('audio') ? 0.0 : 1.0;
  }

  // Cache tracks
  // ids = [89,3384,7];
  // 1/7
  Future<void> trackCacheDownloadTesting(List<int> ids, {process = true}) async {
    // final abc = ids.map((e){})
    for (int trackId in ids) {
      final block = _cacheProgress.value.firstWhere((element) {
        return element.id == trackId;
      }, orElse: () {
        return AudioCacheType(id: trackId);
      });

      final req = await _getAudioUriCache(trackId);
      final isNotAvailable = req.uri.path.contains('audio');

      if (isNotAvailable) {
        if (process && block.progress == false) {
          req.downloadProgressStream.listen((event) {
            final caching = event.toDouble();
            _cacheProgress.value.removeWhere((item) => item.id == trackId);
            _cacheProgress.value.add(block.copyWith(caching: caching, progress: true));
            _cacheProgress.add(_cacheProgress.value);
            if (caching == 1.0) {
              queueModify(trackId);
            }
          });
          try {
            await req.request().catchError((e) {
              setMessageOnException(e);
            });
          } catch (e) {
            setMessageOnException(e);
          }
        }
      } else {
        if (block.caching < 1.0) {
          _cacheProgress.value.removeWhere((item) => item.id == trackId);
          _cacheProgress.value.add(block.copyWith(caching: 1.0, progress: false));
          _cacheProgress.add(_cacheProgress.value);
        }
      }
    }
  }

  Future<void> trackCacheClearTesting(List<int> ids) async {
    for (int trackId in ids) {
      await _isOfflineAvailable(trackId).then((file) async {
        await file.delete().then((e) {
          _cacheProgress.value.removeWhere((item) => item.id == trackId);
          _cacheProgress.value.add(AudioCacheType(id: trackId));
          _cacheProgress.add(_cacheProgress.value);
          queueModify(trackId);
        }).catchError((e) {
          debugPrint('$e');
        });
      }).catchError((e) {
        debugPrint('$e');
      });
    }
  }

  // Stream<double> trackCacheCheckTesting(List<int> ids) {
  //   return Rx.combineLatest3<List<MediaItem>, List<AudioCacheType>, void, double>(
  //     queue,
  //     _cacheProgress,
  //     Stream.fromFuture(trackCacheDownloadTesting(ids, process: false)),
  //     (queue, _progress, e) {
  //       final lst = _progress.where((e) => ids.contains(e.id));

  //       final progress = lst.map<double>((e) => e.caching).reduce((a, b) => a + b);
  //       final cached = progress / ids.length;
  //       return cached;
  //     },
  //   );
  // }

  Stream<AudioCacheType> trackCacheCheckTesting(List<int> ids) {
    return Rx.combineLatest3<List<MediaItem>, List<AudioCacheType>, void, AudioCacheType>(
      queue,
      _cacheProgress,
      Stream.fromFuture(trackCacheDownloadTesting(ids, process: false)),
      (queue, _progress, e) {
        final lst = _progress.where((e) => ids.contains(e.id));

        final done = lst.map<double>((e) => e.caching).reduce((a, b) => a + b);
        final caching = done / ids.length;
        final progress = lst.where((e) => e.progress).isNotEmpty;
        // return cached;
        return AudioCacheType(
          caching: caching,
          progress: progress,
        );
      },
    );
  }

  // on download and delete completion
  Future<void> queueModify(int trackId) async {
    final index = queue.value.indexWhere((e) => e.id == trackId.toString());
    if (index < 0) return;

    final current = playbackState.value.queueIndex;
    final playing = (current == index && playbackState.value.playing);
    if (playing) stop();

    final item = generateMediaItem(trackId);
    await removeQueueItem(item);
    await insertQueueItem(index, item);
    await updateMediaItem(item);
    if (playing) skipToQueueItem(index);
  }
}
