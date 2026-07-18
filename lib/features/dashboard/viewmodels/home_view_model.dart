import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/view_status.dart';
import '../../../core/error/exceptions.dart';
import '../../authentication/viewmodels/user_view_model.dart';
import '../repositories/dashboard_repository.dart';
import '../models/dashboard_stats.dart';
import '../models/activity_model.dart';

/// Immutable state for the Dashboard/Home screen.
class HomeState {
  final DashboardStats? stats;
  final List<ActivityModel> recentActivities;
  final ViewStatus status;
  final String? errorMessage;

  const HomeState({
    this.stats,
    this.recentActivities = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  HomeState copyWith({
    DashboardStats? stats,
    List<ActivityModel>? recentActivities,
    ViewStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      stats: stats ?? this.stats,
      recentActivities: recentActivities ?? this.recentActivities,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Notifier-based ViewModel for the Home Dashboard.
/// We use Notifier instead of AutoDisposeNotifier because this is a primary landing screen.
class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    // Trigger initial data fetch on initialization
    Future.microtask(() => refreshData());
    return const HomeState();
  }

  DashboardRepository get _repository => ref.read(dashboardRepositoryProvider);

  Future<void> refreshData() async {
    state = state.copyWith(status: ViewStatus.loading, clearError: true);
    
    try {
      // Parallel fetch for better performance
      final results = await Future.wait([
        _repository.fetchStats(),
        _repository.fetchActivities(),
      ]);

      state = state.copyWith(
        stats: results[0] as DashboardStats,
        recentActivities: results[1] as List<ActivityModel>,
        status: ViewStatus.success,
      );
    } on UnauthorizedException {
      // Auto-logout on session expiry
      ref.read(userViewModelProvider.notifier).logout();
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains('Unauthorized')) {
        ref.read(userViewModelProvider.notifier).logout();
      } else {
        state = state.copyWith(
          status: ViewStatus.error,
          errorMessage: errorMsg,
        );
      }
    }
  }
}

/// Provider for the HomeViewModel.
final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
