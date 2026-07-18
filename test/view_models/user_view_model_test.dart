import 'package:enterprise_wms/core/result/result.dart';
import 'package:enterprise_wms/shared/models/user_model.dart';
import 'package:enterprise_wms/features/authentication/repositories/auth_repository.dart';
import 'package:enterprise_wms/features/authentication/viewmodels/user_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('UserViewModel Tests -', () {
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

    test('Initial state should have no user and isCheckingAuth true (default state)', () {
      final state = container.read(userViewModelProvider);
      expect(state.user, isNull);
      expect(state.isCheckingAuth, isTrue);
    });

    test('checkAuthStatus updates state with user when session exists', () async {
      final notifier = container.read(userViewModelProvider.notifier);
      final user = UserModel(token: 'token', name: 'Vinay Admin', email: 'admin@wms.com');

      when(() => mockRepo.checkAuthStatus())
          .thenAnswer((_) async => Result.success(user));

      await notifier.checkAuthStatus();

      final state = container.read(userViewModelProvider);
      expect(state.user, isNotNull);
      expect(state.user!.name, 'Vinay Admin');
      expect(state.isCheckingAuth, isFalse);
    });

    test('checkAuthStatus clears user when no session exists', () async {
      final notifier = container.read(userViewModelProvider.notifier);

      when(() => mockRepo.checkAuthStatus())
          .thenAnswer((_) async => Result.success(null));

      await notifier.checkAuthStatus();

      final state = container.read(userViewModelProvider);
      expect(state.user, isNull);
      expect(state.isCheckingAuth, isFalse);
    });

    test('logout clears user state', () async {
      final notifier = container.read(userViewModelProvider.notifier);
      
      // Manually set user first
      notifier.setUser(UserModel(token: 'token', name: 'User', email: 'email'));
      expect(container.read(userViewModelProvider).user, isNotNull);

      when(() => mockRepo.logout())
          .thenAnswer((_) async => Result.success(null));

      await notifier.logout();

      final state = container.read(userViewModelProvider);
      expect(state.user, isNull);
    });
  });
}
