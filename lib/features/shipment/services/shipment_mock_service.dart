import '../models/outbound_order_model.dart';

class ShipmentMockService {
  Future<List<OutboundOrderModel>> getOutboundOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      OutboundOrderModel(
        orderNumber: "ORD-7721",
        customer: "Retail Hub India",
        progressText: "0/45",
        date: "8/7",
        status: "Pending",
        progress: 0.0,
      ),
      OutboundOrderModel(
        orderNumber: "ORD-8812",
        customer: "Zenix Electronics",
        progressText: "8/12",
        date: "7/7",
        status: "Picking",
        progress: 0.66,
      ),
      OutboundOrderModel(
        orderNumber: "ORD-9905",
        customer: "Fresh Foods Market",
        progressText: "120/120",
        date: "8/7",
        status: "Shipped",
        progress: 1.0,
      ),
    ];
  }
}
