/// A utility class that holds all the keys used for local storage.
/// 
/// A centralized collection of keys used by the application's storage layer.
/// Keeping storage keys in one place prevents duplication, reduces
/// typographical errors, and makes future changes easier.
final class StorageKeys {
  /// Private constructor to prevent instantiation.
  StorageKeys._();

  /// Key for storing the user's primary authentication token.
  static const String accessToken = 'access_token';

  /// Key for storing the token used to obtain a new access token.
  static const String refreshToken = 'refresh_token';

  /// Key for storing the user's ID.
  static const String userId = 'user_id';

  /// Key for storing the user's full name.
  static const String userName = 'user_name';

  /// Key for storing the user's email.
  static const String userEmail = 'user_email';
}
