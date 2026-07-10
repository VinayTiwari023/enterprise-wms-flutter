class AppUrls {
  // Change this base URL to switch environments
  static const String baseUrl = 'https://reqres.in/api'; // Mock API for testing

  static const String loginEndPoint = '$baseUrl/login';
  static const String registerEndPoint = '$baseUrl/register';
  
  // WMS Specific Endpoints
  static const String getInventory = '$baseUrl/inventory';
  static const String getStats = '$baseUrl/stats';
}
