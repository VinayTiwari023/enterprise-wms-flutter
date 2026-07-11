import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../network/base_api_service.dart';
import '../network/network_api_service.dart';

import '../storage/storage_service.dart';
import '../storage/secure_storage_service.dart';

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
}