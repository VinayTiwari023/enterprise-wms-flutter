import '../models/dashboard_stats.dart';
import '../models/activity_model.dart';

class DashboardMockService {
  Future<DashboardStats> getDashboardStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DashboardStats(
      pendingCount: 12,
      completedCount: 45,
      inProgressCount: 8,
      alertsCount: 3,
    );
  }

  Future<List<ActivityModel>> getRecentActivities() async {
    return [
      ActivityModel(title: "Stock Updated - Item #0", time: "2 hours ago"),
      ActivityModel(title: "Stock Updated - Item #1", time: "2 hours ago"),
      ActivityModel(title: "Stock Updated - Item #2", time: "2 hours ago"),
    ];
  }

  Future<List<Map<String, String>>> getRecentReports() async {
    return [
      {"title": "Monthly Inventory Audit", "date": "Oct 20, 2023"},
      {"title": "Warehouse Utilization Report", "date": "Oct 19, 2023"},
      {"title": "Carrier Performance Analysis", "date": "Oct 18, 2023"},
    ];
  }
}
