import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_service.dart';
import '../../features/settings/viewmodels/theme_view_model.dart';

class SyncBannerWidget extends ConsumerWidget {
  const SyncBannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncViewModelProvider);
    final syncVM = ref.read(syncViewModelProvider.notifier);
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    if (!syncState.isOfflineMode && syncState.pendingQueue.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      color: syncState.isOfflineMode ? Colors.amber.shade900 : primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            syncState.isOfflineMode
                ? Icons.wifi_off_rounded
                : Icons.sync_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              syncState.isOfflineMode
                  ? "Offline Mode — ${syncState.pendingQueue.length} Queue Item(s)"
                  : "Syncing ${syncState.pendingQueue.length} local transaction(s)...",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          if (syncState.isOfflineMode)
            TextButton(
              onPressed: () => syncVM.toggleOfflineMode(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 24),
              ),
              child: const Text(
                "Go Online",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            )
          else if (syncState.pendingQueue.isNotEmpty && !syncState.isSyncing)
            TextButton(
              onPressed: () => syncVM.syncPendingTransactions(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 24),
              ),
              child: const Text(
                "Sync Now",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
