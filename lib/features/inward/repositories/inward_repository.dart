import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/inward_mock_service.dart';
import '../models/purchase_order_model.dart';

final inwardRepositoryProvider = Provider<InwardRepository>((ref) {
  return InwardRepository(mockService: InwardMockService());
});

class InwardRepository {
  final InwardMockService _mockService;

  InwardRepository({required InwardMockService mockService}) : _mockService = mockService;

  Future<List<PurchaseOrderModel>> fetchPurchaseOrders() async {
    return await _mockService.getPurchaseOrders();
  }
}
