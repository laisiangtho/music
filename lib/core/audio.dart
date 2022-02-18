part of 'main.dart';

class Audio extends UnitAudio {
  final Collection cluster;

  Audio({
    required void Function() notify,
    required this.cluster,
  });

  AudioBucketType get _cache => cluster.cacheBucket;

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
    _library.listAdd([id]);
    final src = 1 > 2 ? await _getAudioUriCache(id) : await _getAudioUriLive(id);

    expandoMediaItem[src] = item;
    return src;
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

  // NOTE: get AudioSource for uri
  // getAudioUriCache
  Future<AudioSource> _getAudioUriLive(int trackId) async {
    return AudioSource.uri(await _uriById(trackId));
  }

  // NOTE: get AudioSource for caching
  Future<LockCachingAudioSource> _getAudioUriCache(int trackId) async {
    return LockCachingAudioSource(
      await _uriById(trackId),
      // cluster.trackLive(trackId),
      cacheFile: await UtilDocument.file(cluster.trackCache(trackId)),
    );
  }

  // NOTE: track get URI
  // https://www.zaideih.com
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
    return _cache.meta(id);
  }

  Iterable<AudioMetaType> metaById(List<int> ids) {
    return _cache.trackByIds(ids).map((e) => meta(e.id));
  }

  Iterable<AudioMetaType> metaByUd(List<String> ids) {
    return _cache.trackByUid(ids).map((e) => meta(e.id));
  }

  LibraryType get _library => cluster.valueOfLibraryQueue;

  Future<void> queuefromAlbum(List<String> ids) async {
    await queuefromTrack(_cache.trackByUid(ids).map((e) => e.id), group: true);
  }

  Future<void> queuefromRandom() async {
    Iterable<int> randomIds = _library.list;
    if (randomIds.isEmpty) {
      randomIds = _cache.track.take(7).map((e) => e.id);
    }
    await queuefromTrack(randomIds, group: true);
  }

  // TODO: Download/cache option
  Future<void> queuefromTrack(Iterable<int> ids, {bool group = false}) async {
    final playlist = queue.value;
    bool force = playlist.isEmpty;
    Iterable<int> toAdd = ids;
    final qid = playlist.map<int>((e) => int.parse(e.id)).toSet();

    if (force == false || group) {
      toAdd = ids.toSet().difference(qid);
      final toRemove = qid.toSet().difference(ids.toSet()).toList();
      if (group) {
        _library.listRemove(toRemove);
        for (var rid in toRemove) {
          final id = rid.toString();
          final index = playlist.indexWhere((e) => e.id == id);
          if (index == playbackState.value.queueIndex) {
            await stop();
          }
          if (index >= 0) {
            await removeQueueItem(playlist.firstWhere((e) => e.id == id));
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
}
