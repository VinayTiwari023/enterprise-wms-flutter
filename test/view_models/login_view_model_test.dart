import 'package:enterprise_wms/core/error/failures.dart';
import 'package:enterprise_wms/core/result/result.dart';
import 'package:enterprise_wms/core/enums/view_status.dart';
import 'package:enterprise_wms/features/authentication/data/models/login_request.dart';
import 'package:enterprise_wms/features/authentication/data/models/login_response.dart';
import 'package:enterprise_wms/features/authentication/repositories/auth_repository.dart';
import 'package:enterprise_wms/features/authentication/viewmodels/login_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock using mocktail
class MockAuthRepository extends Mock implements AuthRepository {}

// Fake for mocktail's any() support with custom types
class FakeLoginRequest extends Fake implements LoginRequest {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginRequest());
  }); 

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
      final state = container.read(loginViewModelProvider);
      expect(state.status, ViewStatus.idle);
    });

    test('login with empty fields sets error', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      
      final result = await notifier.login('', '');
      
      final state = container.read(loginViewModelProvider);
      expect(result, isNull);
      expect(state.status, ViewStatus.error);
      expect(state.errorMessage, 'Please fill all fields');
    });

    test('successful login updates status and returns user', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      const response = LoginResponse(
        token: 'test_token',
        userName: 'Test User',
      );

      when(() => mockRepo.mockLogin(any()))
          .thenAnswer((_) async => Result.success(response));

      final result = await notifier.login('admin@wms.com', 'admin123');

      final state = container.read(loginViewModelProvider);
      expect(result, isNotNull);
      expect(result!.email, 'admin@wms.com');
      expect(result.name, 'Test User');
      expect(state.status, ViewStatus.success);
    });

    test('failed login sets error message', () async {
      final notifier = container.read(loginViewModelProvider.notifier);
      when(() => mockRepo.mockLogin(any()))
          .thenAnswer((_) async => Result.failure(const UnauthorizedFailure('Invalid email or password')));

      final result = await notifier.login('wrong@wms.com', 'wrong');

      final state = container.read(loginViewModelProvider);
      expect(result, isNull);
      expect(state.status, ViewStatus.error);
      expect(state.errorMessage, 'Invalid email or password');
    });
  });
}
