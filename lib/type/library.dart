part of "main.dart";

/// Like, Favorite, PlayList, Queue, Recent
///
/// type -> Queue:0; Like(Favorite):1; Recent:2; Playlists: 3
@HiveType(typeId: 5)
class LibraryType extends HiveObject {
  @HiveField(0)
  DateTime? date;

  @HiveField(1, defaultValue: '')
  late String name;
  @HiveField(2, defaultValue: 0)
  late int type;
  @HiveField(3, defaultValue: '')
  late String description;
  @HiveField(4, defaultValue: [])
  late List<int> list;

  LibraryType({
    this.date,
    this.name = '',
    this.type = 0,
    this.description = '',
    this.list = const [],
  });

  factory LibraryType.fromJSON(Map<String, dynamic> o) {
    return LibraryType(
      date: o["date"] as DateTime,
      name: o["name"] as String,
      type: o["type"] as int,
      description: o["description"] as String,
      list: o["list"] as List<int>,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "date": date,
      "name": name,
      "type": type,
      "description": description,
      "list": list.toString(),
    };
  }

  void listAdd(Iterable<int> ids) {
    // if (!list.contains(trackId)) {
    //   list.add(trackId);
    //   save();
    // }
    list.addAll(ids);
    save();
  }

  void listRemove(Iterable<int> ids) {
    // if (list.contains(trackId)) {
    //   list.remove(trackId);
    //   save();
    // }
    list.removeWhere((e) => ids.contains(e));
    save();
  }

  // void listUpdate(Iterable<int> ids) {
  //   // for (var rid in list.toSet().difference(ids.toSet())) {
  //   //   list.remove(rid);
  //   // }
  //   // for (var rid in ids.toSet().difference(list.toSet())) {
  //   //   list.add(rid);
  //   // }
  //   final rid = list.toSet().difference(ids.toSet());
  //   listRemove(rid);
  //   final aid = ids.toSet().difference(list.toSet());
  //   listRemove(aid);
  // }

  // void listClear() {
  //   list.clear();
  //   save();
  // }
}

class LibraryAdapter extends TypeAdapter<LibraryType> {
  @override
  final typeId = 5;

  @override
  LibraryType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LibraryType()
      ..date = (fields[0] ?? DateTime.now()) as DateTime
      ..name = (fields[1] ?? '') as String
      ..type = (fields[2] ?? 3) as int
      ..description = (fields[3] ?? '') as String
      ..list = (fields[4] ?? []) as List<int>;
  }

  @override
  void write(BinaryWriter writer, LibraryType obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date ?? DateTime.now())
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.list);
  }
}
