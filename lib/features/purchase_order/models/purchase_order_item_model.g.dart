// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseOrderItemModelAdapter
    extends TypeAdapter<PurchaseOrderItemModel> {
  @override
  final int typeId = 2;

  @override
  PurchaseOrderItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseOrderItemModel(
      sku: fields[0] as String,
      name: fields[1] as String,
      expectedQty: fields[2] as int,
      receivedQty: fields[3] as int,
      damagedQty: fields[4] as int,
      qcHoldQty: fields[5] as int,
      batchNumber: fields[6] as String?,
      expiryDate: fields[7] as DateTime?,
      damageReason: fields[8] as String?,
      damageImagePath: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseOrderItemModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.sku)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.expectedQty)
      ..writeByte(3)
      ..write(obj.receivedQty)
      ..writeByte(4)
      ..write(obj.damagedQty)
      ..writeByte(5)
      ..write(obj.qcHoldQty)
      ..writeByte(6)
      ..write(obj.batchNumber)
      ..writeByte(7)
      ..write(obj.expiryDate)
      ..writeByte(8)
      ..write(obj.damageReason)
      ..writeByte(9)
      ..write(obj.damageImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseOrderItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
