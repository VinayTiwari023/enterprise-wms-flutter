import 'purchase_order_item_model.dart';

class PurchaseOrderModel {
  final String poNumber;
  final String supplier;
  final String items; // Keeping for backward compat or summary
  final String date;
  final String status;
  final double progress;
  final List<PurchaseOrderItemModel> itemsList;

  PurchaseOrderModel({
    required this.poNumber,
    required this.supplier,
    required this.items,
    required this.date,
    required this.status,
    required this.progress,
    this.itemsList = const [],
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderModel(
      poNumber: json['poNumber'] ?? '',
      supplier: json['supplier'] ?? '',
      items: json['items'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
      itemsList:
          (json['itemsList'] as List?)
              ?.map((e) => PurchaseOrderItemModel.fromJson(e))
              .toList() ??
          [],
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
      'itemsList': itemsList.map((e) => e.toJson()).toList(),
    };
  }

  PurchaseOrderModel copyWith({
    String? items,
    String? status,
    double? progress,
    List<PurchaseOrderItemModel>? itemsList,
  }) {
    return PurchaseOrderModel(
      poNumber: poNumber,
      supplier: supplier,
      items: items ?? this.items,
      date: date,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      itemsList: itemsList ?? this.itemsList,
    );
  }
}
