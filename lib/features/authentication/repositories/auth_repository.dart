import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/base_api_service.dart';
import '../../../core/network/network_api_service.dart';
import '../../../app/config/env.dart';
import '../services/auth_mock_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthRepository(apiService: apiService, mockService: AuthMockService());
});

class AuthRepository {
  final BaseApiService _apiService;
  final AuthMockService _mockService;

  AuthRepository({
    required BaseApiService apiService,
    required AuthMockService mockService,
  }) : _apiService = apiService, _mockService = mockService;

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response = await _apiService.postApiResponse(AppUrls.loginEndPoint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> mockLogin(String email, String password) async {
    return await _mockService.login(email, password);
  }
}
