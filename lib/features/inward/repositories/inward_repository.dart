import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/locator.dart';
import '../../../core/storage/hive_service.dart';
import '../services/inward_mock_service.dart';
import '../../purchase_order/models/purchase_order_model.dart';

final inwardRepositoryProvider = Provider<InwardRepository>((ref) {
  return locator<InwardRepository>();
});

class InwardRepository {
  final InwardMockService _mockService;
  final HiveService _hiveService;

  InwardRepository({
    required InwardMockService mockService,
    required HiveService hiveService,
  }) : _mockService = mockService,
       _hiveService = hiveService;

  Future<List<PurchaseOrderModel>> fetchPurchaseOrders() async {
    // Check local cache first
    final cached = _hiveService.getAll<PurchaseOrderModel>(
      HiveService.purchaseOrderBox,
    );
    if (cached.isNotEmpty) {
      return cached;
    }

    // If empty, get from mock and save to local
    final pos = await _mockService.getPurchaseOrders();
    for (var po in pos) {
      await _hiveService.putData(HiveService.purchaseOrderBox, po.poNumber, po);
    }
    return pos;
  }

  Future<void> addPurchaseOrder(PurchaseOrderModel po) async {
    // Update local cache
    await _hiveService.putData(HiveService.purchaseOrderBox, po.poNumber, po);
    // Update mock
    await _mockService.addPurchaseOrder(po);
  }

  Future<void> updatePurchaseOrder(PurchaseOrderModel po) async {
    await _hiveService.putData(HiveService.purchaseOrderBox, po.poNumber, po);
  }
}
