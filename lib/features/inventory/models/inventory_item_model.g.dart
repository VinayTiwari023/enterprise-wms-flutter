// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryItemModelAdapter extends TypeAdapter<InventoryItemModel> {
  @override
  final int typeId = 0;

  @override
  InventoryItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryItemModel(
      name: fields[0] as String,
      sku: fields[1] as String,
      location: fields[2] as String,
      units: fields[3] as int,
      status: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InventoryItemModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.sku)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.units)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
