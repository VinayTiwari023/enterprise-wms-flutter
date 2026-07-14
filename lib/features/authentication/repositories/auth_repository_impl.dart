import '../../../core/network/base_api_service.dart';
import '../../../app/config/env.dart';
import '../data/models/login_request.dart';
import '../data/models/login_response.dart';
import '../services/auth_mock_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BaseApiService _apiService;
  final AuthMockService _mockService;

  AuthRepositoryImpl({
    required BaseApiService apiService,
    required AuthMockService mockService,
  })  : _apiService = apiService,
        _mockService = mockService;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    // We remove the try-catch block as we are not performing any additional 
    // error processing here, letting the exception bubble up to the caller/error handler.
    final dynamic response = await _apiService.postApiResponse(
      AppUrls.loginEndPoint,
      request.toJson(),
    );
    // Converting the dynamic API response to a strongly typed LoginResponse DTO.
    return LoginResponse.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<LoginResponse> mockLogin(LoginRequest request) async {
    // Updated to use the LoginRequest DTO for consistency with the main login method.
    final response = await _mockService.login(request.email, request.password);
    return LoginResponse.fromJson(response);
  }
}
