class PurchaseOrderModel {
  final String poNumber;
  final String supplier;
  final String items;
  final String date;
  final String status;
  final double progress;

  PurchaseOrderModel({
    required this.poNumber,
    required this.supplier,
    required this.items,
    required this.date,
    required this.status,
    required this.progress,
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderModel(
      poNumber: json['poNumber'] ?? '',
      supplier: json['supplier'] ?? '',
      items: json['items'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poNumber': poNumber,
      'supplier': supplier,
      'items': items,
      'date': date,
      'status': status,
      'progress': progress,
    };
  }
}
