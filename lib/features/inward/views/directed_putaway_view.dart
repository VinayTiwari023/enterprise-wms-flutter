import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/putaway_view_model.dart';
import '../../../core/enums/view_status.dart';

class DirectedPutawayView extends ConsumerStatefulWidget {
  final String poNumber;

  const DirectedPutawayView({super.key, required this.poNumber});

  @override
  ConsumerState<DirectedPutawayView> createState() => _DirectedPutawayViewState();
}

class _DirectedPutawayViewState extends ConsumerState<DirectedPutawayView> {
  @override
  void initState() {
    super.initState();
    // Generate suggestions on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(putawayViewModelProvider.notifier).generateSuggestions(widget.poNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final putawayState = ref.watch(putawayViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("System Directed Putaway"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: putawayState.status == ViewStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : putawayState.status == ViewStatus.error
              ? Center(child: Text(putawayState.errorMessage ?? "Error"))
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Recommended Storage",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          Text(
                            "PO: ${widget.poNumber}",
                            style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: putawayState.suggestions.isEmpty
                            ? const Center(child: Text("No items to put away"))
                            : ListView.separated(
                                itemCount: putawayState.suggestions.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final item = putawayState.suggestions[index];
                                  return _buildDirectionCard(
                                    context,
                                    "${item.itemName} (${item.quantity} units)",
                                    item.suggestedBin,
                                    "${item.zone} - ${item.area}",
                                    primaryColor,
                                    item.isConfirmed,
                                    onTap: () => _simulateScan(item.sku, item.suggestedBin),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: Colors.orange),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Tap on a card to simulate scanning the Bin barcode.",
                                style: TextStyle(fontSize: 13, color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: ref.read(putawayViewModelProvider.notifier).allConfirmed
                              ? () {
                                  ref.read(putawayViewModelProvider.notifier).finalizePutaway();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Inventory Updated Successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context);
                                  Navigator.pop(context); // Go back to PO list
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Complete Putaway", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void _simulateScan(String sku, String bin) {
    // In a real app, this would open a camera scanner
    ref.read(putawayViewModelProvider.notifier).confirmPutaway(sku);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Confirmed Bin: $bin"),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildDirectionCard(
    BuildContext context,
    String item,
    String bin,
    String area,
    Color color,
    bool isConfirmed, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: isConfirmed ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isConfirmed ? Colors.green : Theme.of(context).colorScheme.outline,
            width: isConfirmed ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isConfirmed ? Colors.green : color).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isConfirmed ? Icons.check_circle_outline : Icons.location_on_outlined,
                color: isConfirmed ? Colors.green : color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: isConfirmed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    bin,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isConfirmed ? Colors.green : color,
                    ),
                  ),
                  Text(area, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (!isConfirmed) const Icon(Icons.qr_code_scanner_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
