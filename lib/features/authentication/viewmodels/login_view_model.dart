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
    
    try {
      // Using the new LoginRequest DTO for the repository call
      final response = await _authRepo.mockLogin(
        LoginRequest(email: email, password: password),
      );
      
      setStatus(ViewStatus.success);
      
      // Mapping the LoginResponse DTO to the app's UserModel
      return UserModel(
        token: response.token,
        email: email, // Email from request since response might not have it
        name: response.userName ?? 'User',
      );
    } catch (e) {
      setError(e.toString().replaceAll('Exception: ', ''));
      return null;
    }
  }
}
