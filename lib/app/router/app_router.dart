import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_names.dart';
import '../../features/authentication/views/splash_view.dart';
import '../../features/authentication/views/login_view.dart';
import '../../features/dashboard/views/home_view.dart';
import '../../features/authentication/viewmodels/user_view_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final userVM = ref.watch(userViewModelProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: userVM,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = userVM.isLoggedIn;
      final isCheckingAuth = userVM.isCheckingAuth;
      
      // If we are currently checking auth status, stay on splash
      if (isCheckingAuth) return '/splash';

      final isLoggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/splash';

      // If not logged in and not on login page, redirect to login
      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      // If logged in and on login or splash page, redirect to home
      if (isLoggedIn && (isLoggingIn || isSplash)) {
        return '/home';
      }

      // No redirect needed
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
      GoRoute(
        path: '/home',
        name: RouteNames.dashboard,
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
});
