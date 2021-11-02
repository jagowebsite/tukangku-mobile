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
  String? token, message, status;
  bool? verified;

  LoginData({this.token, this.verified, this.message, this.status});

  factory LoginData.toJson(Map<String, dynamic> json) {
    return LoginData(
        status: json['status'],
        token: json['data'] != null ? json['data']['token'] : null,
        verified: json['data'] != null ? json['data']['verified'] : null,
        message: json['message']);
  }
}
