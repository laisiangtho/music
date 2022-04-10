part of data.type;

class BoxOfFilterCommon<E> extends BoxOfAbstract<FilterCommonType> {}

// var artist = FilterCommonType(date: DateTime.now())..character = ['Lisa'];

// boxOfFilterCommon.add(artist); // Store this object for the first time

// debugPrint('Number of artist: ${boxOfFilterCommon.length}');
// debugPrint("artist first key: ${artist.key}");
// debugPrint("artist first value: ${artist.character}");

// // boxOfFilterCommon.listenable();
// artist.character = ['Lucas'];
// artist.save(); // Update object

// artist.delete(); // Remove object from Hive
// debugPrint('artist: ${boxOfFilterCommon.length}');

// boxOfFilterCommon.put('someKey', artist);
// debugPrint("artist second key: ${artist.key}");

// final senon = boxOfFilterCommon.get('someKey', defaultValue: FilterCommonType(date: DateTime.now()))!;

// final senon = boxOfFilterCommon.get('artist')!;
// debugPrint("??: ${senon.character}");
// senon.character.add('a');
// senon.save();

// senon.delete();

@HiveType(typeId: 4)
class FilterCommonType extends HiveObject {
  @HiveField(0)
  DateTime? date;

  @HiveField(1, defaultValue: [])
  List<String> character;
  @HiveField(2, defaultValue: [])
  late List<int> language;
  @HiveField(3, defaultValue: [])
  late List<int> gender;
  @HiveField(4, defaultValue: [])
  late List<int> genre;

  FilterCommonType({
    this.date,
    this.character = const [],
    this.language = const [],
    this.gender = const [],
    this.genre = const [],
  });

  // factory FilterCommonType.fromJSON(Map<String, dynamic> o) {
  //   return FilterCommonType(
  //     date: o["date"] as DateTime,
  //   );
  // }

  // Map<String, dynamic> toJSON() {
  //   return {
  //     "date": date,
  //   };
  // }
}

class FilterCommonAdapter extends TypeAdapter<FilterCommonType> {
  @override
  final typeId = 4;

  @override
  // FilterCommonType read(BinaryReader reader) {
  //   return FilterCommonType()..character = reader.read() as List<String>;
  // }
  FilterCommonType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FilterCommonType()
      ..date = (fields[0] ?? DateTime.now()) as DateTime
      ..character = (fields[1] ?? []) as List<String>
      ..language = (fields[2] ?? []) as List<int>
      ..gender = (fields[3] ?? []) as List<int>
      ..genre = (fields[4] ?? []) as List<int>;
  }

  @override
  // void write(BinaryWriter writer, FilterCommonType obj) {
  //   writer.write(obj.character);
  // }
  void write(BinaryWriter writer, FilterCommonType obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date ?? DateTime.now())
      ..writeByte(1)
      ..write(obj.character)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.genre);
  }
}

// NOTE: only type, EnvironmentType child
// class SynmapType {
//   final int id;
//   final int type;
//   final String name;
//   SynmapType({required this.id, required this.type, required this.name});

//   factory SynmapType.fromJSON(Map<String, dynamic> o) {
//     return SynmapType(id: o["id"] as int, type: o["type"] as int, name: o["name"] as String);
//   }

//   Map<String, dynamic> toJSON() {
//     return {"id": id, "type": type, "name": name};
//   }
// }

// List<String> artistFilterCharList = [];
// List<int> artistFilterLangList = [];
// List<int> artistFilterGenderList = [];
// List<String> albumFilterCharList = [];
// List<int> albumFilterLangList = [];
// List<int> albumFilterGenreList = [];
// NOTE: adapter/favorite.dart
/*
@HiveType(typeId: 2)
class FilterCommonType {
  @HiveField(0)
  DateTime? date;

  @HiveField(1)
  List<String> character;
  @HiveField(2)
  List<int> language;
  @HiveField(3)
  List<int> gender;
  // @HiveField(4)
  // List<int> genre;

  FilterCommonType({
    this.date,
    required this.character,
    required this.language,
    required this.gender,
    // required this.genre,
  });

  factory FilterCommonType.fromJSON(Map<String, dynamic> o) {
    return FilterCommonType(
      date: o["date"] as DateTime,
      character: o["character"] as List<String>,
      language: o["language"] as List<int>,
      gender: o["gender"] as List<int>,
      // genre: o["genre"] as String,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "date": date,
      "character": character.toString(),
      "language": language.toString(),
      "gender": gender.toString(),
      // "genre": genre.toString(),
    };
  }
}
*/