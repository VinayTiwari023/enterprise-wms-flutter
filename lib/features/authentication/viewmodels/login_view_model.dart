import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../../../shared/models/user_model.dart';
import '../../../core/utils/base_view_model.dart';

final loginViewModelProvider = ChangeNotifierProvider.autoDispose((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return LoginViewModel(authRepo: authRepo);
});

class LoginViewModel extends BaseViewModel {
  final AuthRepository _authRepo;

  LoginViewModel({required AuthRepository authRepo}) : _authRepo = authRepo;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<UserModel?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      setError("Please fill all fields");
      return null;
    }

    setStatus(ViewStatus.loading);
    
    try {
      final response = await _authRepo.mockLogin(email, password);
      setStatus(ViewStatus.success);
      return UserModel.fromJson(response);
    } catch (e) {
      setError(e.toString().replaceAll('Exception: ', ''));
      return null;
    }
  }
}
