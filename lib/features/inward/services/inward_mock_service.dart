import '../models/purchase_order_model.dart';

class InwardMockService {
  Future<List<PurchaseOrderModel>> getPurchaseOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      PurchaseOrderModel(
        poNumber: "PO-2024-001",
        supplier: "Global Logistics Corp",
        items: "0/150",
        date: "7/7/2026",
        status: "Pending",
        progress: 0.0,
      ),
      PurchaseOrderModel(
        poNumber: "PO-2024-005",
        supplier: "Tech Supplies Ltd",
        items: "45/200",
        date: "6/7/2026",
        status: "Partial",
        progress: 0.225,
      ),
      PurchaseOrderModel(
        poNumber: "PO-2023-998",
        supplier: "Industrial Parts Inc",
        items: "80/80",
        date: "8/7/2026",
        status: "Completed",
        progress: 1.0,
      ),
    ];
  }
}
