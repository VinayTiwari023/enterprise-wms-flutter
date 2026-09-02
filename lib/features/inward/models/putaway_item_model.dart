import 'package:equatable/equatable.dart';

class PutawayItemModel extends Equatable {
  final String sku;
  final String itemName;
  final String suggestedBin;
  final String zone;
  final String area;
  final int quantity;
  final bool isConfirmed;

  const PutawayItemModel({
    required this.sku,
    required this.itemName,
    required this.suggestedBin,
    required this.zone,
    required this.area,
    required this.quantity,
    this.isConfirmed = false,
  });

  PutawayItemModel copyWith({
    String? sku,
    String? itemName,
    String? suggestedBin,
    String? zone,
    String? area,
    int? quantity,
    bool? isConfirmed,
  }) {
    return PutawayItemModel(
      sku: sku ?? this.sku,
      itemName: itemName ?? this.itemName,
      suggestedBin: suggestedBin ?? this.suggestedBin,
      zone: zone ?? this.zone,
      area: area ?? this.area,
      quantity: quantity ?? this.quantity,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  @override
  List<Object?> get props => [
    sku,
    itemName,
    suggestedBin,
    zone,
    area,
    quantity,
    isConfirmed,
  ];
}
