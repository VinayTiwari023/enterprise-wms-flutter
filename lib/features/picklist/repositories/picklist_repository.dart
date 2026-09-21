import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/picklist_model.dart';
import '../services/picklist_mock_service.dart';
import '../../../core/di/locator.dart';

class PicklistRepository {
  final PicklistMockService _mockService;

  PicklistRepository({required PicklistMockService mockService})
    : _mockService = mockService;

  Future<List<PicklistModel>> fetchPicklists() async {
    return await _mockService.getInitialPicklists();
  }
}

final picklistRepositoryProvider = Provider<PicklistRepository>((ref) {
  return PicklistRepository(mockService: locator<PicklistMockService>());
});
