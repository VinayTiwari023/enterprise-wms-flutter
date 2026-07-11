import 'package:flutter/material.dart';
import '../models/outbound_order_model.dart';

class OrderCard extends StatelessWidget {
  final OutboundOrderModel order;
  final Color primaryColor;

  const OrderCard({
    super.key,
    required this.order,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (order.status) {
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Picking':
        statusColor = Colors.deepPurpleAccent;
        break;
      case 'Shipped':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            order.customer,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          const SizedBox(height: 15),
          const Divider(height: 1),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Picking Progress", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  Text(order.progressText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Ship Date", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  Text(order.date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: order.progress,
              backgroundColor: Colors.grey.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(order.progress == 1.0 ? Colors.green : primaryColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class ManifestButton extends StatelessWidget {
  final Color primaryColor;
  final VoidCallback onTap;

  const ManifestButton({super.key, required this.primaryColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_shipping_outlined, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              "Manifest",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
