import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/outbound_view_model.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../models/outbound_order_model.dart';
import '../models/outbound_order_item_model.dart';

class PickingView extends ConsumerStatefulWidget {
  final String orderNumber;

  const PickingView({super.key, required this.orderNumber});

  @override
  ConsumerState<PickingView> createState() => _PickingViewState();
}

class _PickingViewState extends ConsumerState<PickingView> {
  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final order = ref.watch(outboundOrderProvider(widget.orderNumber));

    if (order == null) {
      return const Scaffold(body: Center(child: Text("Order not found")));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Picking: ${order.orderNumber}"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildOrderHeader(order, primaryColor),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: order.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return _buildPickingItemCard(context, item, primaryColor);
              },
            ),
          ),
          _buildActionFooter(order, primaryColor),
        ],
      ),
    );
  }

  Widget _buildOrderHeader(OutboundOrderModel order, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: color.withValues(alpha: 0.05),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Customer: ${order.customer}", style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(order.progressText, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: order.progress,
              minHeight: 8,
              backgroundColor: Colors.grey.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickingItemCard(BuildContext context, OutboundOrderItemModel item, Color color) {
    final isDone = item.isFullyPicked;
    return InkWell(
      onTap: isDone ? null : () => _simulatePick(item),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDone ? Colors.green : Theme.of(context).colorScheme.outline,
            width: isDone ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isDone ? Colors.green : color).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDone ? Icons.check : Icons.location_on_outlined,
                color: isDone ? Colors.green : color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, decoration: isDone ? TextDecoration.lineThrough : null)),
                  Text("Location: ${item.location}", style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.w900)),
                  Text("SKU: ${item.sku}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Pick Qty", style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text("${item.pickedQty}/${item.orderedQty}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionFooter(OutboundOrderModel order, Color color) {
    final canShip = order.progress >= 1.0 && order.status != "Shipped";
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: canShip ? () => _finalizeOrder(order) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Finalize & Ship", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _simulatePick(OutboundOrderItemModel item) {
    // Simulate scanning
    ref.read(outboundViewModelProvider.notifier).pickItem(widget.orderNumber, item.sku, item.orderedQty - item.pickedQty);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Picked: ${item.name}"), backgroundColor: Colors.green, duration: const Duration(seconds: 1)),
    );
  }

  void _finalizeOrder(OutboundOrderModel order) {
    ref.read(outboundViewModelProvider.notifier).shipOrder(widget.orderNumber);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order Shipped Successfully!"), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }
}
