import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/inward_repository.dart';
import '../../../core/enums/view_status.dart';
import '../models/purchase_order_model.dart';

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
      state = state.copyWith(
        purchaseOrders: pos,
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

/// Provider for the InboundViewModel.
final inboundViewModelProvider = NotifierProvider<InboundViewModel, InboundState>(() {
  return InboundViewModel();
});
