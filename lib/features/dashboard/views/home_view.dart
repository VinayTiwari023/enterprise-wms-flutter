import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/helpers/responsive_helper.dart';
import '../viewmodels/home_view_model.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../../authentication/viewmodels/user_view_model.dart';
import '../../../shared/widgets/main_drawer.dart';
import '../widgets/dashboard_widgets.dart';

class HomeView extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const HomeView({super.key, required this.navigationShell});

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final currentIndex = navigationShell.currentIndex;

    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (currentIndex != 0) {
          _onTap(context, 0);
        }
      },
      child: Scaffold(
        drawer: MainDrawer(
          selectedIndex: currentIndex,
          onIndexSelected: (index) {
            _onTap(context, index);
            Navigator.pop(context); // Close drawer
          },
        ),
        body: SafeArea(child: navigationShell),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => _onTap(context, index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: themeVM.isDarkMode
                ? const Color(0xFF12121A)
                : Colors.white,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey.shade600,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(
                  Icons.grid_view_rounded,
                  0,
                  primaryColor,
                  currentIndex,
                ),
                label: AppLocalizations.of(context)!.dashboard,
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(
                  Icons.login_rounded,
                  1,
                  primaryColor,
                  currentIndex,
                ),
                label: AppLocalizations.of(context)!.inbound,
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(
                  Icons.logout_rounded,
                  2,
                  primaryColor,
                  currentIndex,
                ),
                label: AppLocalizations.of(context)!.outbound,
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(
                  Icons.inventory_2_outlined,
                  3,
                  primaryColor,
                  currentIndex,
                ),
                label: AppLocalizations.of(context)!.inventory,
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(
                  Icons.person_outline_rounded,
                  4,
                  primaryColor,
                  currentIndex,
                ),
                label: AppLocalizations.of(context)!.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(
    IconData icon,
    int index,
    Color primaryColor,
    int currentIndex,
  ) {
    bool isSelected = currentIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: isSelected ? primaryColor : Colors.grey.shade600,
        size: 24,
      ),
    );
  }
}

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final userVM = ref.watch(userViewModelProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(
            AppLocalizations.of(context)!.dashboard,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.responsiveSize(context, 18, 20, 22),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () =>
                  ref.read(themeViewModelProvider.notifier).toggleTheme(),
              icon: Icon(
                themeVM.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.hello(userVM.user?.name ?? 'Vinay'),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.todayStatus,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/icons/wms_icon.png',
                        width: 44,
                        height: 44,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),

        // Summary Cards Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.15,
            children: [
              StatCard(
                value: "${viewModel.stats?.pendingCount ?? 0}",
                label: "Pending",
                icon: Icons.assignment_outlined,
                color: Colors.orange,
              ),
              StatCard(
                value: "${viewModel.stats?.completedCount ?? 0}",
                label: "Completed",
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),
              StatCard(
                value: "${viewModel.stats?.inProgressCount ?? 0}",
                label: "In Progress",
                icon: Icons.sync,
                color: Colors.blue,
              ),
              StatCard(
                value: "${viewModel.stats?.alertsCount ?? 0}",
                label: "Alerts",
                icon: Icons.warning_amber_rounded,
                color: Colors.red,
              ),
            ],
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 25),
                const Text(
                  "Performance Overview",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                PerformanceChart(primaryColor: primaryColor),
                const SizedBox(height: 25),
                StockDistributionCard(primaryColor: primaryColor),
                const SizedBox(height: 25),
                const Divider(),
                const SizedBox(height: 25),
                const Text(
                  "Recent Activities",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),

        // Recent Activities List (SliverList)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final activity = viewModel.recentActivities[index];
              return ActivityTile(
                activity: activity,
                primaryColor: primaryColor,
              );
            }, childCount: viewModel.recentActivities.length),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 25),
                const Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),

        // Quick Actions Grid (SliverGrid)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildListDelegate([
              QuickActionItem(
                icon: Icons.qr_code_scanner_rounded,
                label: "Scan",
                color: primaryColor,
                onTap: () => context.pushNamed(RouteNames.poScan),
              ),
              QuickActionItem(
                icon: Icons.add_box_outlined,
                label: "Add",
                color: primaryColor,
                onTap: () => context.pushNamed(RouteNames.addPO),
              ),
              QuickActionItem(
                icon: Icons.checklist_rounded,
                label: "Audit",
                color: primaryColor,
                onTap: () => context.pushNamed(RouteNames.audit),
              ),
              QuickActionItem(
                icon: Icons.inventory_2_outlined,
                label: "Inventory",
                color: primaryColor,
                onTap: () {
                  context.go('/inventory');
                },
              ),
              QuickActionItem(
                icon: Icons.swap_horiz_rounded,
                label: "Relocate",
                color: primaryColor,
                onTap: () {
                  context.pushNamed(RouteNames.stockTransfer);
                },
              ),
              QuickActionItem(
                icon: Icons.bar_chart_rounded,
                label: "Reports",
                color: primaryColor,
                onTap: () {
                  context.go('/dashboard/reports');
                },
              ),
              QuickActionItem(
                icon: Icons.route_rounded,
                label: "Picklists",
                color: primaryColor,
                onTap: () {
                  context.pushNamed(RouteNames.picklist);
                },
              ),
              QuickActionItem(
                icon: Icons.assignment_return_rounded,
                label: "Returns",
                color: primaryColor,
                onTap: () {
                  context.pushNamed(RouteNames.returns);
                },
              ),
              QuickActionItem(
                icon: Icons.settings_outlined,
                label: "Config",
                color: primaryColor,
                onTap: () {
                  context.go('/profile');
                },
              ),
            ]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
