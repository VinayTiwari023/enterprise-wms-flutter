import 'package:hive/hive.dart';

part 'inventory_item_model.g.dart';

@HiveType(typeId: 0)
class InventoryItemModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String sku;
  @HiveField(2)
  final String location;
  @HiveField(3)
  final int units;
  @HiveField(4)
  final String status;

  InventoryItemModel({
    required this.name,
    required this.sku,
    required this.location,
    required this.units,
    required this.status,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      location: json['location'] ?? '',
      units: json['units'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
      'location': location,
      'units': units,
      'status': status,
    };
  }
}
