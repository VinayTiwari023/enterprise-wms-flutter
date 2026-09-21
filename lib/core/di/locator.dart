import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../network/base_api_service.dart';
import '../network/network_api_service.dart';

import '../storage/storage_service.dart';
import '../storage/secure_storage_service.dart';
import '../storage/hive_service.dart';
import '../session/session_manager.dart';

import '../../features/authentication/repositories/auth_repository.dart';
import '../../features/authentication/repositories/auth_repository_impl.dart';
import '../../features/authentication/services/auth_mock_service.dart';

import '../../features/inventory/repositories/inventory_repository.dart';
import '../../features/inventory/repositories/inventory_repository_impl.dart';
import '../../features/inventory/services/inventory_mock_service.dart';

import '../../features/shipment/repositories/shipment_repository.dart';
import '../../features/shipment/services/shipment_mock_service.dart';

import '../../features/inward/repositories/inward_repository.dart';
import '../../features/inward/services/inward_mock_service.dart';

import '../../features/picklist/services/picklist_mock_service.dart';
import '../../features/returns/services/returns_mock_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Infrastructure
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  locator.registerLazySingleton<StorageService>(
    () => SecureStorageService(locator<FlutterSecureStorage>()),
  );

  locator.registerLazySingleton<HiveService>(() => HiveService());

  locator.registerLazySingleton<SessionManager>(
    () => SessionManager(locator<StorageService>()),
  );

  locator.registerLazySingleton<BaseApiService>(
    () => NetworkApiService(locator<StorageService>()),
  );

  // Services
  locator.registerLazySingleton<AuthMockService>(() => AuthMockService());

  locator.registerLazySingleton<InventoryMockService>(
    () => InventoryMockService(),
  );

  locator.registerLazySingleton<ShipmentMockService>(
    () => ShipmentMockService(),
  );

  locator.registerLazySingleton<InwardMockService>(() => InwardMockService());

  locator.registerLazySingleton<PicklistMockService>(
    () => PicklistMockService(),
  );

  locator.registerLazySingleton<ReturnsMockService>(() => ReturnsMockService());

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiService: locator<BaseApiService>(),
      mockService: locator<AuthMockService>(),
      sessionManager: locator<SessionManager>(),
    ),
  );

  locator.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(
      apiService: locator<BaseApiService>(),
      mockService: locator<InventoryMockService>(),
      hiveService: locator<HiveService>(),
    ),
  );

  locator.registerLazySingleton<ShipmentRepository>(
    () => ShipmentRepository(
      mockService: locator<ShipmentMockService>(),
      hiveService: locator<HiveService>(),
    ),
  );

  locator.registerLazySingleton<InwardRepository>(
    () => InwardRepository(
      mockService: locator<InwardMockService>(),
      hiveService: locator<HiveService>(),
    ),
  );
}
