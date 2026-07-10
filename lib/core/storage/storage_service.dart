abstract class StorageService {
  Future<void> save(String key, dynamic value);
  Future<dynamic> read(String key);
  Future<void> remove(String key);
  Future<void> clear();
}
