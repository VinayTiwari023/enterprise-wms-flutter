import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/inward_repository.dart';
import '../../../core/utils/base_view_model.dart';
import '../models/purchase_order_model.dart';

final inboundViewModelProvider = ChangeNotifierProvider.autoDispose((ref) {
  final repository = ref.watch(inwardRepositoryProvider);
  return InboundViewModel(repository: repository);
});

class InboundViewModel extends BaseViewModel {
  final InwardRepository _repository;
  List<PurchaseOrderModel> _purchaseOrders = [];

  InboundViewModel({required InwardRepository repository}) : _repository = repository {
    fetchPOs();
  }

  List<PurchaseOrderModel> get purchaseOrders => _purchaseOrders;

  Future<void> fetchPOs() async {
    setStatus(ViewStatus.loading);
    try {
      _purchaseOrders = await _repository.fetchPurchaseOrders();
      setStatus(ViewStatus.success);
    } catch (e) {
      setError(e.toString());
    }
  }
}
