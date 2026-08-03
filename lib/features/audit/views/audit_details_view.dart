import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/audit_view_model.dart';
import '../../settings/viewmodels/theme_view_model.dart';

class AuditDetailsView extends ConsumerWidget {
  final String auditId;

  const AuditDetailsView({super.key, required this.auditId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audit = ref.watch(auditProvider(auditId));
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    if (audit == null) return const Scaffold(body: Center(child: Text("Audit not found")));

    return Scaffold(
      appBar: AppBar(
        title: Text(audit.id),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: primaryColor.withValues(alpha: 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(audit.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Zone: ${audit.zone}", style: TextStyle(color: primaryColor)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: audit.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = audit.items[index];
                return _buildCountItemCard(context, item, primaryColor, ref);
              },
            ),
          ),
          _buildActionFooter(context, audit, primaryColor, ref),
        ],
      ),
    );
  }

  Widget _buildCountItemCard(BuildContext context, item, Color color, WidgetRef ref) {
    final isDone = item.isCounted;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDone ? Colors.green : Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(Icons.inventory_2_outlined, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Bin: ${item.bin}", style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w900)),
                    Text("SKU: ${item.sku}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              if (isDone)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(item.variance == 0 ? "Perfect" : "Variance: ${item.variance}", 
                         style: TextStyle(color: item.variance == 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                    Text("Counted: ${item.countedQty}", style: const TextStyle(fontSize: 12)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (!isDone)
            Row(
              children: [
                const Expanded(child: Text("Enter actual count found in bin:")),
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Qty", border: OutlineInputBorder()),
                    onSubmitted: (val) {
                      final count = int.tryParse(val);
                      if (count != null) {
                        ref.read(auditViewModelProvider.notifier).updateCount(auditId, item.sku, count);
                      }
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionFooter(BuildContext context, audit, Color color, WidgetRef ref) {
    final allCounted = audit.items.every((i) => i.isCounted);
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: allCounted ? () {
            ref.read(auditViewModelProvider.notifier).finalizeAudit(auditId);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Audit Completed and Inventory Adjusted"), backgroundColor: Colors.green));
            Navigator.pop(context);
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Finalize Audit", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
