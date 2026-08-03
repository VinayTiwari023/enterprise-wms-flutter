import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/view_status.dart';
import '../../inward/viewmodels/inbound_view_model.dart';
import '../../inventory/viewmodels/inventory_view_model.dart';
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
class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    // Watch relevant providers to trigger re-calculation when data changes
    final inboundState = ref.watch(inboundViewModelProvider);
    final inventoryState = ref.watch(inventoryViewModelProvider);

    // Initial load of repository data
    Future.microtask(() => _fetchInitialData());

    return _calculateDynamicState(inboundState, inventoryState);
  }

  DashboardRepository get _repository => ref.read(dashboardRepositoryProvider);

  Future<void> _fetchInitialData() async {
    if (state.status == ViewStatus.loading) return;
    
    try {
      final activities = await _repository.fetchActivities();
      state = state.copyWith(
        recentActivities: activities,
        status: ViewStatus.success,
      );
    } catch (e) {
       // Silent error for background fetch
    }
  }

  HomeState _calculateDynamicState(InboundState inbound, InventoryState inventory) {
    // Calculate stats based on Inbound POs
    int pending = inbound.purchaseOrders.where((po) => po.status == "Pending").length;
    int partial = inbound.purchaseOrders.where((po) => po.status == "Partial").length;
    int completed = inbound.purchaseOrders.where((po) => po.status == "Completed").length;
    
    // Alerts could be low stock or overdue POs (mock logic)
    int alerts = inventory.items.where((i) => i.units < 10).length;

    final dynamicStats = DashboardStats(
      pendingCount: pending,
      completedCount: completed,
      inProgressCount: partial,
      alertsCount: alerts,
    );

    return HomeState(
      stats: dynamicStats,
      recentActivities: state.recentActivities,
      status: state.status,
    );
  }

  void addActivity(String title) {
    final now = DateTime.now();
    final timeStr = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
    
    final newActivity = ActivityModel(title: title, time: timeStr);
    final updatedActivities = [newActivity, ...state.recentActivities];
    
    state = state.copyWith(recentActivities: updatedActivities.take(10).toList());
  }

  Future<void> refreshData() async {
    state = state.copyWith(status: ViewStatus.loading);
    await _fetchInitialData();
  }
}

/// Provider for the HomeViewModel.
final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
