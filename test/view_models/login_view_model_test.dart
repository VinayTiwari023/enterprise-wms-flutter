import 'package:enterprise_wms/core/utils/base_view_model.dart';
import 'package:enterprise_wms/features/authentication/data/models/login_request.dart';
import 'package:enterprise_wms/features/authentication/data/models/login_response.dart';
import 'package:enterprise_wms/features/authentication/repositories/auth_repository.dart';
import 'package:enterprise_wms/features/authentication/viewmodels/login_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Manual Mock
class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<LoginResponse> login(LoginRequest? request) async =>
      super.noSuchMethod(
        Invocation.method(#login, [request]),
        returnValue: Future.value(const LoginResponse()),
      );

  @override
  Future<LoginResponse> mockLogin(LoginRequest? request) =>
      super.noSuchMethod(
        Invocation.method(#mockLogin, [request]),
        returnValue: Future.value(const LoginResponse()),
      );
}

void main() {
  group('LoginViewModel Tests -', () {
    late ProviderContainer container;
    late MockAuthRepository mockRepo;

    setUp(() {
      mockRepo = MockAuthRepository();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial status should be idle', () {
      final viewModel = container.read(loginViewModelProvider);
      expect(viewModel.status, ViewStatus.idle);
    });

    test('login with empty fields sets error', () async {
      final viewModel = container.read(loginViewModelProvider);
      final result = await viewModel.login('', '');
      expect(result, isNull);
      expect(viewModel.status, ViewStatus.error);
      expect(viewModel.errorMessage, 'Please fill all fields');
    });

    test('successful login updates status and returns user', () async {
      final viewModel = container.read(loginViewModelProvider);
      const response = LoginResponse(
        token: 'test_token',
        userName: 'Test User',
      );

      when(mockRepo.mockLogin(any))
          .thenAnswer((_) async => response);

      final result = await viewModel.login('admin@wms.com', 'admin123');

      expect(result, isNotNull);
      expect(result!.email, 'admin@wms.com');
      expect(result.name, 'Test User');
      expect(viewModel.status, ViewStatus.success);
    });

    test('failed login sets error message', () async {
      final viewModel = container.read(loginViewModelProvider);
      when(mockRepo.mockLogin(any))
          .thenThrow(Exception('Invalid email or password'));

      final result = await viewModel.login('wrong@wms.com', 'wrong');

      expect(result, isNull);
      expect(viewModel.status, ViewStatus.error);
      expect(viewModel.errorMessage, 'Invalid email or password');
    });
  });
}
