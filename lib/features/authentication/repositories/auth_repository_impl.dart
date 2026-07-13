import '../../../core/network/base_api_service.dart';
import '../../../app/config/env.dart';
import '../services/auth_mock_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BaseApiService _apiService;
  final AuthMockService _mockService;

  AuthRepositoryImpl({
    required BaseApiService apiService,
    required AuthMockService mockService,
  }) : _apiService = apiService, _mockService = mockService;

  @override
  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response = await _apiService.postApiResponse(AppUrls.loginEndPoint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> mockLogin(String email, String password) async {
    return await _mockService.login(email, password);
  }
}
