import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/putaway_item_model.dart';
import '../viewmodels/inbound_view_model.dart';
import '../../inventory/viewmodels/inventory_view_model.dart';
import '../../dashboard/viewmodels/home_view_model.dart';
import '../../../core/enums/view_status.dart';

class PutawayState {
  final List<PutawayItemModel> suggestions;
  final ViewStatus status;
  final String? errorMessage;

  const PutawayState({
    this.suggestions = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  PutawayState copyWith({
    List<PutawayItemModel>? suggestions,
    ViewStatus? status,
    String? errorMessage,
  }) {
    return PutawayState(
      suggestions: suggestions ?? this.suggestions,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PutawayViewModel extends Notifier<PutawayState> {
  @override
  PutawayState build() => const PutawayState();

  void generateSuggestions(String poNumber) {
    state = state.copyWith(status: ViewStatus.loading);

    // Get the PO details from InboundViewModel using ref
    final po = ref.read(purchaseOrderProvider(poNumber));

    if (po == null) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: "Purchase Order not found",
      );
      return;
    }

    // Filter items that have been received but not yet put away
    final receivedItems = po.itemsList
        .where((item) => item.receivedQty > 0)
        .toList();

    if (receivedItems.isEmpty) {
      state = state.copyWith(status: ViewStatus.success, suggestions: []);
      return;
    }

    // Logic to generate suggested bins (MOCK)
    final suggestions = receivedItems.map((item) {
      final lastPart = item.sku.split('-').last;
      final skuNum = int.tryParse(lastPart) ?? 0;
      final isEven = skuNum % 2 == 0;

      return PutawayItemModel(
        sku: item.sku,
        itemName: item.name,
        suggestedBin: isEven ? "BIN-$lastPart-A" : "BIN-$lastPart-B",
        zone: isEven ? "Zone A" : "Zone B",
        area: isEven ? "Bulk Storage" : "Pick Area",
        quantity: item.receivedQty,
      );
    }).toList();

    state = state.copyWith(
      status: ViewStatus.success,
      suggestions: suggestions,
    );
  }

  void confirmPutaway(String sku) {
    final updatedSuggestions = state.suggestions.map((item) {
      if (item.sku == sku) {
        return item.copyWith(isConfirmed: true);
      }
      return item;
    }).toList();

    state = state.copyWith(suggestions: updatedSuggestions);
  }

  void finalizePutaway() {
    final confirmedItems = state.suggestions
        .where((i) => i.isConfirmed)
        .toList();

    // Update Inventory for each confirmed item
    for (var item in confirmedItems) {
      ref
          .read(inventoryViewModelProvider.notifier)
          .addOrUpdateStock(
            item.sku,
            item.itemName,
            item.suggestedBin,
            item.quantity,
          );

      // Log to dashboard
      ref
          .read(homeViewModelProvider.notifier)
          .addActivity(
            "Stored ${item.quantity}x ${item.sku} in ${item.suggestedBin}",
          );
    }

    // Clear suggestions as they are done
    state = const PutawayState(status: ViewStatus.success);
  }

  bool get allConfirmed =>
      state.suggestions.isNotEmpty &&
      state.suggestions.every((item) => item.isConfirmed);
}

final putawayViewModelProvider =
    NotifierProvider<PutawayViewModel, PutawayState>(() {
      return PutawayViewModel();
    });
