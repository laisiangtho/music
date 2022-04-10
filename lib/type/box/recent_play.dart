part of data.type;

class BoxOfRecentPlay<E> extends BoxOfAbstract<RecentPlayType> {}

@HiveType(typeId: 6)
class RecentPlayType extends HiveObject {
  @HiveField(0)
  DateTime? date;

  @HiveField(1, defaultValue: 0)
  int id;
  // count-plays -> sync
  @HiveField(2, defaultValue: 0)
  int count;
  @HiveField(3, defaultValue: 0)
  int plays;

  RecentPlayType({
    this.date,
    this.id = 0,
    this.count = 0,
    this.plays = 0,
  });
}

class RecentPlayAdapter extends TypeAdapter<RecentPlayType> {
  @override
  final typeId = 6;

  @override
  RecentPlayType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentPlayType()
      ..date = (fields[0] ?? DateTime.now()) as DateTime
      ..id = (fields[1] ?? 0) as int
      ..count = (fields[2] ?? 0) as int
      ..plays = (fields[3] ?? 0) as int;
  }

  @override
  void write(BinaryWriter writer, RecentPlayType obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date ?? DateTime.now())
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.plays);
  }
}

/*
@HiveType(typeId: 7)
class RecentPlayAlbumType extends HiveObject {
  @HiveField(0)
  DateTime? date;

  @HiveField(1, defaultValue: '')
  String uid;

  RecentPlayAlbumType({
    this.date,
    this.uid = '',
  });
}

class RecentPlayAlbumAdapter extends TypeAdapter<RecentPlayAlbumType> {
  @override
  final typeId = 7;

  @override
  RecentPlayAlbumType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentPlayAlbumType()
      ..date = (fields[0] ?? DateTime.now()) as DateTime
      ..uid = (fields[1] ?? '') as String;
  }

  @override
  void write(BinaryWriter writer, RecentPlayAlbumType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date ?? DateTime.now())
      ..writeByte(1)
      ..write(obj.uid);
  }
}

*/