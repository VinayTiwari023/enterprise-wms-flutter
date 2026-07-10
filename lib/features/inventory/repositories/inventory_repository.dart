import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/base_api_service.dart';
import '../../../core/network/network_api_service.dart';
import '../../../app/config/env.dart';
import '../services/inventory_mock_service.dart';
import '../models/inventory_item_model.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return InventoryRepository(apiService: apiService, mockService: InventoryMockService());
});

class InventoryRepository {
  final BaseApiService _apiService;
  final InventoryMockService _mockService;

  InventoryRepository({
    required BaseApiService apiService,
    required InventoryMockService mockService,
  }) : _apiService = apiService, _mockService = mockService;

  Future<dynamic> fetchInventoryApi() async {
    try {
      dynamic response = await _apiService.getApiResponse(AppUrls.getInventory);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<InventoryItemModel>> fetchInventoryItems() async {
    return await _mockService.getInventoryItems();
  }
}
