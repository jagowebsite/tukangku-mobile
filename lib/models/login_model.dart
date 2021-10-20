class LoginModel {
  String? username, password;

  LoginModel({this.username, this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}

class LoginData {
  String? token;
  bool? verified;

  LoginData({this.token, this.verified});

  factory LoginData.toJson(Map<String, dynamic> json) {
    return LoginData(token: json['token'], verified: json['verified']);
  }
}
