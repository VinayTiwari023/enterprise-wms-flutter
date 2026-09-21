import 'package:equatable/equatable.dart';

class ItemMasterModel extends Equatable {
  final String sku;
  final String name;
  final String category;
  final String unitOfMeasure; // 'Pcs', 'Boxes', 'Rolls', 'Pallets'
  final String defaultBin;
  final int minStock;
  final int maxStock;
  final double unitPrice;

  const ItemMasterModel({
    required this.sku,
    required this.name,
    required this.category,
    required this.unitOfMeasure,
    required this.defaultBin,
    required this.minStock,
    required this.maxStock,
    required this.unitPrice,
  });

  @override
  List<Object?> get props => [
    sku,
    name,
    category,
    unitOfMeasure,
    defaultBin,
    minStock,
    maxStock,
    unitPrice,
  ];

  ItemMasterModel copyWith({
    String? sku,
    String? name,
    String? category,
    String? unitOfMeasure,
    String? defaultBin,
    int? minStock,
    int? maxStock,
    double? unitPrice,
  }) {
    return ItemMasterModel(
      sku: sku ?? this.sku,
      name: name ?? this.name,
      category: category ?? this.category,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      defaultBin: defaultBin ?? this.defaultBin,
      minStock: minStock ?? this.minStock,
      maxStock: maxStock ?? this.maxStock,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}
