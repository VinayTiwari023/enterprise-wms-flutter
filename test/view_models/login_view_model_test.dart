import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms_new/features/authentication/repositories/auth_repository.dart';
import 'package:wms_new/features/authentication/viewmodels/login_view_model.dart';
import 'package:wms_new/core/utils/base_view_model.dart';

// Manual Mock
class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<Map<String, dynamic>> mockLogin(String? email, String? password) =>
      super.noSuchMethod(
        Invocation.method(#mockLogin, [email, password]),
        returnValue: Future.value(<String, dynamic>{}),
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
      final userData = {
        'token': 'test_token',
        'email': 'admin@wms.com',
        'name': 'Test User'
      };

      when(mockRepo.mockLogin('admin@wms.com', 'admin123'))
          .thenAnswer((_) async => userData);

      final result = await viewModel.login('admin@wms.com', 'admin123');

      expect(result, isNotNull);
      expect(result!.email, 'admin@wms.com');
      expect(viewModel.status, ViewStatus.success);
    });

    test('failed login sets error message', () async {
      final viewModel = container.read(loginViewModelProvider);
      when(mockRepo.mockLogin('wrong@wms.com', 'wrong'))
          .thenThrow(Exception('Invalid email or password'));

      final result = await viewModel.login('wrong@wms.com', 'wrong');

      expect(result, isNull);
      expect(viewModel.status, ViewStatus.error);
      expect(viewModel.errorMessage, 'Invalid email or password');
    });
  });
}
