class InventoryItemModel {
  final String name;
  final String sku;
  final String location;
  final int units;
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
