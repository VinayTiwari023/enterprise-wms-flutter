import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/inbound_view_model.dart';
import 'directed_putaway_view.dart';

class GRNSummaryView extends ConsumerWidget {
  final String poNumber;

  const GRNSummaryView({super.key, required this.poNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = ref.watch(themeViewModelProvider);
    final inboundState = ref.watch(inboundViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    final po = inboundState.purchaseOrders.firstWhere((p) => p.poNumber == poNumber);
    int totalExpected = 0;
    int totalReceived = 0;
    int totalDamaged = 0;

    for (var item in po.itemsList) {
      totalExpected += item.expectedQty;
      totalReceived += item.receivedQty;
      totalDamaged += item.damagedQty;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("GRN Summary"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline_rounded, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              "Receiving Completed",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Goods Received Note (GRN) Generated",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            _buildSummaryCard(context, totalExpected, totalReceived, totalDamaged, primaryColor),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => DirectedPutawayView(poNumber: poNumber))
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Proceed to Putaway", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Return to Dashboard"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, int expected, int received, int damaged, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          _summaryRow("PO Number", poNumber),
          const Divider(height: 32),
          _summaryRow("Total Expected", "$expected"),
          const SizedBox(height: 16),
          _summaryRow("Good Units", "$received", valueColor: Colors.green),
          const SizedBox(height: 16),
          _summaryRow("Damaged Units", "$damaged", valueColor: Colors.redAccent),
          const Divider(height: 32),
          _summaryRow("Accuracy", "${((received + damaged) / expected * 100).toStringAsFixed(1)}%"),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }
}
