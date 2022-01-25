class SocialLinkModel {
  int? id;
  String? number, message, link;

  SocialLinkModel({this.id, this.number, this.message, this.link});

  factory SocialLinkModel.fromJson(Map<String, dynamic> json) {
    return SocialLinkModel(
      id: json['id'],
      number: json['number'],
      message: json['message'],
      link: json['link'],
    );
  }
}
