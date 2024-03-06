// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class hiveTaskAdapter extends TypeAdapter<hiveTask> {
  @override
  final int typeId = 0;

  @override
  hiveTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return hiveTask(
      id: fields[0] as String,
      title: fields[1] as String,
      subTitle: fields[2] as String,
      startAtDate: fields[3] as DateTime,
      endAtDate: fields[4] as DateTime,
      isCompleted: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, hiveTask obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subTitle)
      ..writeByte(3)
      ..write(obj.startAtDate)
      ..writeByte(4)
      ..write(obj.endAtDate)
      ..writeByte(5)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is hiveTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
