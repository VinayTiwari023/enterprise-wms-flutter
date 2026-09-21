import 'package:hive_flutter/hive_flutter.dart';

/// A service that handles all Hive database operations.
class HiveService {
  /// Box names
  static const String inventoryBox = 'inventory_box';
  static const String purchaseOrderBox = 'purchase_order_box';
  static const String outboundOrderBox = 'outbound_order_box';
  static const String stockTransferBox = 'stock_transfer_box';

  /// Initializes all boxes needed for the app.
  Future<void> init() async {
    await Hive.openBox(inventoryBox);
    await Hive.openBox(purchaseOrderBox);
    await Hive.openBox(outboundOrderBox);
    await Hive.openBox(stockTransferBox);
  }

  /// Generic method to save data to a box.
  Future<void> putData<T>(String boxName, String key, T data) async {
    final box = Hive.box(boxName);
    await box.put(key, data);
  }

  /// Generic method to get data from a box.
  T? getData<T>(String boxName, String key) {
    final box = Hive.box(boxName);
    return box.get(key) as T?;
  }

  /// Generic method to get all values from a box.
  List<T> getAll<T>(String boxName) {
    final box = Hive.box(boxName);
    return box.values.cast<T>().toList();
  }

  /// Generic method to delete data from a box.
  Future<void> deleteData(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  /// Generic method to clear a box.
  Future<void> clearBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }
}
