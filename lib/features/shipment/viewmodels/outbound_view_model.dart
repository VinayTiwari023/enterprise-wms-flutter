import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/shipment_repository.dart';
import '../../../core/utils/base_view_model.dart';
import '../models/outbound_order_model.dart';

final outboundViewModelProvider = ChangeNotifierProvider.autoDispose((ref) {
  final repository = ref.watch(shipmentRepositoryProvider);
  return OutboundViewModel(repository: repository);
});

class OutboundViewModel extends BaseViewModel {
  final ShipmentRepository _repository;
  List<OutboundOrderModel> _orders = [];

  OutboundViewModel({required ShipmentRepository repository}) : _repository = repository {
    fetchOrders();
  }

  List<OutboundOrderModel> get orders => _orders;

  Future<void> fetchOrders() async {
    setStatus(ViewStatus.loading);
    try {
      _orders = await _repository.fetchOutboundOrders();
      setStatus(ViewStatus.success);
    } catch (e) {
      setError(e.toString());
    }
  }
}
