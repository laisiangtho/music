import 'dart:async';
import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:io';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';


// import 'package:flutter/widgets.dart';
// import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';

import 'package:lidea/notify.dart';
// import 'package:lidea/intl.dart';
import 'package:lidea/engine.dart';
import 'package:lidea/analytics.dart';

import 'package:music/model.dart';
// import 'package:music/notifier.dart';

import 'store.dart';
// import 'tmp.dart';
// import 'sqlite.dart';
// import 'audio.dart';

part 'audio.dart';

part 'configuration.dart';
part 'notify.dart';
part 'abstract.dart';
// part 'store.dart';
// part 'sqlite.dart';
part 'utility.dart';
part 'mock.dart';

class Core extends _Abstract with _Mock {
  // Creates instance through `_internal` constructor
  static final Core _instance = new Core.internal();
  Core.internal();
  factory Core() => _instance;
  // retrieve the instance through the app
  static Core get instance => _instance;

  late void Function({int? at, String? to, Object? args, bool routePush}) navigate;
  // late GlobalKey<NavigatorState> mainNavigator;

  Future<void> init() async {
    Stopwatch initWatch = new Stopwatch()..start();

    if (progressPercentage == 1.0) return;

    await initEnvironment();
    progressPercentage = 0.1;

    await Hive.initFlutter();
    Hive.registerAdapter(SettingAdapter());
    Hive.registerAdapter(PurchaseAdapter());
    Hive.registerAdapter(HistoryAdapter());
    await initSetting();

    progressPercentage = 0.3;

    store = new Store(notify:notify,collection: collection);

    await store.init();
    progressPercentage = 0.5;

    // _sql = new SQLite(collection: collection);
    // await _sql.init();

    collection.cacheBucket.artistInit();
    progressPercentage = 0.6;
    collection.cacheBucket.trackInit();
    collection.cacheBucket.albumInit();
    progressPercentage = 0.7;
    collection.cacheBucket.langInit();
    progressPercentage = 0.8;

    audio = new Audio(notifyIf:notifyIf, collection: collection);
    await audio.init();

    progressPercentage = 0.9;

    await definitionGenerate();
    // await mockTest();

    debugPrint('Initiated in ${initWatch.elapsedMilliseconds} ms');
    progressPercentage = 1.0;
    _message = 'Done';
    // suggestionQuery = 'god';
    // suggestionQuery = collection.setting.searchQuery!;
    // suggestionQuery = collection.setting.searchQuery!;
  }

  Future<void> analyticsReading() async{
    this.analyticsSearch('keyword goes here');
  }

}
