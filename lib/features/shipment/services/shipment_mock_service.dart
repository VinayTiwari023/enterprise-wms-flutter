import '../models/outbound_order_model.dart';
import '../models/outbound_order_item_model.dart';

class ShipmentMockService {
  static final List<OutboundOrderModel> _mockOrders = [
    OutboundOrderModel(
      orderNumber: "ORD-7721",
      customer: "Retail Hub India",
      date: "8/7/2026",
      status: "Pending",
      items: [
        OutboundOrderItemModel(
          sku: "SKU-1000",
          name: "Heavy Duty Pallet",
          orderedQty: 10,
          location: "BIN-1000-A",
        ),
        OutboundOrderItemModel(
          sku: "SKU-1001",
          name: "Industrial Wrap",
          orderedQty: 35,
          location: "BIN-1001-B",
        ),
      ],
    ),
    OutboundOrderModel(
      orderNumber: "ORD-8812",
      customer: "Zenix Electronics",
      date: "7/7/2026",
      status: "Picking",
      items: [
        OutboundOrderItemModel(
          sku: "SKU-5001",
          name: "Ethernet Cables",
          orderedQty: 12,
          pickedQty: 8,
          location: "BIN-5001-A",
        ),
      ],
    ),
    OutboundOrderModel(
      orderNumber: "ORD-9905",
      customer: "Fresh Foods Market",
      date: "8/7/2026",
      status: "Shipped",
      items: [
        OutboundOrderItemModel(
          sku: "SKU-2002",
          name: "Plastic Crates",
          orderedQty: 120,
          pickedQty: 120,
          location: "BIN-2002-C",
        ),
      ],
    ),
  ];

  Future<List<OutboundOrderModel>> getOutboundOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockOrders);
  }

  Future<void> updateOrder(OutboundOrderModel updatedOrder) async {
    final index = _mockOrders.indexWhere(
      (o) => o.orderNumber == updatedOrder.orderNumber,
    );
    if (index != -1) {
      _mockOrders[index] = updatedOrder;
    }
  }
}
