import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/view_status.dart';
import '../models/inventory_item_model.dart';
import '../models/stock_transfer_model.dart';
import '../repositories/inventory_repository.dart';
import 'inventory_view_model.dart';

class StockTransferState {
  final InventoryItemModel? selectedItem;
  final String fromLocation;
  final String toLocation;
  final int quantity;
  final String reason;
  final ViewStatus status;
  final String? errorMessage;
  final String? successMessage;
  final List<StockTransferModel> history;

  const StockTransferState({
    this.selectedItem,
    this.fromLocation = '',
    this.toLocation = '',
    this.quantity = 1,
    this.reason = 'Bin Consolidation',
    this.status = ViewStatus.idle,
    this.errorMessage,
    this.successMessage,
    this.history = const [],
  });

  StockTransferState copyWith({
    InventoryItemModel? selectedItem,
    String? fromLocation,
    String? toLocation,
    int? quantity,
    String? reason,
    ViewStatus? status,
    String? errorMessage,
    String? successMessage,
    List<StockTransferModel>? history,
    bool clearSelectedItem = false,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return StockTransferState(
      selectedItem: clearSelectedItem
          ? null
          : (selectedItem ?? this.selectedItem),
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      quantity: quantity ?? this.quantity,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
      history: history ?? this.history,
    );
  }
}

class StockTransferViewModel extends Notifier<StockTransferState> {
  @override
  StockTransferState build() {
    Future.microtask(() => loadHistory());
    return const StockTransferState();
  }

  InventoryRepository get _repository => ref.read(inventoryRepositoryProvider);

  Future<void> loadHistory() async {
    try {
      final list = await _repository.fetchTransferHistory();
      state = state.copyWith(history: list);
    } catch (_) {}
  }

  void selectItem(InventoryItemModel item) {
    state = state.copyWith(
      selectedItem: item,
      fromLocation: item.location,
      quantity: 1,
      clearError: true,
      clearSuccess: true,
    );
  }

  void setFromLocation(String loc) {
    state = state.copyWith(fromLocation: loc, clearError: true);
  }

  void setToLocation(String loc) {
    state = state.copyWith(toLocation: loc.toUpperCase(), clearError: true);
  }

  void setQuantity(int q) {
    state = state.copyWith(quantity: q, clearError: true);
  }

  void setReason(String r) {
    state = state.copyWith(reason: r, clearError: true);
  }

  Future<bool> executeTransfer(String operatorName) async {
    final item = state.selectedItem;
    if (item == null) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: "Please select an item to transfer.",
      );
      return false;
    }

    if (state.fromLocation.trim().isEmpty) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: "Source location is required.",
      );
      return false;
    }

    if (state.toLocation.trim().isEmpty) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: "Destination bin location is required.",
      );
      return false;
    }

    if (state.fromLocation.trim().toUpperCase() ==
        state.toLocation.trim().toUpperCase()) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: "Source and Destination bins cannot be the same.",
      );
      return false;
    }

    if (state.quantity <= 0) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: "Transfer quantity must be greater than 0.",
      );
      return false;
    }

    if (state.quantity > item.units) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage:
            "Transfer quantity exceeds available stock (${item.units} units).",
      );
      return false;
    }

    state = state.copyWith(
      status: ViewStatus.loading,
      clearError: true,
      clearSuccess: true,
    );

    try {
      final now = DateTime.now();
      final transferId =
          "TRF-${now.millisecondsSinceEpoch.toString().substring(5)}";

      final record = StockTransferModel(
        id: transferId,
        sku: item.sku,
        itemName: item.name,
        fromLocation: state.fromLocation.trim().toUpperCase(),
        toLocation: state.toLocation.trim().toUpperCase(),
        quantity: state.quantity,
        timestamp: now,
        transferredBy: operatorName,
        status: "Completed",
        reason: state.reason,
      );

      // Save transfer record
      await _repository.saveStockTransfer(record);

      // Update source & target stock in InventoryViewModel
      final invVM = ref.read(inventoryViewModelProvider.notifier);
      invVM.addOrUpdateStock(
        item.sku,
        item.name,
        state.fromLocation.trim().toUpperCase(),
        -state.quantity,
      );
      invVM.addOrUpdateStock(
        item.sku,
        item.name,
        state.toLocation.trim().toUpperCase(),
        state.quantity,
      );

      // Reload history
      final updatedHistory = await _repository.fetchTransferHistory();

      state = state.copyWith(
        status: ViewStatus.success,
        successMessage:
            "Transferred ${state.quantity} units of ${item.name} to Bin ${state.toLocation.toUpperCase()}.",
        history: updatedHistory,
        clearSelectedItem: true,
        toLocation: '',
        quantity: 1,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: "Failed to process transfer: ${e.toString()}",
      );
      return false;
    }
  }
}

final stockTransferViewModelProvider =
    NotifierProvider<StockTransferViewModel, StockTransferState>(() {
      return StockTransferViewModel();
    });
