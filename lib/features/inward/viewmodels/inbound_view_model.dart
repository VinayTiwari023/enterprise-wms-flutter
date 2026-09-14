import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/inward_repository.dart';
import '../../../core/enums/view_status.dart';
import '../../purchase_order/models/purchase_order_model.dart';
import '../../purchase_order/models/purchase_order_item_model.dart';
import '../../dashboard/viewmodels/home_view_model.dart';

/// Immutable state for Inbound operations.
class InboundState {
  final List<PurchaseOrderModel> purchaseOrders;
  final ViewStatus status;
  final String? errorMessage;

  const InboundState({
    this.purchaseOrders = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  InboundState copyWith({
    List<PurchaseOrderModel>? purchaseOrders,
    ViewStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return InboundState(
      purchaseOrders: purchaseOrders ?? this.purchaseOrders,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Notifier-based ViewModel for Inbound operations.
class InboundViewModel extends Notifier<InboundState> {
  @override
  InboundState build() {
    Future.microtask(() => fetchPOs());
    return const InboundState();
  }

  InwardRepository get _repository => ref.read(inwardRepositoryProvider);

  Future<void> fetchPOs() async {
    state = state.copyWith(status: ViewStatus.loading, clearError: true);

    try {
      final pos = await _repository.fetchPurchaseOrders();
      state = state.copyWith(purchaseOrders: pos, status: ViewStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> addPO(PurchaseOrderModel po) async {
    state = state.copyWith(status: ViewStatus.loading);
    try {
      await _repository.addPurchaseOrder(po);
      final updatedList = await _repository.fetchPurchaseOrders();
      state = state.copyWith(
        purchaseOrders: updatedList,
        status: ViewStatus.success,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> updateItemQuantity(
    String poNumber,
    String sku, {
    int received = 0,
    int damaged = 0,
    String? reason,
    String? imagePath,
  }) async {
    final pos = List<PurchaseOrderModel>.from(state.purchaseOrders);
    final poIndex = pos.indexWhere((p) => p.poNumber == poNumber);
    if (poIndex == -1) return;

    final po = pos[poIndex];
    final items = List<PurchaseOrderItemModel>.from(po.itemsList);
    final itemIndex = items.indexWhere((i) => i.sku == sku);
    if (itemIndex == -1) return;

    final item = items[itemIndex];
    items[itemIndex] = item.copyWith(
      receivedQty: item.receivedQty + received,
      damagedQty: item.damagedQty + damaged,
      damageReason: reason ?? item.damageReason,
      damageImagePath: imagePath ?? item.damageImagePath,
    );

    // Recalculate PO progress and summary
    int totalExpected = 0;
    int totalHandled = 0;
    for (var i in items) {
      totalExpected += i.expectedQty;
      totalHandled += (i.receivedQty + i.damagedQty + i.qcHoldQty);
    }
    double progress = totalExpected == 0 ? 0 : totalHandled / totalExpected;

    pos[poIndex] = po.copyWith(
      itemsList: items,
      items: "$totalHandled/$totalExpected", // Update summary string
      progress: progress,
      status: progress >= 1.0 ? "Completed" : "Partial",
    );

    state = state.copyWith(purchaseOrders: pos);

    // Persist to Hive
    await _repository.updatePurchaseOrder(pos[poIndex]);

    // Log Activity to Dashboard
    ref
        .read(homeViewModelProvider.notifier)
        .addActivity("Received $received units of $sku for $poNumber");
  }

  Future<void> receiveByLPN(String poNumber, String lpn) async {
    // Mock LPN logic: Receiving an LPN auto-fills some quantities
    final pos = List<PurchaseOrderModel>.from(state.purchaseOrders);
    final poIndex = pos.indexWhere((p) => p.poNumber == poNumber);
    if (poIndex == -1) return;

    final po = pos[poIndex];
    final items = po.itemsList.map((i) {
      int toAdd = (i.expectedQty * 0.5).toInt(); // Add 50% for mock
      return i.copyWith(receivedQty: i.receivedQty + toAdd);
    }).toList();

    // Recalculate summary
    int totalExpected = 0;
    int totalHandled = 0;
    for (var i in items) {
      totalExpected += i.expectedQty;
      totalHandled += (i.receivedQty + i.damagedQty + i.qcHoldQty);
    }

    pos[poIndex] = po.copyWith(
      itemsList: items,
      items: "$totalHandled/$totalExpected",
    );
    state = state.copyWith(purchaseOrders: pos);

    // Persist to Hive
    await _repository.updatePurchaseOrder(pos[poIndex]);
  }
}

/// Provider for the InboundViewModel.
final inboundViewModelProvider =
    NotifierProvider<InboundViewModel, InboundState>(() {
      return InboundViewModel();
    });

/// Provider for the search query to avoid full ViewModel rebuilds on every keystroke.
final inboundSearchQueryProvider = StateProvider<String>((ref) => "");

/// Provider for the filter index.
final inboundFilterIndexProvider = StateProvider<int>((ref) => 0);

/// Memoized provider for filtered Purchase Orders.
/// This prevents re-filtering on every build of the UI.
final filteredPurchaseOrdersProvider = Provider<List<PurchaseOrderModel>>((
  ref,
) {
  final allPOs = ref.watch(
    inboundViewModelProvider.select((s) => s.purchaseOrders),
  );
  final query = ref.watch(inboundSearchQueryProvider).toLowerCase();
  final filterIndex = ref.watch(inboundFilterIndexProvider);

  const filters = ["All", "Pending", "Partial", "Completed"];
  final filter = filters[filterIndex];

  return allPOs.where((po) {
    bool matchesFilter = filter == "All" || po.status == filter;
    bool matchesSearch =
        po.poNumber.toLowerCase().contains(query) ||
        po.supplier.toLowerCase().contains(query);
    return matchesFilter && matchesSearch;
  }).toList();
});

/// Granular provider for a specific Purchase Order.
/// This ensures PODetailsView only rebuilds when ITS specific PO changes.
final purchaseOrderProvider = Provider.family<PurchaseOrderModel?, String>((
  ref,
  poNumber,
) {
  final pos = ref.watch(
    inboundViewModelProvider.select((s) => s.purchaseOrders),
  );
  final index = pos.indexWhere((p) => p.poNumber == poNumber);
  return index != -1 ? pos[index] : null;
});
