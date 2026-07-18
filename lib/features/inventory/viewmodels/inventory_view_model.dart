import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/inventory_repository.dart';
import '../../../core/enums/view_status.dart';
import '../models/inventory_item_model.dart';

/// Immutable state for the Inventory screen.
class InventoryState {
  final List<InventoryItemModel> items;
  final ViewStatus status;
  final String? errorMessage;

  const InventoryState({
    this.items = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  InventoryState copyWith({
    List<InventoryItemModel>? items,
    ViewStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return InventoryState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Notifier-based ViewModel for Inventory management.
/// Using Notifier to maintain the inventory list in memory while navigating.
class InventoryViewModel extends Notifier<InventoryState> {
  @override
  InventoryState build() {
    Future.microtask(() => fetchItems());
    return const InventoryState();
  }

  InventoryRepository get _repository => ref.read(inventoryRepositoryProvider);

  Future<void> fetchItems() async {
    state = state.copyWith(status: ViewStatus.loading, clearError: true);
    
    try {
      final items = await _repository.fetchInventoryItems();
      state = state.copyWith(
        items: items,
        status: ViewStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

/// Provider for the InventoryViewModel.
final inventoryViewModelProvider = NotifierProvider<InventoryViewModel, InventoryState>(() {
  return InventoryViewModel();
});
