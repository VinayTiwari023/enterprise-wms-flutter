import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/shipment_repository.dart';
import '../../../core/enums/view_status.dart';
import '../models/outbound_order_model.dart';
import '../models/outbound_order_item_model.dart';
import '../../inventory/viewmodels/inventory_view_model.dart';
import '../../dashboard/viewmodels/home_view_model.dart';

/// Immutable state for Outbound operations.
class OutboundState {
  final List<OutboundOrderModel> orders;
  final ViewStatus status;
  final String? errorMessage;

  const OutboundState({
    this.orders = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  OutboundState copyWith({
    List<OutboundOrderModel>? orders,
    ViewStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OutboundState(
      orders: orders ?? this.orders,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Notifier-based ViewModel for Outbound (Shipment) operations.
class OutboundViewModel extends Notifier<OutboundState> {
  @override
  OutboundState build() {
    Future.microtask(() => fetchOrders());
    return const OutboundState();
  }

  ShipmentRepository get _repository => ref.read(shipmentRepositoryProvider);

  Future<void> fetchOrders() async {
    state = state.copyWith(status: ViewStatus.loading, clearError: true);

    try {
      final orders = await _repository.fetchOutboundOrders();
      state = state.copyWith(orders: orders, status: ViewStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> pickItem(String orderNumber, String sku, int quantity) async {
    final orders = List<OutboundOrderModel>.from(state.orders);
    final orderIndex = orders.indexWhere((o) => o.orderNumber == orderNumber);
    if (orderIndex == -1) return;

    final order = orders[orderIndex];
    final items = List<OutboundOrderItemModel>.from(order.items);
    final itemIndex = items.indexWhere((i) => i.sku == sku);
    if (itemIndex == -1) return;

    final item = items[itemIndex];
    items[itemIndex] = item.copyWith(pickedQty: item.pickedQty + quantity);

    double progress = order.progress;
    String newStatus = progress >= 1.0 ? "Picked" : "Picking";

    orders[orderIndex] = order.copyWith(items: items, status: newStatus);

    state = state.copyWith(orders: orders);

    // Update Inventory: Deduct stock
    ref
        .read(inventoryViewModelProvider.notifier)
        .addOrUpdateStock(
          sku,
          item.name,
          item.location,
          -quantity, // Negative to deduct
        );

    // Log activity
    ref
        .read(homeViewModelProvider.notifier)
        .addActivity("Picked $quantity units of $sku for $orderNumber");
  }

  Future<void> shipOrder(String orderNumber) async {
    final orders = List<OutboundOrderModel>.from(state.orders);
    final orderIndex = orders.indexWhere((o) => o.orderNumber == orderNumber);
    if (orderIndex == -1) return;

    orders[orderIndex] = orders[orderIndex].copyWith(status: "Shipped");
    state = state.copyWith(orders: orders);

    // Log activity
    ref
        .read(homeViewModelProvider.notifier)
        .addActivity("Order $orderNumber Shipped");
  }
}

/// Provider for the OutboundViewModel.
final outboundViewModelProvider =
    NotifierProvider<OutboundViewModel, OutboundState>(() {
      return OutboundViewModel();
    });

/// Provider for a specific Outbound Order.
final outboundOrderProvider = Provider.family<OutboundOrderModel?, String>((
  ref,
  orderNumber,
) {
  final orders = ref.watch(outboundViewModelProvider.select((s) => s.orders));
  final index = orders.indexWhere((o) => o.orderNumber == orderNumber);
  return index != -1 ? orders[index] : null;
});
