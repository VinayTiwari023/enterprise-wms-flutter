import 'outbound_order_item_model.dart';
import 'package:equatable/equatable.dart';

class OutboundOrderModel extends Equatable {
  final String orderNumber;
  final String customer;
  final String date;
  final String status;
  final List<OutboundOrderItemModel> items;

  const OutboundOrderModel({
    required this.orderNumber,
    required this.customer,
    required this.date,
    required this.status,
    required this.items,
  });

  double get progress {
    if (items.isEmpty) return 0.0;
    int totalOrdered = items.fold(0, (sum, item) => sum + item.orderedQty);
    int totalPicked = items.fold(0, (sum, item) => sum + item.pickedQty);
    return totalOrdered == 0 ? 0.0 : totalPicked / totalOrdered;
  }

  String get progressText {
    int totalOrdered = items.fold(0, (sum, item) => sum + item.orderedQty);
    int totalPicked = items.fold(0, (sum, item) => sum + item.pickedQty);
    return "$totalPicked/$totalOrdered";
  }

  OutboundOrderModel copyWith({
    String? orderNumber,
    String? customer,
    String? date,
    String? status,
    List<OutboundOrderItemModel>? items,
  }) {
    return OutboundOrderModel(
      orderNumber: orderNumber ?? this.orderNumber,
      customer: customer ?? this.customer,
      date: date ?? this.date,
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [orderNumber, customer, date, status, items];
}
