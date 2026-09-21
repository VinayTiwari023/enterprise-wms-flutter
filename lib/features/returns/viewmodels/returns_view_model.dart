import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/return_order_model.dart';
import '../models/return_item_model.dart';
import '../repositories/returns_repository.dart';
import '../../../core/enums/view_status.dart';
import '../../inventory/viewmodels/inventory_view_model.dart';
import '../../dashboard/viewmodels/home_view_model.dart';

class ReturnsState {
  final List<ReturnOrderModel> returns;
  final ViewStatus status;
  final String? errorMessage;

  const ReturnsState({
    this.returns = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  ReturnsState copyWith({
    List<ReturnOrderModel>? returns,
    ViewStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReturnsState(
      returns: returns ?? this.returns,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ReturnsViewModel extends Notifier<ReturnsState> {
  @override
  ReturnsState build() {
    Future.microtask(() => fetchReturns());
    return const ReturnsState();
  }

  ReturnsRepository get _repository => ref.read(returnsRepositoryProvider);

  Future<void> fetchReturns() async {
    state = state.copyWith(status: ViewStatus.loading, clearError: true);
    try {
      final list = await _repository.fetchReturns();
      state = state.copyWith(returns: list, status: ViewStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateItemDisposition(
    String rmaNumber,
    String sku,
    String disposition,
    String condition,
    String? notes,
  ) async {
    final list = List<ReturnOrderModel>.from(state.returns);
    final index = list.indexWhere((r) => r.rmaNumber == rmaNumber);
    if (index == -1) return;

    final order = list[index];
    final items = List<ReturnItemModel>.from(order.items);
    final itemIndex = items.indexWhere((i) => i.sku == sku);
    if (itemIndex == -1) return;

    final updatedItem = items[itemIndex].copyWith(
      disposition: disposition,
      condition: condition,
      notes: notes,
    );
    items[itemIndex] = updatedItem;

    bool allInspected = items.every((i) => i.disposition != "Pending");
    String newStatus = allInspected ? "Inspected" : "Pending Inspection";

    list[index] = order.copyWith(items: items, status: newStatus);
    state = state.copyWith(returns: list);

    // If disposition is Restock to Bin, increase stock in inventory
    if (disposition == "Restock to Bin") {
      ref
          .read(inventoryViewModelProvider.notifier)
          .addOrUpdateStock(
            sku,
            updatedItem.name,
            "Aisle 1 - Returns Bin",
            updatedItem.quantity,
          );
    }

    ref
        .read(homeViewModelProvider.notifier)
        .addActivity("RMA $rmaNumber: $sku set to $disposition ($condition)");
  }

  Future<void> processReturn(String rmaNumber) async {
    final list = List<ReturnOrderModel>.from(state.returns);
    final index = list.indexWhere((r) => r.rmaNumber == rmaNumber);
    if (index == -1) return;

    list[index] = list[index].copyWith(status: "Processed");
    state = state.copyWith(returns: list);

    ref
        .read(homeViewModelProvider.notifier)
        .addActivity("Processed RMA $rmaNumber Disposition");
  }

  Future<void> createRMA({
    required String originalOrderNumber,
    required String customerName,
    required String returnReason,
    required List<ReturnItemModel> items,
  }) async {
    final rmaNo = "RMA-90${state.returns.length + 83}";
    final newReturn = ReturnOrderModel(
      rmaNumber: rmaNo,
      originalOrderNumber: originalOrderNumber,
      customerName: customerName,
      returnReason: returnReason,
      status: "Pending Inspection",
      date: DateTime.now(),
      items: items,
    );

    state = state.copyWith(returns: [newReturn, ...state.returns]);

    ref
        .read(homeViewModelProvider.notifier)
        .addActivity("Created RMA $rmaNo for $customerName");
  }
}

final returnsViewModelProvider =
    NotifierProvider<ReturnsViewModel, ReturnsState>(() {
      return ReturnsViewModel();
    });

final singleReturnProvider = Provider.family<ReturnOrderModel?, String>((
  ref,
  rmaNumber,
) {
  final list = ref.watch(returnsViewModelProvider.select((s) => s.returns));
  final index = list.indexWhere((r) => r.rmaNumber == rmaNumber);
  return index != -1 ? list[index] : null;
});
