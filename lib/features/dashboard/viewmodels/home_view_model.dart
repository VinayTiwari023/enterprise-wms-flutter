import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/base_view_model.dart';
import '../repositories/dashboard_repository.dart';
import '../models/dashboard_stats.dart';
import '../models/activity_model.dart';

final homeViewModelProvider = ChangeNotifierProvider.autoDispose((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return HomeViewModel(repository: repository);
});

class HomeViewModel extends BaseViewModel {
  final DashboardRepository _repository;

  DashboardStats? stats;
  List<ActivityModel> recentActivities = [];

  HomeViewModel({required DashboardRepository repository}) : _repository = repository {
    refreshData();
  }

  Future<void> refreshData() async {
    setStatus(ViewStatus.loading);
    try {
      stats = await _repository.fetchStats();
      recentActivities = await _repository.fetchActivities();
      setStatus(ViewStatus.success);
    } catch (e) {
      setError(e.toString());
    }
  }
}
