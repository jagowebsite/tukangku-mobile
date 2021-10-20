class RegisterModel {
  String? name, username, password, confirmPassword;

  RegisterModel(
      {this.name, this.username, this.password, this.confirmPassword});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['password'] = this.password;
    data['confirm_password'] = this.confirmPassword;
    return data;
  }
}
