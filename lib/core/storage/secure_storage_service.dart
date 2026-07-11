import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_service.dart';

/// An implementation of [StorageService] that uses [FlutterSecureStorage] 
/// to persist data securely.
///
/// This is ideal for sensitive information such as authentication tokens, 
/// as it uses platform-specific encryption (Keychain on iOS/macOS, 
/// Keystore on Android, etc.).
class SecureStorageService implements StorageService {
  final FlutterSecureStorage _storage;

  /// Creates a new instance of [SecureStorageService].
  ///
  /// Takes a [FlutterSecureStorage] instance via constructor injection to 
  /// facilitate testing and flexible configuration.
  SecureStorageService(this._storage);

  /// Persists a [value] associated with a [key] in secure storage.
  ///
  /// The [value] is converted to a [String] using [toString] since 
  /// secure storage only supports string values.
  @override
  Future<void> save(String key, dynamic value) async {
    await _storage.write(
      key: key,
      value: value.toString(),
    );
  }

  /// Reads the value associated with the given [key] from secure storage.
  ///
  /// Returns the stored string value, or null if the key is not found.
  @override
  Future<dynamic> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Deletes the value associated with the given [key] from secure storage.
  @override
  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  /// Clears all values stored in secure storage.
  @override
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
