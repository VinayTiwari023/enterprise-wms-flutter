import 'package:equatable/equatable.dart';
import 'return_item_model.dart';

class ReturnOrderModel extends Equatable {
  final String rmaNumber; // e.g. "RMA-9081"
  final String originalOrderNumber; // e.g. "ORD-1002"
  final String customerName;
  final String
  returnReason; // "Defective Item", "Wrong Item", "Customer Changed Mind", "Carrier Damage"
  final String status; // "Pending Inspection", "Inspected", "Processed"
  final DateTime date;
  final List<ReturnItemModel> items;

  const ReturnOrderModel({
    required this.rmaNumber,
    required this.originalOrderNumber,
    required this.customerName,
    required this.returnReason,
    required this.status,
    required this.date,
    required this.items,
  });

  double get totalValue =>
      items.fold(0.0, (sum, item) => sum + (item.unitPrice * item.quantity));

  bool get isInspected =>
      items.isNotEmpty && items.every((i) => i.disposition != "Pending");

  ReturnOrderModel copyWith({
    String? rmaNumber,
    String? originalOrderNumber,
    String? customerName,
    String? returnReason,
    String? status,
    DateTime? date,
    List<ReturnItemModel>? items,
  }) {
    return ReturnOrderModel(
      rmaNumber: rmaNumber ?? this.rmaNumber,
      originalOrderNumber: originalOrderNumber ?? this.originalOrderNumber,
      customerName: customerName ?? this.customerName,
      returnReason: returnReason ?? this.returnReason,
      status: status ?? this.status,
      date: date ?? this.date,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
    rmaNumber,
    originalOrderNumber,
    customerName,
    returnReason,
    status,
    date,
    items,
  ];
}
