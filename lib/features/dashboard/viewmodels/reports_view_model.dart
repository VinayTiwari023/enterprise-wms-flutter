import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/view_status.dart';
import '../repositories/dashboard_repository.dart';

/// Immutable state for the Reports screen.
class ReportsState {
  final List<Map<String, String>> recentReports;
  final ViewStatus status;
  final String? errorMessage;

  const ReportsState({
    this.recentReports = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  ReportsState copyWith({
    List<Map<String, String>>? recentReports,
    ViewStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReportsState(
      recentReports: recentReports ?? this.recentReports,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// AutoDisposeNotifier for the Reports screen.
/// Auto-disposed when the user leaves the screen to free up memory.
class ReportsViewModel extends AutoDisposeNotifier<ReportsState> {
  @override
  ReportsState build() {
    Future.microtask(() => fetchReports());
    return const ReportsState();
  }

  DashboardRepository get _repository => ref.read(dashboardRepositoryProvider);

  Future<void> fetchReports() async {
    state = state.copyWith(status: ViewStatus.loading, clearError: true);
    
    try {
      final reports = await _repository.fetchReports();
      state = state.copyWith(
        recentReports: reports,
        status: ViewStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

/// Provider for the ReportsViewModel.
final reportsViewModelProvider = AutoDisposeNotifierProvider<ReportsViewModel, ReportsState>(() {
  return ReportsViewModel();
});
