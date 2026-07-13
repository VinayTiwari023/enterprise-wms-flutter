import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/locator.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return locator<AuthRepository>();
});

abstract class AuthRepository {
  Future<dynamic> loginApi(dynamic data);
  Future<Map<String, dynamic>> mockLogin(String email, String password);
}
