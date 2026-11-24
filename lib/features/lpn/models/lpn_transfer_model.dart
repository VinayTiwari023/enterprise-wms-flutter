class LpnTransferModel {
  final String transferId;
  final String lpnNumber;
  final String fromLocation;
  final String toLocation;
  final DateTime timestamp;
  final String transferredBy;
  final int itemQty;
  final String status;

  LpnTransferModel({
    required this.transferId,
    required this.lpnNumber,
    required this.fromLocation,
    required this.toLocation,
    required this.timestamp,
    required this.transferredBy,
    required this.itemQty,
    this.status = 'Completed',
  });

  factory LpnTransferModel.fromJson(Map<String, dynamic> json) {
    return LpnTransferModel(
      transferId: json['transferId'] ?? '',
      lpnNumber: json['lpnNumber'] ?? '',
      fromLocation: json['fromLocation'] ?? '',
      toLocation: json['toLocation'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      transferredBy: json['transferredBy'] ?? 'Operator',
      itemQty: json['itemQty'] ?? 0,
      status: json['status'] ?? 'Completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transferId': transferId,
      'lpnNumber': lpnNumber,
      'fromLocation': fromLocation,
      'toLocation': toLocation,
      'timestamp': timestamp.toIso8601String(),
      'transferredBy': transferredBy,
      'itemQty': itemQty,
      'status': status,
    };
  }
}
