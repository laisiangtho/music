library data.type;

// NOTE: Core API manager
export "package:lidea/main.dart";
import "package:lidea/main.dart";

import "package:lidea/hive.dart";

part "collection.dart";

part "audio.dart";
part 'box/filter.dart';
part 'box/library.dart';
part 'box/recent_play.dart';

/// tmp
// class UserDataType {
//   int version;
//   int size;
//   List<int> playlist;
//   List<String> keywords;

//   UserDataType({
//     required this.version,
//     required this.size,
//     required this.playlist,
//     required this.keywords,
//   });

//   factory UserDataType.fromJSON(Map<String, dynamic> o) {
//     return UserDataType(
//       version: int.parse((o["version"] ?? 0)),
//       size: int.parse((o["size"] ?? 0)),
//       playlist: List.from(o['playlist'] ?? []).map<int>((e) => int.parse(e)).toList(),
//       keywords: List.from(o['keywords'] ?? []).map<String>((e) => e.toString()).toList(),
//     );
//   }

//   Map<String, dynamic> toJSON() {
//     return {
//       "version": version,
//       "size": size,
//       "playlist": playlist,
//       "keywords": keywords,
//     };
//   }
// }
