import '../models/lpn_model.dart';
import '../models/lpn_item_model.dart';
import '../models/lpn_transfer_model.dart';

class LpnMockService {
  final List<LpnModel> _lpns = [
    LpnModel(
      lpnNumber: "LPN-MH-884920",
      location: "BIN-A01-R02",
      containerType: "Standard Wooden Pallet",
      status: "Putaway",
      maxWeightKg: 1000.0,
      currentWeightKg: 420.5,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      createdBy: "Vikram Sharma (Inbound Operator)",
      items: [
        LpnItemModel(
          sku: "SKU-1001",
          itemName: "Heavy Duty Industrial Bearings",
          quantity: 150,
          batchNumber: "BAT-2024-08A",
          expiryDate: DateTime.now().add(const Duration(days: 365)),
        ),
        LpnItemModel(
          sku: "SKU-1004",
          itemName: "Stainless Steel Fasteners (M8)",
          quantity: 500,
          batchNumber: "BAT-2024-09B",
        ),
      ],
    ),
    LpnModel(
      lpnNumber: "LPN-MH-884921",
      location: "STAGING-BAY-03",
      containerType: "Heavy Wire Tote Container",
      status: "Staged",
      maxWeightKg: 750.0,
      currentWeightKg: 280.0,
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      createdBy: "Anita Roy (Receiving Agent)",
      items: [
        LpnItemModel(
          sku: "SKU-1002",
          itemName: "Hydraulic Control Valves",
          quantity: 80,
          batchNumber: "BAT-2024-11C",
          expiryDate: DateTime.now().add(const Duration(days: 500)),
        ),
      ],
    ),
    LpnModel(
      lpnNumber: "LPN-MH-884922",
      location: "BIN-C04-R01",
      containerType: "Standard Wooden Pallet",
      status: "Putaway",
      maxWeightKg: 1000.0,
      currentWeightKg: 650.0,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      createdBy: "Rajesh Kumar (Warehouse Specialist)",
      items: [
        LpnItemModel(
          sku: "SKU-1005",
          itemName: "Industrial Grade LED Light Modules",
          quantity: 240,
          batchNumber: "BAT-2024-05X",
        ),
        LpnItemModel(
          sku: "SKU-1008",
          itemName: "Armored Conduit Pipes (2m)",
          quantity: 120,
          batchNumber: "BAT-2024-06Y",
        ),
      ],
    ),
    LpnModel(
      lpnNumber: "LPN-MH-884923",
      location: "QUARANTINE-ZONE-B",
      containerType: "Gaylord Box",
      status: "Quarantine",
      maxWeightKg: 500.0,
      currentWeightKg: 195.0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      createdBy: "Inspection Team",
      items: [
        LpnItemModel(
          sku: "SKU-1009",
          itemName: "Submersible Water Pumps (Damaged Packaging)",
          quantity: 15,
          batchNumber: "RMA-INSP-99",
        ),
      ],
    ),
  ];

  final List<LpnTransferModel> _transfers = [
    LpnTransferModel(
      transferId: "TRF-LPN-001",
      lpnNumber: "LPN-MH-884920",
      fromLocation: "RECEIVING-BAY-01",
      toLocation: "BIN-A01-R02",
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      transferredBy: "Vikram Sharma",
      itemQty: 650,
    ),
  ];

  Future<List<LpnModel>> fetchLpns() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<LpnModel>.from(_lpns);
  }

  Future<List<LpnTransferModel>> fetchTransfers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List<LpnTransferModel>.from(_transfers);
  }
}
