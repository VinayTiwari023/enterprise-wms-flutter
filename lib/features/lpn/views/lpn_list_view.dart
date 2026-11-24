import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/enums/view_status.dart';
import '../../dashboard/views/home_view.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/lpn_view_model.dart';
import '../widgets/lpn_widgets.dart';

class LpnListView extends ConsumerStatefulWidget {
  const LpnListView({super.key});

  @override
  ConsumerState<LpnListView> createState() => _LpnListViewState();
}

class _LpnListViewState extends ConsumerState<LpnListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final status = ref.watch(lpnViewModelProvider.select((s) => s.status));
    final filteredLpns = ref.watch(filteredLpnProvider);
    final transfers = ref.watch(
      lpnViewModelProvider.select((s) => s.transfers),
    );

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(shouldOpenDrawerProvider.notifier).state = true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              ref.read(shouldOpenDrawerProvider.notifier).state = true;
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                context.go('/dashboard');
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          title: const Text("Pallet & LPN Management"),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                ref.read(lpnViewModelProvider.notifier).fetchLpns();
              },
              icon: const Icon(Icons.refresh_rounded),
              tooltip: "Refresh Containers",
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "Active Pallets / LPNs"),
              Tab(text: "Movement Log"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Active Pallets / LPNs
            Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      ref.read(lpnSearchQueryProvider.notifier).state = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Search LPN, SKU, Location, or Status...",
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                ref
                                        .read(lpnSearchQueryProvider.notifier)
                                        .state =
                                    "";
                              },
                            )
                          : null,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // Overview Stats Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildStatChip(
                        context,
                        label: "Total Pallets",
                        value: "${filteredLpns.length}",
                        icon: Icons.widgets_rounded,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 10),
                      _buildStatChip(
                        context,
                        label: "Staged",
                        value:
                            "${filteredLpns.where((l) => l.status.toLowerCase() == 'staged').length}",
                        icon: Icons.schedule_rounded,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      _buildStatChip(
                        context,
                        label: "Putaway",
                        value:
                            "${filteredLpns.where((l) => l.status.toLowerCase() == 'putaway').length}",
                        icon: Icons.check_circle_rounded,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // List of LPN Cards
                Expanded(
                  child: status == ViewStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredLpns.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "No Pallets or LPN containers found",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredLpns.length,
                          itemBuilder: (context, index) {
                            final lpn = filteredLpns[index];
                            return LpnCard(
                              lpn: lpn,
                              primaryColor: primaryColor,
                              onTap: () {
                                context.pushNamed(
                                  RouteNames.lpnDetails,
                                  pathParameters: {'lpnNumber': lpn.lpnNumber},
                                );
                              },
                              onTransfer: () {
                                context.pushNamed(
                                  RouteNames.lpnTransfer,
                                  queryParameters: {'lpnNumber': lpn.lpnNumber},
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),

            // Tab 2: Movement Logs
            transfers.isEmpty
                ? const Center(
                    child: Text(
                      "No LPN transfer logs recorded yet.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transfers.length,
                    itemBuilder: (context, index) {
                      final transfer = transfers[index];
                      return LpnTransferHistoryCard(transfer: transfer);
                    },
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          onPressed: () {
            _showActionMenu(context, primaryColor);
          },
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            "LPN Actions",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showActionMenu(BuildContext context, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pallet & LPN Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  child: Icon(Icons.add_box_rounded, color: primaryColor),
                ),
                title: const Text("Build New Pallet (LPN)"),
                subtitle: const Text("Create a new License Plate container"),
                onTap: () {
                  Navigator.pop(ctx);
                  context.pushNamed(RouteNames.createLpn);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.swap_horiz_rounded,
                    color: Colors.purple,
                  ),
                ),
                title: const Text("Relocate / Move Pallet"),
                subtitle: const Text("Transfer full LPN container to new Bin"),
                onTap: () {
                  Navigator.pop(ctx);
                  context.pushNamed(RouteNames.lpnTransfer);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
