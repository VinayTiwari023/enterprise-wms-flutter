import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/locator.dart';
import '../../../core/result/result.dart';
import '../data/models/login_request.dart';
import '../data/models/login_response.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return locator<AuthRepository>();
});

abstract class AuthRepository {
  /// Authenticates user against the backend API
  Future<Result<LoginResponse>> login(LoginRequest request);

  /// Authenticates user against a mock service for development
  Future<Result<LoginResponse>> mockLogin(LoginRequest request);

  /// Checks if there's a valid session stored locally.
  /// Returns `true` if a session exists, `false` otherwise.
  Future<Result<bool>> checkAuthStatus();

  /// Clears the local session and performs any remote cleanup.
  Future<Result<void>> logout();
}
