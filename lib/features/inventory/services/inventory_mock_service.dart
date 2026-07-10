import '../models/inventory_item_model.dart';

class InventoryMockService {
  Future<List<InventoryItemModel>> getInventoryItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(10, (index) => InventoryItemModel(
      name: "Item Name $index",
      sku: "SKU-100$index",
      location: "Bin-A$index",
      units: (index + 1) * 5,
      status: (index + 1) * 5 < 10 ? "Low Stock" : "In Stock",
    ));
  }
}
