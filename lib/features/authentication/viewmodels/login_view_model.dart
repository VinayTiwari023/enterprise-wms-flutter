import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/login_request.dart';
import '../repositories/auth_repository.dart';
import '../../../shared/models/user_model.dart';
import '../../../core/enums/view_status.dart';

/// Represents the immutable state of the login screen.
class LoginState {
  final bool isPasswordVisible;
  final ViewStatus status;
  final String? errorMessage;

  const LoginState({
    this.isPasswordVisible = false,
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  bool get isLoading => status == ViewStatus.loading;

  LoginState copyWith({
    bool? isPasswordVisible,
    ViewStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// A modern AutoDisposeNotifier for managing login state.
/// Inheriting from BaseViewModel is no longer necessary as we manage status/error in LoginState.
class LoginViewModel extends AutoDisposeNotifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  AuthRepository get _authRepo => ref.read(authRepositoryProvider);

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  Future<UserModel?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        status: ViewStatus.error,
        errorMessage: "Please fill all fields",
      );
      return null;
    }

    state = state.copyWith(status: ViewStatus.loading, clearError: true);

    final result = await _authRepo.mockLogin(
      LoginRequest(email: email, password: password),
    );

    return result.when(
      onSuccess: (response) {
        state = state.copyWith(status: ViewStatus.success);
        return UserModel(
          token: response.token,
          email: email,
          name: response.userName ?? 'User',
        );
      },
      onFailure: (failure) {
        state = state.copyWith(
          status: ViewStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
    );
  }
}

/// Provider for the LoginViewModel using AutoDisposeNotifierProvider.
final loginViewModelProvider = AutoDisposeNotifierProvider<LoginViewModel, LoginState>(() {
  return LoginViewModel();
});
