import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/locator.dart';
import '../models/lpn_model.dart';
import '../models/lpn_transfer_model.dart';

final lpnRepositoryProvider = Provider<LpnRepository>((ref) {
  return locator<LpnRepository>();
});

abstract class LpnRepository {
  Future<List<LpnModel>> fetchLpns();
  Future<List<LpnTransferModel>> fetchTransfers();
}
