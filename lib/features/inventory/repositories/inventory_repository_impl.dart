import '../../../core/network/base_api_service.dart';
import '../../../app/config/env.dart';
import '../services/inventory_mock_service.dart';
import '../models/inventory_item_model.dart';
import 'inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final BaseApiService _apiService;
  final InventoryMockService _mockService;

  InventoryRepositoryImpl({
    required BaseApiService apiService,
    required InventoryMockService mockService,
  }) : _apiService = apiService, _mockService = mockService;

  @override
  Future<dynamic> fetchInventoryApi() async {
    try {
      dynamic response = await _apiService.getApiResponse(AppUrls.getInventory);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<InventoryItemModel>> fetchInventoryItems() async {
    return await _mockService.getInventoryItems();
  }
}
