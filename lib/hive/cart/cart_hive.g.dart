// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartHiveAdapter extends TypeAdapter<CartHive> {
  @override
  final int typeId = 1;

  @override
  CartHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartHive()
      ..serviceId = fields[0] as int
      ..quantity = fields[1] as int
      ..description = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, CartHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.serviceId)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
