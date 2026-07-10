class UserModel {
  String? token;
  String? email;
  String? name;

  UserModel({this.token, this.email, this.name});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    email = json['email'];
    name = json['name'] ?? 'User';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['email'] = email;
    data['name'] = name;
    return data;
  }
}
