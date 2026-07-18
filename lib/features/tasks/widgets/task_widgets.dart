import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final Color primaryColor;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTypeBadge(task.type, primaryColor),
                    _buildPriorityIndicator(task.priority),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16, color: primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      task.location,
                      style: TextStyle(
                        fontSize: 13, 
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.access_time, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('hh:mm a').format(task.createdAt),
                      style: TextStyle(
                        fontSize: 13, 
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildStatusFooter(context, task.status, primaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(TaskType type, Color primaryColor) {
    IconData icon;
    String label;
    switch (type) {
      case TaskType.pick:
        icon = Icons.shopping_basket_outlined;
        label = "PICK";
        break;
      case TaskType.pack:
        icon = Icons.inventory_2_outlined;
        label = "PACK";
        break;
      case TaskType.receive:
        icon = Icons.login_rounded;
        label = "RECEIVE";
        break;
      case TaskType.count:
        icon = Icons.numbers_rounded;
        label = "COUNT";
        break;
      case TaskType.ship:
        icon = Icons.local_shipping_outlined;
        label = "SHIP";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator(TaskPriority priority) {
    Color color;
    String label;
    switch (priority) {
      case TaskPriority.high:
        color = Colors.red;
        label = "High";
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        label = "Medium";
        break;
      case TaskPriority.low:
        color = Colors.blue;
        label = "Low";
        break;
    }

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFooter(BuildContext context, TaskStatus status, Color primaryColor) {
    String label;
    Color color;
    IconData icon;

    switch (status) {
      case TaskStatus.pending:
        label = "Ready to start";
        color = Colors.grey.shade500;
        icon = Icons.play_arrow_outlined;
        break;
      case TaskStatus.inProgress:
        label = "In Progress";
        color = Colors.blue.shade400;
        icon = Icons.sync;
        break;
      case TaskStatus.completed:
        label = "Completed";
        color = Colors.green.shade400;
        icon = Icons.check_circle_outline;
        break;
      case TaskStatus.cancelled:
        label = "Cancelled";
        color = Colors.red.shade400;
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
