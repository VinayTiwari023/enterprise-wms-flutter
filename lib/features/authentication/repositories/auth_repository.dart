import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/locator.dart';
import '../data/models/login_request.dart';
import '../data/models/login_response.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return locator<AuthRepository>();
});

abstract class AuthRepository {
  /// Authenticates user against the backend API
  Future<LoginResponse> login(LoginRequest request);

  /// Authenticates user against a mock service for development
  Future<LoginResponse> mockLogin(LoginRequest request);
}
