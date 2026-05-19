part of 'tv_show.dart';

class TvShowAdapter extends TypeAdapter<TvShow> {
  @override
  final int typeId = 0;

  @override
  TvShow read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvShow(
      id: fields[0] as int,
      name: fields[1] as String,
      rating: fields[2] as double?,
      imageUrl: fields[3] as String?,
      genres: (fields[4] as List).cast<String>(),
      summary: fields[5] as String?,
      mediumImageUrl: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TvShow obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.genres)
      ..writeByte(5)
      ..write(obj.summary)
      ..writeByte(6)
      ..write(obj.mediumImageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvShowAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
