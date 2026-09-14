import 'package:hive_flutter/hive_flutter.dart';
import '../../core/di/locator.dart';
import '../logger/app_logger.dart';
import '../storage/hive_service.dart';
import '../../features/inventory/models/inventory_item_model.dart';
import '../../features/purchase_order/models/purchase_order_model.dart';
import '../../features/purchase_order/models/purchase_order_item_model.dart';
import '../../features/shipment/models/outbound_order_model.dart';
import '../../features/shipment/models/outbound_order_item_model.dart';

class AppInitializer {
  static Future<void> initialize() async {
    // Logger configuration
    AppLogger.info("Initializing WMS Application...");

    // Dependency Injection
    setupLocator();

    // Initialize Hive
    await Hive.initFlutter();

    // Register Hive Adapters
    Hive.registerAdapter(InventoryItemModelAdapter());
    Hive.registerAdapter(PurchaseOrderModelAdapter());
    Hive.registerAdapter(PurchaseOrderItemModelAdapter());
    Hive.registerAdapter(OutboundOrderModelAdapter());
    Hive.registerAdapter(OutboundOrderItemModelAdapter());

    // Initialize Hive Boxes
    await locator<HiveService>().init();

    AppLogger.info("Hive initialized");

    // TODO: Load Environment
  }
}
