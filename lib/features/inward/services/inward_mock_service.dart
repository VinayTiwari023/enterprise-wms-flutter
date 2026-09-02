import '../../purchase_order/models/purchase_order_model.dart';
import '../../purchase_order/models/purchase_order_item_model.dart';

class InwardMockService {
  static final List<PurchaseOrderModel> _mockPOs = [
    PurchaseOrderModel(
      poNumber: "PO-2024-001",
      supplier: "Global Logistics Corp",
      items: "0/150",
      date: "7/7/2026",
      status: "Pending",
      progress: 0.0,
      itemsList: [
        PurchaseOrderItemModel(
          sku: "SKU-1000",
          name: "Heavy Duty Pallet",
          expectedQty: 50,
        ),
        PurchaseOrderItemModel(
          sku: "SKU-1001",
          name: "Industrial Wrap",
          expectedQty: 100,
        ),
      ],
    ),
    PurchaseOrderModel(
      poNumber: "PO-2024-005",
      supplier: "Tech Supplies Ltd",
      items: "45/200",
      date: "6/7/2026",
      status: "Partial",
      progress: 0.225,
      itemsList: [
        PurchaseOrderItemModel(
          sku: "SKU-5001",
          name: "Ethernet Cables (10m)",
          expectedQty: 200,
          receivedQty: 45,
        ),
      ],
    ),
  ];

  Future<List<PurchaseOrderModel>> getPurchaseOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockPOs);
  }

  Future<void> addPurchaseOrder(PurchaseOrderModel po) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockPOs.insert(0, po);
  }

  Future<void> updatePurchaseOrder(PurchaseOrderModel updatedPo) async {
    final index = _mockPOs.indexWhere(
      (po) => po.poNumber == updatedPo.poNumber,
    );
    if (index != -1) {
      _mockPOs[index] = updatedPo;
    }
  }
}
