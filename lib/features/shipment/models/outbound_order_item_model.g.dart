// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbound_order_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OutboundOrderItemModelAdapter
    extends TypeAdapter<OutboundOrderItemModel> {
  @override
  final int typeId = 4;

  @override
  OutboundOrderItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OutboundOrderItemModel(
      sku: fields[0] as String,
      name: fields[1] as String,
      orderedQty: fields[2] as int,
      pickedQty: fields[3] as int,
      location: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OutboundOrderItemModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.sku)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.orderedQty)
      ..writeByte(3)
      ..write(obj.pickedQty)
      ..writeByte(4)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutboundOrderItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
