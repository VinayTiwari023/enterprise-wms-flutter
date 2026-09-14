enum Environment { dev, staging, prod }

class AppConfig {
  static Environment environment = Environment.dev;

  static String get baseUrl {
    switch (environment) {
      case Environment.dev:
        return 'https://reqres.in/api';
      case Environment.staging:
        return 'https://staging-wms.example.com/api';
      case Environment.prod:
        return 'https://wms.example.com/api';
    }
  }

  static bool get isDev => environment == Environment.dev;
}
