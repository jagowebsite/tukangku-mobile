class User {
  int? id;
  String? email, password, name, dateOfBirth, address, number, images, ktpImage;

  User(
      {this.id,
      this.email,
      this.password,
      this.name,
      this.dateOfBirth,
      this.address,
      this.number,
      this.images,
      this.ktpImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      dateOfBirth: json['date_of_birth'],
      address: json['address'],
      number: json['number'],
      images: json['images'],
      ktpImage: json['ktp_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['name'] = this.name;
    data['date_of_birth'] = this.dateOfBirth;
    data['address'] = this.address;
    data['number'] = this.number;
    data['images'] = this.images;
    data['ktp_image'] = this.ktpImage;
    return data;
  }
}
