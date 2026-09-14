import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/locator.dart';
import '../../../core/storage/hive_service.dart';
import '../services/shipment_mock_service.dart';
import '../models/outbound_order_model.dart';

final shipmentRepositoryProvider = Provider<ShipmentRepository>((ref) {
  return locator<ShipmentRepository>();
});

class ShipmentRepository {
  final ShipmentMockService _mockService;
  final HiveService _hiveService;

  ShipmentRepository({
    required ShipmentMockService mockService,
    required HiveService hiveService,
  }) : _mockService = mockService,
       _hiveService = hiveService;

  Future<List<OutboundOrderModel>> fetchOutboundOrders() async {
    // Check local cache first
    final cached = _hiveService.getAll<OutboundOrderModel>(
      HiveService.outboundOrderBox,
    );
    if (cached.isNotEmpty) {
      return cached;
    }

    // If empty, get from mock and save to local
    final orders = await _mockService.getOutboundOrders();
    for (var order in orders) {
      await _hiveService.putData(
        HiveService.outboundOrderBox,
        order.orderNumber,
        order,
      );
    }
    return orders;
  }

  Future<void> updateOrder(OutboundOrderModel order) async {
    // Update local cache
    await _hiveService.putData(
      HiveService.outboundOrderBox,
      order.orderNumber,
      order,
    );
    // Update mock (simulating remote update)
    await _mockService.updateOrder(order);
  }
}
