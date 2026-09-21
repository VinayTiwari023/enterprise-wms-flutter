import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/return_order_model.dart';
import '../services/returns_mock_service.dart';
import '../../../core/di/locator.dart';

class ReturnsRepository {
  final ReturnsMockService _mockService;

  ReturnsRepository({required ReturnsMockService mockService})
    : _mockService = mockService;

  Future<List<ReturnOrderModel>> fetchReturns() async {
    return await _mockService.getInitialReturns();
  }
}

final returnsRepositoryProvider = Provider<ReturnsRepository>((ref) {
  return ReturnsRepository(mockService: locator<ReturnsMockService>());
});
