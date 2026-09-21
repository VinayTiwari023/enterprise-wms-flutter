class StockTransferModel {
  final String id;
  final String sku;
  final String itemName;
  final String fromLocation;
  final String toLocation;
  final int quantity;
  final DateTime timestamp;
  final String transferredBy;
  final String status;
  final String reason;

  StockTransferModel({
    required this.id,
    required this.sku,
    required this.itemName,
    required this.fromLocation,
    required this.toLocation,
    required this.quantity,
    required this.timestamp,
    required this.transferredBy,
    required this.status,
    required this.reason,
  });

  factory StockTransferModel.fromJson(Map<String, dynamic> json) {
    return StockTransferModel(
      id: json['id'] ?? '',
      sku: json['sku'] ?? '',
      itemName: json['itemName'] ?? '',
      fromLocation: json['fromLocation'] ?? '',
      toLocation: json['toLocation'] ?? '',
      quantity: json['quantity'] ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      transferredBy: json['transferredBy'] ?? 'Operator',
      status: json['status'] ?? 'Completed',
      reason: json['reason'] ?? 'Relocation',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'itemName': itemName,
      'fromLocation': fromLocation,
      'toLocation': toLocation,
      'quantity': quantity,
      'timestamp': timestamp.toIso8601String(),
      'transferredBy': transferredBy,
      'status': status,
      'reason': reason,
    };
  }
}
