import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/shipment_repository.dart';
import '../../../core/enums/view_status.dart';
import '../models/outbound_order_model.dart';

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
      state = state.copyWith(
        orders: orders,
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

/// Provider for the OutboundViewModel.
final outboundViewModelProvider = NotifierProvider<OutboundViewModel, OutboundState>(() {
  return OutboundViewModel();
});
