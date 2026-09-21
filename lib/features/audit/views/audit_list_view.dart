import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../models/audit_model.dart';
import '../viewmodels/audit_view_model.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../../../core/enums/view_status.dart';

class AuditListView extends ConsumerWidget {
  const AuditListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditState = ref.watch(auditViewModelProvider);
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cycle Counting / Audits"),
        centerTitle: true,
      ),
      body: auditState.status == ViewStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: auditState.audits.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final audit = auditState.audits[index];
                return _buildAuditCard(context, audit, primaryColor);
              },
            ),
    );
  }

  Widget _buildAuditCard(BuildContext context, AuditModel audit, Color color) {
    Color statusColor = audit.status == "Completed"
        ? Colors.green
        : Colors.orange;

    return InkWell(
      onTap: audit.status == "Completed"
          ? null
          : () => context.pushNamed(
              RouteNames.auditDetails,
              pathParameters: {'auditId': audit.id},
            ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  audit.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    audit.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              audit.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Zone: ${audit.zone}",
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Due Date: ${audit.dueDate.day}/${audit.dueDate.month}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  "${audit.items.where((i) => i.isCounted).length}/${audit.items.length} Items Counted",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
