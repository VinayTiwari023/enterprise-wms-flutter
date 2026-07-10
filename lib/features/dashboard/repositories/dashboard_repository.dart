import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/dashboard_mock_service.dart';
import '../models/dashboard_stats.dart';
import '../models/activity_model.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(mockService: DashboardMockService());
});

class DashboardRepository {
  final DashboardMockService _mockService;

  DashboardRepository({required DashboardMockService mockService}) : _mockService = mockService;

  Future<DashboardStats> fetchStats() async {
    return await _mockService.getDashboardStats();
  }

  Future<List<ActivityModel>> fetchActivities() async {
    return await _mockService.getRecentActivities();
  }

  Future<List<Map<String, String>>> fetchReports() async {
    return await _mockService.getRecentReports();
  }
}
