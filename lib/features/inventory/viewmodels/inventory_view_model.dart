import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/inventory_repository.dart';
import '../../../core/utils/base_view_model.dart';
import '../models/inventory_item_model.dart';

final inventoryViewModelProvider = ChangeNotifierProvider.autoDispose((ref) {
  final repository = ref.watch(inventoryRepositoryProvider);
  return InventoryViewModel(repository: repository);
});

class InventoryViewModel extends BaseViewModel {
  final InventoryRepository _repository;
  List<InventoryItemModel> _items = [];

  InventoryViewModel({required InventoryRepository repository}) : _repository = repository {
    fetchItems();
  }

  List<InventoryItemModel> get items => _items;

  Future<void> fetchItems() async {
    setStatus(ViewStatus.loading);
    try {
      _items = await _repository.fetchInventoryItems();
      setStatus(ViewStatus.success);
    } catch (e) {
      setError(e.toString());
    }
  }
}
