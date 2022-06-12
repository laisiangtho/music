library ui.widget;

export 'package:lidea/widget/main.dart';

import 'dart:async';

import 'dart:math';

// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:hive_flutter/hive_flutter.dart';

import 'package:lidea/intl.dart' as intl;
import 'package:lidea/icon.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/provider.dart';

import 'package:lidea/widget/main.dart';
import 'package:lidea/view/main.dart';

import '/core/main.dart';
import '/type/main.dart';

part 'state.dart';
part 'pull_to_refresh.dart';
part 'album.dart';
part 'album_item.dart';
part 'artist.dart';
part 'artist_item.dart';
part 'attribute.dart';
part 'track.dart';
part 'track_item.dart';

part 'track_option.dart';
part 'playlists_editor.dart';
part 'cache_all.dart';

part 'draggable_model_track.dart';
part 'draggable_model_library.dart';

// enum Status {
//   none,
//   artist,
//   album,
//   recent,
//   most,
//   search,
// }

// WidgetListBuilder WidgetLayoutSet WidgetBoardCommon
