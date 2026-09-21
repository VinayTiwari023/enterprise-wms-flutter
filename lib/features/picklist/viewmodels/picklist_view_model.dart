import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/picklist_model.dart';
import '../models/picklist_item_model.dart';
import '../repositories/picklist_repository.dart';
import '../../../core/enums/view_status.dart';
import '../../inventory/viewmodels/inventory_view_model.dart';
import '../../dashboard/viewmodels/home_view_model.dart';

class PicklistState {
  final List<PicklistModel> picklists;
  final ViewStatus status;
  final String? errorMessage;

  const PicklistState({
    this.picklists = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  PicklistState copyWith({
    List<PicklistModel>? picklists,
    ViewStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PicklistState(
      picklists: picklists ?? this.picklists,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class PicklistViewModel extends Notifier<PicklistState> {
  @override
  PicklistState build() {
    Future.microtask(() => fetchPicklists());
    return const PicklistState();
  }

  PicklistRepository get _repository => ref.read(picklistRepositoryProvider);

  Future<void> fetchPicklists() async {
    state = state.copyWith(status: ViewStatus.loading, clearError: true);
    try {
      final list = await _repository.fetchPicklists();
      state = state.copyWith(picklists: list, status: ViewStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> pickItem(String picklistId, String sku, int quantity) async {
    final picklists = List<PicklistModel>.from(state.picklists);
    final plIndex = picklists.indexWhere((p) => p.id == picklistId);
    if (plIndex == -1) return;

    final picklist = picklists[plIndex];
    final items = List<PicklistItemModel>.from(picklist.items);
    final itemIndex = items.indexWhere((i) => i.sku == sku);
    if (itemIndex == -1) return;

    final item = items[itemIndex];
    final newPickedQty = item.pickedQty + quantity;
    final isFullyPicked = newPickedQty >= item.requestedQty;

    items[itemIndex] = item.copyWith(
      pickedQty: newPickedQty,
      isPicked: isFullyPicked,
    );

    double progress = items.where((i) => i.isPicked).length / items.length;
    String newStatus = progress >= 1.0 ? "Completed" : "In Progress";

    picklists[plIndex] = picklist.copyWith(items: items, status: newStatus);

    state = state.copyWith(picklists: picklists);

    // Deduct stock from Inventory ViewModel
    ref
        .read(inventoryViewModelProvider.notifier)
        .addOrUpdateStock(sku, item.name, item.binLocation, -quantity);

    // Activity log
    ref
        .read(homeViewModelProvider.notifier)
        .addActivity("Wave Picked $quantity x $sku for Picklist $picklistId");
  }

  Future<void> createWavePicklist() async {
    final newId = "PL-2024-00${state.picklists.length + 1}";
    final waveNo = "WAVE-20${state.picklists.length + 3}";

    final newPicklist = PicklistModel(
      id: newId,
      waveNumber: waveNo,
      assignedPicker: "Vinay Kumar",
      status: "Pending",
      createdAt: DateTime.now(),
      items: const [
        PicklistItemModel(
          sku: "SKU-9020",
          name: "Thermal Printer Ribbon 110mm",
          binLocation: "Aisle 1 - Rack B - Shelf 4",
          zone: "Zone A",
          requestedQty: 10,
          pickedQty: 0,
          orderReferences: ["ORD-1010", "ORD-1011"],
          isPicked: false,
        ),
        PicklistItemModel(
          sku: "SKU-9021",
          name: "Heavy-Duty Wooden Pallet Standard",
          binLocation: "Aisle 5 - Rack A - Shelf 1",
          zone: "Zone E",
          requestedQty: 4,
          pickedQty: 0,
          orderReferences: ["ORD-1012"],
          isPicked: false,
        ),
      ],
    );

    state = state.copyWith(picklists: [newPicklist, ...state.picklists]);

    ref
        .read(homeViewModelProvider.notifier)
        .addActivity("Generated Wave Picklist $waveNo ($newId)");
  }
}

final picklistViewModelProvider =
    NotifierProvider<PicklistViewModel, PicklistState>(() {
      return PicklistViewModel();
    });

final singlePicklistProvider = Provider.family<PicklistModel?, String>((
  ref,
  id,
) {
  final list = ref.watch(picklistViewModelProvider.select((s) => s.picklists));
  final index = list.indexWhere((p) => p.id == id);
  return index != -1 ? list[index] : null;
});
