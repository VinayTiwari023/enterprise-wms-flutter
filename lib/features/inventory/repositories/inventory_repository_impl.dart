import '../../../core/network/base_api_service.dart';
import '../../../core/storage/hive_service.dart';
import '../../../app/config/env.dart';
import '../services/inventory_mock_service.dart';
import '../models/inventory_item_model.dart';
import '../models/stock_transfer_model.dart';
import 'inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final BaseApiService _apiService;
  final InventoryMockService _mockService;
  final HiveService _hiveService;

  InventoryRepositoryImpl({
    required BaseApiService apiService,
    required InventoryMockService mockService,
    required HiveService hiveService,
  }) : _apiService = apiService,
       _mockService = mockService,
       _hiveService = hiveService;

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
    // Check local cache first
    final cached = _hiveService.getAll<InventoryItemModel>(
      HiveService.inventoryBox,
    );
    if (cached.isNotEmpty) {
      return cached;
    }

    // If empty, get from mock/remote and save to local
    final items = await _mockService.getInventoryItems();
    for (var item in items) {
      await _hiveService.putData(HiveService.inventoryBox, item.sku, item);
    }
    return items;
  }

  @override
  Future<void> saveItem(InventoryItemModel item) async {
    await _hiveService.putData(HiveService.inventoryBox, item.sku, item);
  }

  @override
  Future<List<StockTransferModel>> fetchTransferHistory() async {
    final rawList = _hiveService.getAll<dynamic>(HiveService.stockTransferBox);
    final history = <StockTransferModel>[];
    for (var e in rawList) {
      if (e is Map) {
        history.add(StockTransferModel.fromJson(Map<String, dynamic>.from(e)));
      }
    }
    history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return history;
  }

  @override
  Future<void> saveStockTransfer(StockTransferModel transfer) async {
    await _hiveService.putData(
      HiveService.stockTransferBox,
      transfer.id,
      transfer.toJson(),
    );
  }
}
