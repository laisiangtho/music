import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';

// NOTE: Preference
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:lidea/hive.dart';
import 'package:lidea/intl.dart';
import 'package:lidea/unit/controller.dart';

// NOTE: Authentication
// import 'package:lidea/firebase_auth.dart';
import 'package:lidea/unit/authentication.dart';

// NOTE: Navigation
import 'package:lidea/unit/navigation.dart';

// NOTE: Analytics
import 'package:lidea/unit/analytics.dart';

// NOTE: Store
import 'package:lidea/unit/store.dart';
// NOTE: SQLite
// import 'package:lidea/unit/sqlite.dart';
// NOTE: Audio
import 'package:lidea/audio.dart';
import 'package:lidea/unit/audio.dart';
// import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';

// NOTE: Core notify and Initializing properties
import 'package:lidea/unit/engine.dart';
// NOTE: Core API manager
import 'package:lidea/util/main.dart';
// Mock:
// import 'package:lidea/unit/mock.dart';

import '/type/main.dart';

part 'store.dart';
part 'sqlite.dart';
part 'audio.dart';

part 'preference.dart';
part 'authentication.dart';
part 'navigation.dart';
part 'analytics.dart';

part 'abstract.dart';
part 'utility.dart';
part 'mock.dart';
part 'search.dart';

class Core extends _Abstract with _Mock {
  // Core() : super();

  Future<void> init(BuildContext context) async {
    Stopwatch initWatch = Stopwatch()..start();
    collection.locale = Localizations.localeOf(context).languageCode;
    preference.context = context;

    // await Future.microtask(() => null);

    await dataInitialized();

    await store.init();
    await _sql.init();
    final _audioHandler = Audio(cluster: collection);
    audio = await _audioHandler.init();

    // await mockTest();

    // final abc = collection.env.api.last.uri(name: 'name', index: 2);
    // final abc = collection.env.url('track').uri(name: '4354', index: 1, scheme: 'http');
    final abc = collection.env.url('track').cache('4354');

    debugPrint('api in $abc');
    debugPrint('Initiated in ${initWatch.elapsedMilliseconds} ms');
  }
}
