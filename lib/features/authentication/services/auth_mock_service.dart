class AuthMockService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == "admin@wms.com" && password == "admin123") {
      return {
        "token": "static_token_123",
        "userId": "1",
        "userName": "Vinay Admin",
        "role": "admin",
      };
    } else {
      throw Exception("Invalid email or password");
    }
  }
}
