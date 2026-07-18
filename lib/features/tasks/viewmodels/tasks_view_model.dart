import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/view_status.dart';
import '../models/task_model.dart';
import '../services/tasks_mock_service.dart';

/// Immutable state for the Task Queue.
class TasksState {
  final List<TaskModel> allTasks;
  final List<TaskModel> filteredTasks;
  final String searchQuery;
  final String selectedFilter;
  final ViewStatus status;
  final String? errorMessage;

  const TasksState({
    this.allTasks = const [],
    this.filteredTasks = const [],
    this.searchQuery = "",
    this.selectedFilter = "All",
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  TasksState copyWith({
    List<TaskModel>? allTasks,
    List<TaskModel>? filteredTasks,
    String? searchQuery,
    String? selectedFilter,
    ViewStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TasksState(
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final tasksServiceProvider = Provider((ref) => TasksMockService());

/// AutoDisposeNotifier for Tasks.
/// Short-lived state that manages specialized search and filtering.
class TasksViewModel extends AutoDisposeNotifier<TasksState> {
  @override
  TasksState build() {
    Future.microtask(() => fetchTasks());
    return const TasksState();
  }

  TasksMockService get _service => ref.read(tasksServiceProvider);

  Future<void> fetchTasks() async {
    state = state.copyWith(status: ViewStatus.loading, clearError: true);
    try {
      final tasks = await _service.getTasks();
      state = state.copyWith(
        allTasks: tasks,
        status: ViewStatus.success,
      );
      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
    _applyFilters();
  }

  void _applyFilters() {
    final filtered = state.allTasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
                            task.id.toLowerCase().contains(state.searchQuery.toLowerCase());
      
      bool matchesFilter = true;
      if (state.selectedFilter == "High Priority") {
        matchesFilter = task.priority == TaskPriority.high;
      } else if (state.selectedFilter == "Pending") {
        matchesFilter = task.status == TaskStatus.pending;
      } else if (state.selectedFilter == "In Progress") {
        matchesFilter = task.status == TaskStatus.inProgress;
      }
      
      return matchesSearch && matchesFilter;
    }).toList();

    state = state.copyWith(filteredTasks: filtered);
  }
}

/// Provider for the TasksViewModel.
final tasksViewModelProvider = AutoDisposeNotifierProvider<TasksViewModel, TasksState>(() {
  return TasksViewModel();
});
