// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbound_order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OutboundOrderModelAdapter extends TypeAdapter<OutboundOrderModel> {
  @override
  final int typeId = 3;

  @override
  OutboundOrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OutboundOrderModel(
      orderNumber: fields[0] as String,
      customer: fields[1] as String,
      date: fields[2] as String,
      status: fields[3] as String,
      items: (fields[4] as List).cast<OutboundOrderItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, OutboundOrderModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.orderNumber)
      ..writeByte(1)
      ..write(obj.customer)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutboundOrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
