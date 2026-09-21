import '../models/picklist_model.dart';
import '../models/picklist_item_model.dart';

class PicklistMockService {
  Future<List<PicklistModel>> getInitialPicklists() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      PicklistModel(
        id: "PL-2024-001",
        waveNumber: "WAVE-201",
        assignedPicker: "Rahul Sharma",
        status: "In Progress",
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        items: const [
          PicklistItemModel(
            sku: "SKU-9011",
            name: "Industrial Barcode Scanner",
            binLocation: "Aisle 1 - Rack A - Shelf 1",
            zone: "Zone A",
            requestedQty: 5,
            pickedQty: 5,
            orderReferences: ["ORD-1001", "ORD-1003"],
            isPicked: true,
          ),
          PicklistItemModel(
            sku: "SKU-9012",
            name: "Heavy-Duty Pallet Jack 2500kg",
            binLocation: "Aisle 1 - Rack C - Shelf 3",
            zone: "Zone A",
            requestedQty: 2,
            pickedQty: 0,
            orderReferences: ["ORD-1002"],
            isPicked: false,
          ),
          PicklistItemModel(
            sku: "SKU-9013",
            name: "Thermal Shipping Labels (Roll of 1000)",
            binLocation: "Aisle 2 - Rack B - Shelf 2",
            zone: "Zone B",
            requestedQty: 10,
            pickedQty: 0,
            orderReferences: ["ORD-1001", "ORD-1004"],
            isPicked: false,
          ),
          PicklistItemModel(
            sku: "SKU-9014",
            name: "Handheld Terminal Battery",
            binLocation: "Aisle 3 - Rack A - Shelf 4",
            zone: "Zone C",
            requestedQty: 4,
            pickedQty: 0,
            orderReferences: ["ORD-1003"],
            isPicked: false,
          ),
        ],
      ),
      PicklistModel(
        id: "PL-2024-002",
        waveNumber: "WAVE-202",
        assignedPicker: "Priya Patel",
        status: "Pending",
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        items: const [
          PicklistItemModel(
            sku: "SKU-9015",
            name: "Stretch Wrap Film 500mm",
            binLocation: "Aisle 2 - Rack D - Shelf 1",
            zone: "Zone B",
            requestedQty: 8,
            pickedQty: 0,
            orderReferences: ["ORD-1005", "ORD-1006"],
            isPicked: false,
          ),
          PicklistItemModel(
            sku: "SKU-9016",
            name: "Warehouse Safety Helmet",
            binLocation: "Aisle 4 - Rack B - Shelf 2",
            zone: "Zone D",
            requestedQty: 6,
            pickedQty: 0,
            orderReferences: ["ORD-1006"],
            isPicked: false,
          ),
        ],
      ),
      PicklistModel(
        id: "PL-2024-003",
        waveNumber: "WAVE-200",
        assignedPicker: "Amit Verma",
        status: "Completed",
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        items: const [
          PicklistItemModel(
            sku: "SKU-9011",
            name: "Industrial Barcode Scanner",
            binLocation: "Aisle 1 - Rack A - Shelf 1",
            zone: "Zone A",
            requestedQty: 3,
            pickedQty: 3,
            orderReferences: ["ORD-0998"],
            isPicked: true,
          ),
          PicklistItemModel(
            sku: "SKU-9017",
            name: "ESD Safety Gloves XL",
            binLocation: "Aisle 2 - Rack A - Shelf 3",
            zone: "Zone B",
            requestedQty: 12,
            pickedQty: 12,
            orderReferences: ["ORD-0998", "ORD-0999"],
            isPicked: true,
          ),
        ],
      ),
    ];
  }
}
