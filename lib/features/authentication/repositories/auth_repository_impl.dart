import 'dart:io';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/result/result.dart';
import '../../../core/network/base_api_service.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/storage/storage_keys.dart';
import '../../../app/config/env.dart';
import '../data/models/login_request.dart';
import '../data/models/login_response.dart';
import '../services/auth_mock_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BaseApiService _apiService;
  final AuthMockService _mockService;
  final StorageService _storageService;

  AuthRepositoryImpl({
    required BaseApiService apiService,
    required AuthMockService mockService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _mockService = mockService,
        _storageService = storageService;

  @override
  Future<Result<LoginResponse>> login(LoginRequest request) async {
    try {
      final dynamic response = await _apiService.postApiResponse(
        AppUrls.loginEndPoint,
        request.toJson(),
      );
      final data = LoginResponse.fromJson(response as Map<String, dynamic>);
      
      // Persist the token
      await _storageService.save(StorageKeys.accessToken, data.token);
      
      return Result.success(data);
    } on UnauthorizedException catch (e) {
      return Result.failure(UnauthorizedFailure(e.message ?? 'Invalid credentials'));
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
      final response = await _mockService.login(request.email, request.password);
      final data = LoginResponse.fromJson(response);
      
      // Persist the token
      await _storageService.save(StorageKeys.accessToken, data.token);
      
      return Result.success(data);
    } catch (e) {
      return Result.failure(UnauthorizedFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Result<bool>> checkAuthStatus() async {
    try {
      final token = await _storageService.read(StorageKeys.accessToken);
      
      final exists = token != null && token.toString().isNotEmpty;
      return Result.success(exists);
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _storageService.remove(StorageKeys.accessToken);
      return Result.success(null);
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
