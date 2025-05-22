// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SmsModelAdapter extends TypeAdapter<SmsModel> {
  @override
  final int typeId = 0;

  @override
  SmsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmsModel(
      sender: fields[0] as String?,
      body: fields[1] as String?,
      timestamp: fields[2] as DateTime?,
      isPhishing: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SmsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sender)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.isPhishing);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
