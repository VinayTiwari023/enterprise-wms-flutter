import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/result/result.dart';
import '../../../shared/models/user_model.dart';
import '../repositories/auth_repository.dart';

final userViewModelProvider = ChangeNotifierProvider((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return UserViewModel(authRepo: authRepo);
});

class UserViewModel with ChangeNotifier {
  final AuthRepository _authRepo;
  UserModel? _user;
  bool _isCheckingAuth = true;

  UserViewModel({required AuthRepository authRepo}) : _authRepo = authRepo;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isCheckingAuth => _isCheckingAuth;

  /// Checks for an existing session on app startup.
  Future<void> checkAuthStatus() async {
    _isCheckingAuth = true;
    notifyListeners();

    final result = await _authRepo.checkAuthStatus();

    _user = switch (result) {
      Success(value: true) => UserModel(token: '', email: '', name: 'Authenticated User'),
      _ => null,
    };

    _isCheckingAuth = false;
    notifyListeners();
  }

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    // We clear the user locally regardless of whether the remote logout succeeds,
    // as our primary concern is security on the current device.
    await _authRepo.logout();
    _user = null;
    notifyListeners();
  }
}
