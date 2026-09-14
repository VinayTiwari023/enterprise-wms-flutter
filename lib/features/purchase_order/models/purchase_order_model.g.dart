// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseOrderModelAdapter extends TypeAdapter<PurchaseOrderModel> {
  @override
  final int typeId = 1;

  @override
  PurchaseOrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseOrderModel(
      poNumber: fields[0] as String,
      supplier: fields[1] as String,
      items: fields[2] as String,
      date: fields[3] as String,
      status: fields[4] as String,
      progress: fields[5] as double,
      itemsList: (fields[6] as List).cast<PurchaseOrderItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseOrderModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.poNumber)
      ..writeByte(1)
      ..write(obj.supplier)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.progress)
      ..writeByte(6)
      ..write(obj.itemsList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseOrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
