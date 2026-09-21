import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/picklist_view_model.dart';
import '../widgets/picklist_widgets.dart';

class PicklistDetailsView extends ConsumerWidget {
  final String picklistId;

  const PicklistDetailsView({super.key, required this.picklistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final picklist = ref.watch(singlePicklistProvider(picklistId));

    if (picklist == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Picklist Details")),
        body: const Center(child: Text("Picklist not found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(picklist.waveNumber), centerTitle: true),
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
                      "Wave Pick List: ${picklist.id}",
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
                        picklist.status,
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
                    const Icon(Icons.person, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      "Assigned: ${picklist.assignedPicker}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      "${picklist.totalPickedQty}/${picklist.totalRequestedQty} Items",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: picklist.progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      picklist.progress >= 1.0 ? Colors.green : primaryColor,
                    ),
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
                const Icon(Icons.alt_route_rounded, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "Sequential Route Stops",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  "${picklist.items.length} Stops",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: picklist.items.length,
              itemBuilder: (context, index) {
                final item = picklist.items[index];
                return GuidedPickTile(
                  item: item,
                  stepIndex: index + 1,
                  primaryColor: primaryColor,
                  onPick: () async {
                    final qtyController = TextEditingController(
                      text: "${item.requestedQty - item.pickedQty}",
                    );
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Pick SKU: ${item.sku}"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Location: ${item.binLocation}"),
                            const SizedBox(height: 12),
                            TextField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Picked Quantity",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text("Confirm"),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      final qty = int.tryParse(qtyController.text) ?? 1;
                      ref
                          .read(picklistViewModelProvider.notifier)
                          .pickItem(picklist.id, item.sku, qty);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
