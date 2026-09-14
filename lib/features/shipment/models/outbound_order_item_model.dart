import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'outbound_order_item_model.g.dart';

@HiveType(typeId: 4)
class OutboundOrderItemModel extends Equatable {
  @HiveField(0)
  final String sku;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int orderedQty;
  @HiveField(3)
  final int pickedQty;
  @HiveField(4)
  final String location;

  const OutboundOrderItemModel({
    required this.sku,
    required this.name,
    required this.orderedQty,
    this.pickedQty = 0,
    required this.location,
  });

  bool get isFullyPicked => pickedQty >= orderedQty;

  OutboundOrderItemModel copyWith({
    String? sku,
    String? name,
    int? orderedQty,
    int? pickedQty,
    String? location,
  }) {
    return OutboundOrderItemModel(
      sku: sku ?? this.sku,
      name: name ?? this.name,
      orderedQty: orderedQty ?? this.orderedQty,
      pickedQty: pickedQty ?? this.pickedQty,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [sku, name, orderedQty, pickedQty, location];
}
