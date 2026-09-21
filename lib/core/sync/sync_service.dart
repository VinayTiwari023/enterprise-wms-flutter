import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncTransactionItem {
  final String id;
  final String actionName;
  final DateTime timestamp;

  const SyncTransactionItem({
    required this.id,
    required this.actionName,
    required this.timestamp,
  });
}

class SyncState {
  final bool isOfflineMode;
  final bool isSyncing;
  final List<SyncTransactionItem> pendingQueue;
  final DateTime? lastSyncTime;

  const SyncState({
    this.isOfflineMode = false,
    this.isSyncing = false,
    this.pendingQueue = const [],
    this.lastSyncTime,
  });

  SyncState copyWith({
    bool? isOfflineMode,
    bool? isSyncing,
    List<SyncTransactionItem>? pendingQueue,
    DateTime? lastSyncTime,
  }) {
    return SyncState(
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
      isSyncing: isSyncing ?? this.isSyncing,
      pendingQueue: pendingQueue ?? this.pendingQueue,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

class SyncViewModel extends Notifier<SyncState> {
  @override
  SyncState build() {
    return SyncState(
      lastSyncTime: DateTime.now().subtract(const Duration(minutes: 15)),
      pendingQueue: const [],
    );
  }

  void toggleOfflineMode() {
    bool nextMode = !state.isOfflineMode;
    state = state.copyWith(isOfflineMode: nextMode);

    if (!nextMode && state.pendingQueue.isNotEmpty) {
      // Auto trigger sync when going back online
      syncPendingTransactions();
    }
  }

  void queueTransaction(String actionName) {
    final list = List<SyncTransactionItem>.from(state.pendingQueue);
    list.add(
      SyncTransactionItem(
        id: "TX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
        actionName: actionName,
        timestamp: DateTime.now(),
      ),
    );
    state = state.copyWith(pendingQueue: list);
  }

  Future<void> syncPendingTransactions() async {
    if (state.pendingQueue.isEmpty) return;

    state = state.copyWith(isSyncing: true);
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(
      isSyncing: false,
      pendingQueue: const [],
      lastSyncTime: DateTime.now(),
    );
  }
}

final syncViewModelProvider = NotifierProvider<SyncViewModel, SyncState>(() {
  return SyncViewModel();
});
