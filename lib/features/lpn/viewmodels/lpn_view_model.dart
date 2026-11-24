import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/view_status.dart';
import '../models/lpn_item_model.dart';
import '../models/lpn_model.dart';
import '../models/lpn_transfer_model.dart';
import '../repositories/lpn_repository.dart';

class LpnState {
  final List<LpnModel> lpns;
  final List<LpnTransferModel> transfers;
  final ViewStatus status;
  final String? errorMessage;

  const LpnState({
    this.lpns = const [],
    this.transfers = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  LpnState copyWith({
    List<LpnModel>? lpns,
    List<LpnTransferModel>? transfers,
    ViewStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LpnState(
      lpns: lpns ?? this.lpns,
      transfers: transfers ?? this.transfers,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class LpnViewModel extends Notifier<LpnState> {
  @override
  LpnState build() {
    Future.microtask(() => fetchLpns());
    return const LpnState();
  }

  LpnRepository get _repository => ref.read(lpnRepositoryProvider);

  Future<void> fetchLpns() async {
    state = state.copyWith(status: ViewStatus.loading, clearError: true);
    try {
      final lpns = await _repository.fetchLpns();
      final transfers = await _repository.fetchTransfers();
      state = state.copyWith(
        lpns: lpns,
        transfers: transfers,
        status: ViewStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Create a new LPN container / Pallet
  void createLpn({
    required String lpnNumber,
    required String location,
    required String containerType,
    required double maxWeightKg,
    required String createdBy,
    required List<LpnItemModel> initialItems,
  }) {
    final newLpn = LpnModel(
      lpnNumber: lpnNumber,
      location: location,
      containerType: containerType,
      status: location.contains("STAGING") ? "Staged" : "Putaway",
      maxWeightKg: maxWeightKg,
      currentWeightKg: initialItems.length * 25.0, // estimated initial weight
      items: initialItems,
      createdAt: DateTime.now(),
      createdBy: createdBy,
    );

    final updatedLpns = [newLpn, ...state.lpns];
    state = state.copyWith(lpns: updatedLpns);
  }

  /// Transfer an entire LPN container to a new Bin/Zone location
  bool moveLpn({
    required String lpnNumber,
    required String toLocation,
    required String operatorName,
  }) {
    final index = state.lpns.indexWhere(
      (l) => l.lpnNumber.toLowerCase() == lpnNumber.toLowerCase(),
    );

    if (index == -1) return false;

    final currentLpn = state.lpns[index];
    final fromLoc = currentLpn.location;

    final updatedLpn = currentLpn.copyWith(
      location: toLocation,
      status: toLocation.contains("STAGING")
          ? "Staged"
          : toLocation.contains("QUARANTINE")
          ? "Quarantine"
          : "Putaway",
    );

    final updatedLpns = List<LpnModel>.from(state.lpns);
    updatedLpns[index] = updatedLpn;

    // Record transfer log
    final newTransfer = LpnTransferModel(
      transferId:
          "TRF-LPN-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
      lpnNumber: currentLpn.lpnNumber,
      fromLocation: fromLoc,
      toLocation: toLocation,
      timestamp: DateTime.now(),
      transferredBy: operatorName,
      itemQty: currentLpn.totalItemCount,
    );

    final updatedTransfers = [newTransfer, ...state.transfers];

    state = state.copyWith(lpns: updatedLpns, transfers: updatedTransfers);
    return true;
  }

  /// Add an item SKU to an existing LPN Pallet
  void addItemToLpn(String lpnNumber, LpnItemModel newItem) {
    final index = state.lpns.indexWhere((l) => l.lpnNumber == lpnNumber);
    if (index == -1) return;

    final currentLpn = state.lpns[index];
    final currentItems = List<LpnItemModel>.from(currentLpn.items);

    final itemIndex = currentItems.indexWhere((i) => i.sku == newItem.sku);
    if (itemIndex != -1) {
      final existing = currentItems[itemIndex];
      currentItems[itemIndex] = existing.copyWith(
        quantity: existing.quantity + newItem.quantity,
      );
    } else {
      currentItems.add(newItem);
    }

    final updatedLpn = currentLpn.copyWith(items: currentItems);
    final updatedLpns = List<LpnModel>.from(state.lpns);
    updatedLpns[index] = updatedLpn;

    state = state.copyWith(lpns: updatedLpns);
  }

  /// Remove an item SKU from an LPN Pallet
  void removeItemFromLpn(String lpnNumber, String sku) {
    final index = state.lpns.indexWhere((l) => l.lpnNumber == lpnNumber);
    if (index == -1) return;

    final currentLpn = state.lpns[index];
    final updatedItems = currentLpn.items.where((i) => i.sku != sku).toList();

    final updatedLpn = currentLpn.copyWith(items: updatedItems);
    final updatedLpns = List<LpnModel>.from(state.lpns);
    updatedLpns[index] = updatedLpn;

    state = state.copyWith(lpns: updatedLpns);
  }
}

final lpnViewModelProvider = NotifierProvider<LpnViewModel, LpnState>(() {
  return LpnViewModel();
});

final lpnSearchQueryProvider = StateProvider<String>((ref) => "");

final filteredLpnProvider = Provider<List<LpnModel>>((ref) {
  final query = ref.watch(lpnSearchQueryProvider).toLowerCase();
  final lpns = ref.watch(lpnViewModelProvider.select((s) => s.lpns));

  if (query.isEmpty) return lpns;

  return lpns.where((lpn) {
    final matchLpn = lpn.lpnNumber.toLowerCase().contains(query);
    final matchLocation = lpn.location.toLowerCase().contains(query);
    final matchStatus = lpn.status.toLowerCase().contains(query);
    final matchContainer = lpn.containerType.toLowerCase().contains(query);
    final matchItems = lpn.items.any(
      (i) =>
          i.sku.toLowerCase().contains(query) ||
          i.itemName.toLowerCase().contains(query),
    );

    return matchLpn ||
        matchLocation ||
        matchStatus ||
        matchContainer ||
        matchItems;
  }).toList();
});

final singleLpnProvider = Provider.family<LpnModel?, String>((ref, lpnNumber) {
  final lpns = ref.watch(lpnViewModelProvider.select((s) => s.lpns));
  try {
    return lpns.firstWhere(
      (l) => l.lpnNumber.toLowerCase() == lpnNumber.toLowerCase(),
    );
  } catch (_) {
    return null;
  }
});
