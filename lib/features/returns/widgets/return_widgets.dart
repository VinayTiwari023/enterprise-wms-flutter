import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/return_order_model.dart';
import '../models/return_item_model.dart';

class ReturnOrderCard extends StatelessWidget {
  final ReturnOrderModel returnOrder;
  final Color primaryColor;
  final VoidCallback onTap;

  const ReturnOrderCard({
    super.key,
    required this.returnOrder,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = returnOrder.status == "Processed"
        ? Colors.green
        : (returnOrder.status == "Inspected" ? Colors.blue : Colors.orange);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.assignment_return_rounded,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          returnOrder.rmaNumber,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Ref Order: ${returnOrder.originalOrderNumber}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    returnOrder.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    returnOrder.customerName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  "\$${returnOrder.totalValue.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Reason: ${returnOrder.returnReason}",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber,
                    ),
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(returnOrder.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReturnInspectionTile extends StatefulWidget {
  final ReturnItemModel item;
  final Color primaryColor;
  final Function(String disposition, String condition, String? notes)
  onSaveInspection;

  const ReturnInspectionTile({
    super.key,
    required this.item,
    required this.primaryColor,
    required this.onSaveInspection,
  });

  @override
  State<ReturnInspectionTile> createState() => _ReturnInspectionTileState();
}

class _ReturnInspectionTileState extends State<ReturnInspectionTile> {
  late String _selectedCondition;
  late String _selectedDisposition;
  late TextEditingController _notesController;

  final List<String> _conditions = [
    "New / Unopened",
    "Opened Good",
    "Damaged",
    "Defective",
  ];

  final List<String> _dispositions = [
    "Pending",
    "Restock to Bin",
    "Quarantine",
    "Scrap",
  ];

  @override
  void initState() {
    super.initState();
    _selectedCondition = widget.item.condition;
    _selectedDisposition = widget.item.disposition;
    _notesController = TextEditingController(text: widget.item.notes ?? "");
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color dispColor = _selectedDisposition == "Restock to Bin"
        ? Colors.green
        : (_selectedDisposition == "Quarantine"
              ? Colors.orange
              : (_selectedDisposition == "Scrap" ? Colors.red : Colors.grey));

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: widget.item.disposition != "Pending"
              ? dispColor.withValues(alpha: 0.4)
              : Colors.grey.shade300,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: dispColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedDisposition,
                  style: TextStyle(
                    color: dispColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "SKU: ${widget.item.sku} • Qty: ${widget.item.quantity} • Value: \$${(widget.item.unitPrice * widget.item.quantity).toStringAsFixed(2)}",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Item Condition",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedCondition,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _conditions.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Text(c, style: const TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCondition = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Disposition Action",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedDisposition,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _dispositions.map((d) {
                        return DropdownMenuItem(
                          value: d,
                          child: Text(d, style: const TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedDisposition = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: "Inspection Notes / Defect Detail",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                widget.onSaveInspection(
                  _selectedDisposition,
                  _selectedCondition,
                  _notesController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Updated disposition for ${widget.item.sku}"),
                  ),
                );
              },
              child: const Text("Save Item Disposition"),
            ),
          ),
        ],
      ),
    );
  }
}
