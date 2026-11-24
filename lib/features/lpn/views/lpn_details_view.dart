import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/route_names.dart';
import '../../printing/models/label_data.dart';
import '../../printing/views/label_printer_dialog.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../models/lpn_item_model.dart';
import '../viewmodels/lpn_view_model.dart';
import '../widgets/lpn_widgets.dart';

class LpnDetailsView extends ConsumerWidget {
  final String lpnNumber;

  const LpnDetailsView({super.key, required this.lpnNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final lpn = ref.watch(singleLpnProvider(lpnNumber));

    if (lpn == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Pallet Details")),
        body: const Center(child: Text("Pallet / LPN container not found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lpn.lpnNumber),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded),
            tooltip: "Print LPN Label",
            onPressed: () {
              LabelPrinterBottomSheet.show(
                context,
                LabelData(
                  type: LabelType.palletLPN,
                  title: "Pallet LPN Tag",
                  primaryCode: lpn.lpnNumber,
                  subTitle: lpn.containerType,
                  zoneOrLocation: lpn.location,
                  details:
                      "${lpn.totalItemCount} Units | ${lpn.currentWeightKg.toStringAsFixed(1)} kg",
                  quantity: 1,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container Header Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lpn.containerType,
                        style: const TextStyle(
                          fontSize: 16,
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
                          lpn.status,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Location: ${lpn.location}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        color: Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Created by: ${lpn.createdBy}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Created on: ${DateFormat('dd MMM yyyy, hh:mm a').format(lpn.createdAt)}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Weight capacity indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Weight Capacity Utilization",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${lpn.currentWeightKg.toStringAsFixed(1)} / ${lpn.maxWeightKg.toStringAsFixed(0)} kg",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (lpn.currentWeightKg / lpn.maxWeightKg).clamp(
                        0.0,
                        1.0,
                      ),
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        (lpn.currentWeightKg / lpn.maxWeightKg) > 0.9
                            ? Colors.red
                            : primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions Bar
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      context.pushNamed(
                        RouteNames.lpnTransfer,
                        queryParameters: {'lpnNumber': lpn.lpnNumber},
                      );
                    },
                    icon: const Icon(Icons.swap_horiz_rounded),
                    label: const Text("Relocate LPN"),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _showAddItemDialog(
                      context,
                      ref,
                      lpn.lpnNumber,
                      primaryColor,
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add Item SKU"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Items Content Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pallet Contents",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${lpn.totalItemCount} Total Units",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (lpn.items.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Pallet is currently empty. Tap 'Add Item SKU' to load goods.",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lpn.items.length,
                itemBuilder: (context, index) {
                  final item = lpn.items[index];
                  return LpnItemTile(
                    item: item,
                    onDelete: () {
                      ref
                          .read(lpnViewModelProvider.notifier)
                          .removeItemFromLpn(lpn.lpnNumber, item.sku);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Removed ${item.sku} from pallet."),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog(
    BuildContext context,
    WidgetRef ref,
    String lpnNumber,
    Color primaryColor,
  ) {
    final skuController = TextEditingController();
    final nameController = TextEditingController();
    final qtyController = TextEditingController(text: "10");
    final batchController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add SKU to Pallet"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: skuController,
                decoration: const InputDecoration(
                  labelText: "SKU Code (e.g. SKU-1010)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: batchController,
                decoration: const InputDecoration(
                  labelText: "Batch Number (Optional)",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (skuController.text.isEmpty || nameController.text.isEmpty) {
                return;
              }

              final item = LpnItemModel(
                sku: skuController.text.trim().toUpperCase(),
                itemName: nameController.text.trim(),
                quantity: int.tryParse(qtyController.text) ?? 1,
                batchNumber: batchController.text.trim().isEmpty
                    ? null
                    : batchController.text.trim(),
              );

              ref
                  .read(lpnViewModelProvider.notifier)
                  .addItemToLpn(lpnNumber, item);
              Navigator.pop(ctx);
            },
            child: const Text("Add to LPN"),
          ),
        ],
      ),
    );
  }
}
