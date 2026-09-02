import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/audit_model.dart';
import '../../../core/enums/view_status.dart';
import '../../inventory/viewmodels/inventory_view_model.dart';
import '../../dashboard/viewmodels/home_view_model.dart';

class AuditState {
  final List<AuditModel> audits;
  final ViewStatus status;
  final String? errorMessage;

  const AuditState({
    this.audits = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  AuditState copyWith({
    List<AuditModel>? audits,
    ViewStatus? status,
    String? errorMessage,
  }) {
    return AuditState(
      audits: audits ?? this.audits,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuditViewModel extends Notifier<AuditState> {
  @override
  AuditState build() {
    Future.microtask(() => fetchAudits());
    return const AuditState();
  }

  void fetchAudits() {
    state = state.copyWith(status: ViewStatus.loading);

    // Mock Data
    final audits = [
      AuditModel(
        id: "ADT-001",
        title: "Weekly Zone A Count",
        zone: "Zone A",
        status: "Pending",
        dueDate: DateTime.now().add(const Duration(days: 1)),
        items: const [
          AuditItemModel(
            sku: "SKU-1000",
            itemName: "Heavy Duty Pallet",
            bin: "BIN-1000-A",
            systemQty: 45,
          ),
          AuditItemModel(
            sku: "SKU-1001",
            itemName: "Industrial Wrap",
            bin: "BIN-1001-B",
            systemQty: 12,
          ),
        ],
      ),
      AuditModel(
        id: "ADT-002",
        title: "Tech Supplies Audit",
        zone: "Zone B",
        status: "In-Progress",
        dueDate: DateTime.now(),
        items: const [
          AuditItemModel(
            sku: "SKU-5001",
            itemName: "Ethernet Cables",
            bin: "BIN-5001-A",
            systemQty: 150,
            countedQty: 148,
          ),
        ],
      ),
    ];

    state = state.copyWith(status: ViewStatus.success, audits: audits);
  }

  void updateCount(String auditId, String sku, int count) {
    final audits = List<AuditModel>.from(state.audits);
    final auditIndex = audits.indexWhere((a) => a.id == auditId);
    if (auditIndex == -1) return;

    final audit = audits[auditIndex];
    final items = List<AuditItemModel>.from(audit.items);
    final itemIndex = items.indexWhere((i) => i.sku == sku);
    if (itemIndex == -1) return;

    items[itemIndex] = items[itemIndex].copyWith(countedQty: count);

    audits[auditIndex] = audit.copyWith(items: items, status: "In-Progress");

    state = state.copyWith(audits: audits);
  }

  void finalizeAudit(String auditId) {
    final audits = List<AuditModel>.from(state.audits);
    final auditIndex = audits.indexWhere((a) => a.id == auditId);
    if (auditIndex == -1) return;

    final audit = audits[auditIndex];
    audits[auditIndex] = audit.copyWith(status: "Completed");

    state = state.copyWith(audits: audits);

    // For each item, update inventory if there is a variance
    for (var item in audit.items) {
      if (item.isCounted && item.variance != 0) {
        ref
            .read(inventoryViewModelProvider.notifier)
            .addOrUpdateStock(
              item.sku,
              item.itemName,
              item.bin,
              item.variance, // This will adjust the inventory to match the counted qty
            );

        ref
            .read(homeViewModelProvider.notifier)
            .addActivity(
              "Inventory adjusted for ${item.sku} in ${item.bin} (Variance: ${item.variance})",
            );
      }
    }

    ref
        .read(homeViewModelProvider.notifier)
        .addActivity("Cycle Count ${audit.id} Completed");
  }
}

final auditViewModelProvider = NotifierProvider<AuditViewModel, AuditState>(() {
  return AuditViewModel();
});

final auditProvider = Provider.family<AuditModel?, String>((ref, id) {
  final audits = ref.watch(auditViewModelProvider.select((s) => s.audits));
  final index = audits.indexWhere((a) => a.id == id);
  return index != -1 ? audits[index] : null;
});
