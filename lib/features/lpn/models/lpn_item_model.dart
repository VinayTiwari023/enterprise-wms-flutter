class LpnItemModel {
  final String sku;
  final String itemName;
  final int quantity;
  final String? batchNumber;
  final DateTime? expiryDate;

  LpnItemModel({
    required this.sku,
    required this.itemName,
    required this.quantity,
    this.batchNumber,
    this.expiryDate,
  });

  factory LpnItemModel.fromJson(Map<String, dynamic> json) {
    return LpnItemModel(
      sku: json['sku'] ?? '',
      itemName: json['itemName'] ?? '',
      quantity: json['quantity'] ?? 0,
      batchNumber: json['batchNumber'],
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'itemName': itemName,
      'quantity': quantity,
      'batchNumber': batchNumber,
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }

  LpnItemModel copyWith({
    String? sku,
    String? itemName,
    int? quantity,
    String? batchNumber,
    DateTime? expiryDate,
  }) {
    return LpnItemModel(
      sku: sku ?? this.sku,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}
