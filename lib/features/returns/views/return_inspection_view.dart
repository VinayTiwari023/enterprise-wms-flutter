import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/returns_view_model.dart';
import '../widgets/return_widgets.dart';

class ReturnInspectionView extends ConsumerWidget {
  final String rmaNumber;

  const ReturnInspectionView({super.key, required this.rmaNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final rma = ref.watch(singleReturnProvider(rmaNumber));

    if (rma == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("RMA Inspection")),
        body: const Center(child: Text("RMA Order not found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("RMA Inspection: ${rma.rmaNumber}"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rma.customerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        rma.status,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Original Order #: ${rma.originalOrderNumber} • Reason: ${rma.returnReason}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  "Total Returned Value: \$${rma.totalValue.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.fact_check_rounded, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "Item Inspection & Disposition",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  "${rma.items.length} Items",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: rma.items.length,
              itemBuilder: (context, index) {
                final item = rma.items[index];
                return ReturnInspectionTile(
                  item: item,
                  primaryColor: primaryColor,
                  onSaveInspection: (disposition, condition, notes) {
                    ref
                        .read(returnsViewModelProvider.notifier)
                        .updateItemDisposition(
                          rma.rmaNumber,
                          item.sku,
                          disposition,
                          condition,
                          notes,
                        );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: rma.status == "Processed"
                    ? null
                    : () {
                        ref
                            .read(returnsViewModelProvider.notifier)
                            .processReturn(rma.rmaNumber);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Return Processed & Dispositions Finalized!",
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      },
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: Text(
                  rma.status == "Processed"
                      ? "RMA Processed"
                      : "Finalize & Complete RMA Disposition",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
