class LoginResponse {
  final String? token;
  final String? userId;
  final String? userName;
  final String? role;

  const LoginResponse({
    this.token,
    this.userId,
    this.userName,
    this.role,
  });

  /// Converts JSON map to LoginResponse instance
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      role: json['role'] as String?,
    );
  }

  /// Converts LoginResponse instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'userName': userName,
      'role': role,
    };
  }
}
