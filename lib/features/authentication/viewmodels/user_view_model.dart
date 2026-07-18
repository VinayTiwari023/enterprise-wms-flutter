import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/result/result.dart';
import '../../../shared/models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Represents the state of the user authentication.
class UserState {
  final UserModel? user;
  final bool isCheckingAuth;

  const UserState({
    this.user,
    this.isCheckingAuth = true,
  });

  bool get isLoggedIn => user != null;

  UserState copyWith({
    UserModel? user,
    bool? isCheckingAuth,
    bool clearUser = false,
  }) {
    return UserState(
      user: clearUser ? null : (user ?? this.user),
      isCheckingAuth: isCheckingAuth ?? this.isCheckingAuth,
    );
  }
}

/// A modern Notifier-based ViewModel for managing user session state.
/// This replaces the legacy ChangeNotifier-based implementation.
class UserViewModel extends Notifier<UserState> {
  @override
  UserState build() {
    // Initial state
    return const UserState();
  }

  AuthRepository get _authRepo => ref.read(authRepositoryProvider);

  /// Checks for an existing session on app startup.
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isCheckingAuth: true);

    final result = await _authRepo.checkAuthStatus();

    final user = switch (result) {
      Success(value: true) => UserModel(token: '', email: '', name: 'Authenticated User'),
      _ => null,
    };

    state = state.copyWith(
      user: user,
      isCheckingAuth: false,
      clearUser: user == null,
    );
  }

  /// Manually sets the user (e.g., after a successful login).
  void setUser(UserModel user) {
    state = state.copyWith(
      user: user,
      isCheckingAuth: false,
    );
  }

  /// Logs out the user and clears the state.
  Future<void> logout() async {
    // We clear the user locally regardless of whether the remote logout succeeds,
    // as our primary concern is security on the current device.
    await _authRepo.logout();
    state = state.copyWith(
      clearUser: true,
      isCheckingAuth: false,
    );
  }
}

/// Provider for the UserViewModel.
/// Using NotifierProvider instead of ChangeNotifierProvider for better state management.
final userViewModelProvider = NotifierProvider<UserViewModel, UserState>(() {
  return UserViewModel();
});
