import 'dart:io';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/result/result.dart';
import '../../../core/network/base_api_service.dart';
import '../../../core/session/session_manager.dart';
import '../../../app/config/env.dart';
import '../../../shared/models/user_model.dart';
import '../data/models/login_request.dart';
import '../data/models/login_response.dart';
import '../services/auth_mock_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BaseApiService _apiService;
  final AuthMockService _mockService;
  final SessionManager _sessionManager;

  AuthRepositoryImpl({
    required BaseApiService apiService,
    required AuthMockService mockService,
    required SessionManager sessionManager,
  }) : _apiService = apiService,
       _mockService = mockService,
       _sessionManager = sessionManager;

  @override
  Future<Result<LoginResponse>> login(LoginRequest request) async {
    try {
      final dynamic response = await _apiService.postApiResponse(
        AppUrls.loginEndPoint,
        request.toJson(),
      );
      final data = LoginResponse.fromJson(response as Map<String, dynamic>);

      await _sessionManager.saveSession(
        token: data.token ?? '',
        userId: data.userId ?? '',
        userName: data.userName ?? '',
        userEmail: request.email,
      );

      return Result.success(data);
    } on UnauthorizedException catch (e) {
      return Result.failure(
        UnauthorizedFailure(e.message ?? 'Invalid credentials'),
      );
    } on SocketException {
      return Result.failure(const NetworkFailure());
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<LoginResponse>> mockLogin(LoginRequest request) async {
    try {
      final response = await _mockService.login(
        request.email,
        request.password,
      );
      final data = LoginResponse.fromJson(response);

      await _sessionManager.saveSession(
        token: data.token ?? '',
        userId: data.userId ?? '',
        userName: data.userName ?? '',
        userEmail: request.email,
      );

      return Result.success(data);
    } catch (e) {
      return Result.failure(
        UnauthorizedFailure(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  @override
  Future<Result<UserModel?>> checkAuthStatus() async {
    try {
      final user = await _sessionManager.getUser();
      return Result.success(user);
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _sessionManager.clearSession();
      return Result.success(null);
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
