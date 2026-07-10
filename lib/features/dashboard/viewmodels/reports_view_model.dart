import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/base_view_model.dart';
import '../repositories/dashboard_repository.dart';

final reportsViewModelProvider = ChangeNotifierProvider.autoDispose((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return ReportsViewModel(repository: repository);
});

class ReportsViewModel extends BaseViewModel {
  final DashboardRepository _repository;
  List<Map<String, String>> recentReports = [];

  ReportsViewModel({required DashboardRepository repository}) : _repository = repository {
    fetchReports();
  }

  Future<void> fetchReports() async {
    setStatus(ViewStatus.loading);
    try {
      recentReports = await _repository.fetchReports();
      setStatus(ViewStatus.success);
    } catch (e) {
      setError(e.toString());
    }
  }
}
