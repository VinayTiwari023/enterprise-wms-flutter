import '../models/return_order_model.dart';
import '../models/return_item_model.dart';

class ReturnsMockService {
  Future<List<ReturnOrderModel>> getInitialReturns() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      ReturnOrderModel(
        rmaNumber: "RMA-9081",
        originalOrderNumber: "ORD-1002",
        customerName: "Reliance Retail Logistics",
        returnReason: "Defective Item",
        status: "Pending Inspection",
        date: DateTime.now().subtract(const Duration(hours: 4)),
        items: const [
          ReturnItemModel(
            sku: "SKU-9011",
            name: "Industrial Barcode Scanner",
            quantity: 2,
            unitPrice: 299.99,
            condition: "Defective",
            disposition: "Pending",
          ),
          ReturnItemModel(
            sku: "SKU-9014",
            name: "Handheld Terminal Battery",
            quantity: 1,
            unitPrice: 45.00,
            condition: "Opened Good",
            disposition: "Pending",
          ),
        ],
      ),
      ReturnOrderModel(
        rmaNumber: "RMA-9082",
        originalOrderNumber: "ORD-1005",
        customerName: "Tata Digital Outlets",
        returnReason: "Wrong Item Shipped",
        status: "Inspected",
        date: DateTime.now().subtract(const Duration(days: 1)),
        items: const [
          ReturnItemModel(
            sku: "SKU-9015",
            name: "Stretch Wrap Film 500mm",
            quantity: 4,
            unitPrice: 24.50,
            condition: "New / Unopened",
            disposition: "Restock to Bin",
            notes: "Sealed boxes, safe for resale.",
          ),
        ],
      ),
      ReturnOrderModel(
        rmaNumber: "RMA-9080",
        originalOrderNumber: "ORD-0985",
        customerName: "Mahindra Auto Parts India",
        returnReason: "Carrier Damage",
        status: "Processed",
        date: DateTime.now().subtract(const Duration(days: 3)),
        items: const [
          ReturnItemModel(
            sku: "SKU-9013",
            name: "Thermal Shipping Labels",
            quantity: 5,
            unitPrice: 15.00,
            condition: "Damaged",
            disposition: "Scrap",
            notes: "Water damaged during transit.",
          ),
        ],
      ),
    ];
  }
}
