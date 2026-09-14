import 'app_config.dart';

class AppUrls {
  static String get baseUrl => AppConfig.baseUrl;

  static String get loginEndPoint => '$baseUrl/login';
  static String get registerEndPoint => '$baseUrl/register';

  // WMS Specific Endpoints
  static String get getInventory => '$baseUrl/inventory';
  static String get getStats => '$baseUrl/stats';
}
