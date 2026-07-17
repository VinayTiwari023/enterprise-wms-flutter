import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/login_request.dart';
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

    final result = await _authRepo.mockLogin(
      LoginRequest(email: email, password: password),
    );

    return result.when(
      onSuccess: (response) {
        setStatus(ViewStatus.success);
        return UserModel(
          token: response.token,
          email: email,
          name: response.userName ?? 'User',
        );
      },
      onFailure: (failure) {
        setError(failure.message);
        return null;
      },
    );
  }
}
