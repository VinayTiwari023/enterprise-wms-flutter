import 'package:get_it/get_it.dart';
import '../network/base_api_service.dart';
import '../network/network_api_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Infrastructure only
  locator.registerLazySingleton<BaseApiService>(() => NetworkApiService());
  
  // TODO: Register Logger, Hive, SharedPreferences, SecureStorage here
}
