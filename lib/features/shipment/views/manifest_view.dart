import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/outbound_view_model.dart';
import '../../settings/viewmodels/theme_view_model.dart';

class ManifestView extends ConsumerWidget {
  const ManifestView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outboundState = ref.watch(outboundViewModelProvider);
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    // Filter for orders that are "Shipped" (or ready to be manifested)
    final manifestableOrders = outboundState.orders
        .where((o) => o.status == "Shipped")
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Shipping Manifest"),
        centerTitle: true,
      ),
      body: manifestableOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No orders ready for manifest",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Orders must be marked as 'Shipped' first.",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: primaryColor),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            "Found ${manifestableOrders.length} orders ready to be bundled into today's manifest.",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: manifestableOrders.length,
                    itemBuilder: (context, index) {
                      final order = manifestableOrders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.inventory_2_outlined),
                          ),
                          title: Text(
                            order.orderNumber,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(order.customer),
                          trailing: const Text(
                            "SHIPPED",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement PDF generation or API call
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Manifest generated successfully!"),
                        ),
                      );
                      context.pop();
                    },
                    icon: const Icon(Icons.print_rounded),
                    label: const Text("Generate & Print Manifest"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
