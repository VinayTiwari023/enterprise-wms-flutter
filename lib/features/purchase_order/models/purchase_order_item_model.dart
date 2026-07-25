enum ItemCondition { good, damaged, qcHold }

class PurchaseOrderItemModel {
  final String sku;
  final String name;
  final int expectedQty;
  int receivedQty;
  int damagedQty;
  int qcHoldQty;
  String? batchNumber;
  DateTime? expiryDate;
  String? damageReason;

  PurchaseOrderItemModel({
    required this.sku,
    required this.name,
    required this.expectedQty,
    this.receivedQty = 0,
    this.damagedQty = 0,
    this.qcHoldQty = 0,
    this.batchNumber,
    this.expiryDate,
    this.damageReason,
  });

  double get progress => expectedQty == 0 ? 0 : (receivedQty + damagedQty + qcHoldQty) / expectedQty;
  
  bool get isFullyReceived => (receivedQty + damagedQty + qcHoldQty) >= expectedQty;

  PurchaseOrderItemModel copyWith({
    int? receivedQty,
    int? damagedQty,
    int? qcHoldQty,
    String? batchNumber,
    DateTime? expiryDate,
    String? damageReason,
  }) {
    return PurchaseOrderItemModel(
      sku: sku,
      name: name,
      expectedQty: expectedQty,
      receivedQty: receivedQty ?? this.receivedQty,
      damagedQty: damagedQty ?? this.damagedQty,
      qcHoldQty: qcHoldQty ?? this.qcHoldQty,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      damageReason: damageReason ?? this.damageReason,
    );
  }

  factory PurchaseOrderItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderItemModel(
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      expectedQty: json['expectedQty'] ?? 0,
      receivedQty: json['receivedQty'] ?? 0,
      damagedQty: json['damagedQty'] ?? 0,
      qcHoldQty: json['qcHoldQty'] ?? 0,
      batchNumber: json['batchNumber'],
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      damageReason: json['damageReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'name': name,
      'expectedQty': expectedQty,
      'receivedQty': receivedQty,
      'damagedQty': damagedQty,
      'qcHoldQty': qcHoldQty,
      'batchNumber': batchNumber,
      'expiryDate': expiryDate?.toIso8601String(),
      'damageReason': damageReason,
    };
  }
}
