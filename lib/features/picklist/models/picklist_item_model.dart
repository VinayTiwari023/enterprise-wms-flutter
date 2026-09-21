import 'package:equatable/equatable.dart';

class PicklistItemModel extends Equatable {
  final String sku;
  final String name;
  final String binLocation; // e.g. "Aisle 1 - Rack B - Shelf 2"
  final String zone; // e.g. "Zone A"
  final int requestedQty;
  final int pickedQty;
  final List<String> orderReferences; // e.g. ["ORD-1001", "ORD-1002"]
  final bool isPicked;

  const PicklistItemModel({
    required this.sku,
    required this.name,
    required this.binLocation,
    required this.zone,
    required this.requestedQty,
    this.pickedQty = 0,
    required this.orderReferences,
    this.isPicked = false,
  });

  PicklistItemModel copyWith({
    String? sku,
    String? name,
    String? binLocation,
    String? zone,
    int? requestedQty,
    int? pickedQty,
    List<String>? orderReferences,
    bool? isPicked,
  }) {
    return PicklistItemModel(
      sku: sku ?? this.sku,
      name: name ?? this.name,
      binLocation: binLocation ?? this.binLocation,
      zone: zone ?? this.zone,
      requestedQty: requestedQty ?? this.requestedQty,
      pickedQty: pickedQty ?? this.pickedQty,
      orderReferences: orderReferences ?? this.orderReferences,
      isPicked: isPicked ?? this.isPicked,
    );
  }

  @override
  List<Object?> get props => [
    sku,
    name,
    binLocation,
    zone,
    requestedQty,
    pickedQty,
    orderReferences,
    isPicked,
  ];
}
