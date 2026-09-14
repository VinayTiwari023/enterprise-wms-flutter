import '../../shared/models/user_model.dart';
import '../storage/storage_keys.dart';
import '../storage/storage_service.dart';

/// Manages the user session, including authentication tokens and user info.
class SessionManager {
  final StorageService _storageService;

  SessionManager(this._storageService);

  /// Checks if a user is currently logged in.
  Future<bool> isLoggedIn() async {
    final token = await _storageService.read(StorageKeys.accessToken);
    return token != null && token.toString().isNotEmpty;
  }

  /// Retrieves the current user's details from storage.
  Future<UserModel?> getUser() async {
    final token = await _storageService.read(StorageKeys.accessToken);
    if (token == null || token.toString().isEmpty) return null;

    final name = await _storageService.read(StorageKeys.userName);
    final email = await _storageService.read(StorageKeys.userEmail);

    return UserModel(
      token: token.toString(),
      name: name?.toString() ?? 'User',
      email: email?.toString() ?? '',
    );
  }

  /// Saves the user session after successful authentication.
  Future<void> saveSession({
    required String token,
    required String userId,
    required String userName,
    required String userEmail,
  }) async {
    await _storageService.save(StorageKeys.accessToken, token);
    await _storageService.save(StorageKeys.userId, userId);
    await _storageService.save(StorageKeys.userName, userName);
    await _storageService.save(StorageKeys.userEmail, userEmail);
  }

  /// Clears the user session on logout.
  Future<void> clearSession() async {
    await _storageService.remove(StorageKeys.accessToken);
    await _storageService.remove(StorageKeys.userId);
    await _storageService.remove(StorageKeys.userName);
    await _storageService.remove(StorageKeys.userEmail);
  }

  /// Retrieves the access token for API requests.
  Future<String?> getAccessToken() async {
    return await _storageService.read(StorageKeys.accessToken);
  }
}
