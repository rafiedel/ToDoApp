// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      isDone: fields[3] as bool,
      isTopPriority: fields[4] as bool,
      starts: fields[5] as DateTime,
      ends: fields[6] as DateTime,
      category: fields[7] as String,
      imagesRelated: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isDone)
      ..writeByte(4)
      ..write(obj.isTopPriority)
      ..writeByte(5)
      ..write(obj.starts)
      ..writeByte(6)
      ..write(obj.ends)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.imagesRelated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HistoryAdapter extends TypeAdapter<History> {
  @override
  final int typeId = 1;

  @override
  History read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return History(
      taskName: fields[0] as String,
      action: fields[1] as String,
      when: fields[2] as DateTime,
      id: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, History obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.taskName)
      ..writeByte(1)
      ..write(obj.action)
      ..writeByte(2)
      ..write(obj.when)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      displayName: fields[0] as String,
      profilePicture: fields[1] as String,
      homeTopBarBG: fields[2] as String,
      lastLogin: fields[3] as DateTime,
      lastThemeData: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.displayName)
      ..writeByte(1)
      ..write(obj.profilePicture)
      ..writeByte(2)
      ..write(obj.homeTopBarBG)
      ..writeByte(3)
      ..write(obj.lastLogin)
      ..writeByte(4)
      ..write(obj.lastThemeData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
