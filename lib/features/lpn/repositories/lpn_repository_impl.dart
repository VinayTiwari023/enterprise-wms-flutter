import '../models/lpn_model.dart';
import '../models/lpn_transfer_model.dart';
import '../services/lpn_mock_service.dart';
import 'lpn_repository.dart';

class LpnRepositoryImpl implements LpnRepository {
  final LpnMockService mockService;

  LpnRepositoryImpl({required this.mockService});

  @override
  Future<List<LpnModel>> fetchLpns() async {
    return await mockService.fetchLpns();
  }

  @override
  Future<List<LpnTransferModel>> fetchTransfers() async {
    return await mockService.fetchTransfers();
  }
}
