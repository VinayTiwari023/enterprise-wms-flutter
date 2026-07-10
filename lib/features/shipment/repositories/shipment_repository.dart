import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/shipment_mock_service.dart';
import '../models/outbound_order_model.dart';

final shipmentRepositoryProvider = Provider<ShipmentRepository>((ref) {
  return ShipmentRepository(mockService: ShipmentMockService());
});

class ShipmentRepository {
  final ShipmentMockService _mockService;

  ShipmentRepository({required ShipmentMockService mockService}) : _mockService = mockService;

  Future<List<OutboundOrderModel>> fetchOutboundOrders() async {
    return await _mockService.getOutboundOrders();
  }
}
