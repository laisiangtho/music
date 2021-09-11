
part of 'main.dart';

abstract class _Abstract extends CoreNotifier with _Configuration, _Utility {
  Future<void> initEnvironment() async {
    collection.env = EnvironmentType.fromJSON(UtilDocument.decodeJSON(await UtilDocument.loadBundleAsString('env.json')));
  }

  Future<void> initSetting() async {
    // Box<SettingType> box = await Hive.openBox<SettingType>(collection.env.settingName);
    // SettingType active = collection.boxOfSetting.get(collection.env.settingKey,defaultValue: collection.env.setting)!;
    collection.boxOfSetting = await Hive.openBox<SettingType>(collection.env.settingName);
    SettingType active = collection.setting;

    if (collection.boxOfSetting.isEmpty){
      collection.boxOfSetting.put(collection.env.settingKey,collection.env.setting);
      await loadArchive(collection.env.bucketAPI.archive);
    } else if (active.version != collection.env.setting.version){
      collection.boxOfSetting.put(collection.env.settingKey,active.merge(collection.env.setting));
      await loadArchive(collection.env.bucketAPI.archive);
    }

    collection.cacheBucket = AudioBucketType.fromJSON(
      Map.fromEntries(
        await Future.wait(collection.env.apis.map(
          (e) async => MapEntry(e.uid, await readArchive(e.archive))
        ))
      )
    );

    // final album = collection.cacheBucket.album;
    // final artist = collection.cacheBucket.artist;
    // final genre = collection.cacheBucket.genre;
    // final lang = collection.cacheBucket.lang;
    // final totalTrack = album.map((e) => e.track.length).reduce((a, b) => a+b);
    // print('al ${album.length} tt $totalTrack ar ${artist.length} gr ${genre.length} lg ${lang.length}');

    collection.boxOfPurchase = await Hive.openBox<PurchaseType>('purchase-tmp');
    // collection.boxOfSetting.clear();

    collection.boxOfHistory = await Hive.openBox<HistoryType>('history-tmp');
    // await collection.boxOfHistory.clear();
  }

  void historyClearNotify() => collection.boxOfHistory.clear().whenComplete(notify);

  // NOTE: Archive extract File
  Future<List<String>> loadArchive(file) async{
    // return [file];
    List<int>? bytes = await UtilDocument.loadBundleAsByte(file).then(
      (data) => UtilDocument.byteToListInt(data).catchError((_) => null)
    ).catchError((e) => null);
    if (bytes != null && bytes.isNotEmpty) {
      final res = await UtilArchive().extract(bytes).catchError((_) {
        print('$_');
        return null;
      });
      if (res != null) {
        return res;
      }
    }
    return Future.error("Failed to load");
  }

  // NOTE: Archive read File
  Future<List<dynamic>> readArchive(file) {
    return UtilDocument.exists(file).then((String e) async{
      if (e.isEmpty) {
        await loadArchive(collection.env.bucketAPI.archive);
      }
      return UtilDocument.decodeJSON<List<dynamic>>(await UtilDocument.readAsString(file));
      // print('album ${collection.env.bucketAPI.archive} is ${e.isNotEmpty} ');
    });
    // return Future.error("Failed to load");
  }

  // ignore: todo
  // TODO: analytics
  Future<void> analyticsFromCollection() async{
    this.analyticsSearch('keyword goes here');
  }
}
