import 'package:equatable/equatable.dart';

class ReturnItemModel extends Equatable {
  final String sku;
  final String name;
  final int quantity;
  final double unitPrice;
  final String
  condition; // "New / Unopened", "Opened Good", "Damaged", "Defective"
  final String
  disposition; // "Pending", "Restock to Bin", "Quarantine", "Scrap"
  final String? notes;

  const ReturnItemModel({
    required this.sku,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.condition = "Opened Good",
    this.disposition = "Pending",
    this.notes,
  });

  ReturnItemModel copyWith({
    String? sku,
    String? name,
    int? quantity,
    double? unitPrice,
    String? condition,
    String? disposition,
    String? notes,
  }) {
    return ReturnItemModel(
      sku: sku ?? this.sku,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      condition: condition ?? this.condition,
      disposition: disposition ?? this.disposition,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    sku,
    name,
    quantity,
    unitPrice,
    condition,
    disposition,
    notes,
  ];
}
