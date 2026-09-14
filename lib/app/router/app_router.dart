import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_names.dart';
import '../../features/authentication/views/splash_view.dart';
import '../../features/authentication/views/login_view.dart';
import '../../features/dashboard/views/home_view.dart';
import '../../features/dashboard/views/reports_view.dart';
import '../../features/authentication/viewmodels/user_view_model.dart';
import '../../features/inward/views/inbound_view.dart';
import '../../features/purchase_order/views/add_po_view.dart';
import '../../features/purchase_order/views/po_details_view.dart';
import '../../features/barcode/views/po_scan_view.dart';
import '../../features/shipment/views/outbound_view.dart';
import '../../features/shipment/views/picking_view.dart';
import '../../features/shipment/views/manifest_view.dart';
import '../../features/inventory/views/inventory_view.dart';
import '../../features/inventory/views/add_item_view.dart';
import '../../features/settings/views/profile_view.dart';

// Global keys for navigation
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _dashboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final GlobalKey<NavigatorState> _inboundNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'inbound');
final GlobalKey<NavigatorState> _outboundNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'outbound');
final GlobalKey<NavigatorState> _inventoryNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'inventory');
final GlobalKey<NavigatorState> _profileNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'profile');

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(userViewModelProvider, (previous, next) {
      notifyListeners();
    });
  }
}

final routerNotifierProvider = Provider((ref) => RouterNotifier(ref));

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = ref.watch(routerNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: listenable,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final userState = ref.read(userViewModelProvider);
      final isLoggedIn = userState.isLoggedIn;
      final isCheckingAuth = userState.isCheckingAuth;

      if (isCheckingAuth) return '/splash';

      final isLoggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/splash';

      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggedIn && (isLoggingIn || isSplash)) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginView(),
      ),

      // Dashboard Shell with Tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeView(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: '/dashboard',
                name: RouteNames.dashboard,
                builder: (context, state) => const DashboardView(),
                routes: [
                  GoRoute(
                    path: 'reports',
                    name: RouteNames.reports,
                    builder: (context, state) => const ReportsView(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _inboundNavigatorKey,
            routes: [
              GoRoute(
                path: '/inbound',
                name: RouteNames.inbound,
                builder: (context, state) => InboundView(
                  onBack: () => GoRouter.of(context).go('/dashboard'),
                ),
                routes: [
                  GoRoute(
                    path: 'add-po',
                    name: RouteNames.addPO,
                    builder: (context, state) => const AddPOView(),
                  ),
                  GoRoute(
                    path: 'scan',
                    name: RouteNames.poScan,
                    builder: (context, state) => const POScanView(),
                  ),
                  GoRoute(
                    path: 'details/:poNumber',
                    name: RouteNames.poDetails,
                    builder: (context, state) {
                      final poNumber = state.pathParameters['poNumber']!;
                      return PODetailsView(poNumber: poNumber);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _outboundNavigatorKey,
            routes: [
              GoRoute(
                path: '/outbound',
                name: RouteNames.outbound,
                builder: (context, state) => OutboundView(
                  onBack: () => GoRouter.of(context).go('/dashboard'),
                ),
                routes: [
                  GoRoute(
                    path: 'manifest',
                    name: RouteNames.manifest,
                    builder: (context, state) => const ManifestView(),
                  ),
                  GoRoute(
                    path: 'picking/:orderNumber',
                    name: RouteNames.picking,
                    builder: (context, state) {
                      final orderNumber = state.pathParameters['orderNumber']!;
                      return PickingView(orderNumber: orderNumber);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _inventoryNavigatorKey,
            routes: [
              GoRoute(
                path: '/inventory',
                name: RouteNames.inventory,
                builder: (context, state) => InventoryView(
                  onBack: () => GoRouter.of(context).go('/dashboard'),
                ),
                routes: [
                  GoRoute(
                    path: 'add-item',
                    name: RouteNames.addItem,
                    builder: (context, state) => const AddItemView(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: RouteNames.profile,
                builder: (context, state) => ProfileView(
                  onBack: () => GoRouter.of(context).go('/dashboard'),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
