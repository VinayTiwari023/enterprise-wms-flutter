import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../network/base_api_service.dart';
import '../network/network_api_service.dart';

import '../storage/storage_service.dart';
import '../storage/secure_storage_service.dart';

import '../../features/authentication/repositories/auth_repository.dart';
import '../../features/authentication/repositories/auth_repository_impl.dart';
import '../../features/authentication/services/auth_mock_service.dart';

import '../../features/inventory/repositories/inventory_repository.dart';
import '../../features/inventory/repositories/inventory_repository_impl.dart';
import '../../features/inventory/services/inventory_mock_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Infrastructure only
  locator.registerLazySingleton<BaseApiService>(
        () => NetworkApiService(),
  );

  locator.registerLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage(),
  );

  locator.registerLazySingleton<StorageService>(
        () => SecureStorageService(
      locator<FlutterSecureStorage>(),
    ),
  );

  // Services
  locator.registerLazySingleton<AuthMockService>(
        () => AuthMockService(),
  );

  locator.registerLazySingleton<InventoryMockService>(
        () => InventoryMockService(),
  );

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      apiService: locator<BaseApiService>(),
      mockService: locator<AuthMockService>(),
      storageService: locator<StorageService>(),
    ),
  );

  locator.registerLazySingleton<InventoryRepository>(
        () => InventoryRepositoryImpl(
      apiService: locator<BaseApiService>(),
      mockService: locator<InventoryMockService>(),
    ),
  );
}