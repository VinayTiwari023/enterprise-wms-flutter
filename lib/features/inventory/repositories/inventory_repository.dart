import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/locator.dart';
import '../models/inventory_item_model.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return locator<InventoryRepository>();
});

abstract class InventoryRepository {
  Future<dynamic> fetchInventoryApi();
  Future<List<InventoryItemModel>> fetchInventoryItems();
}
