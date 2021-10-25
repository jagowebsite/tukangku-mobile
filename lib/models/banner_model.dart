class BannerModel {
  int? id;
  String? name, images, urlAsset;
  bool? isActive;

  BannerModel({this.id, this.name, this.images, this.urlAsset, this.isActive});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      name: json['name'],
      images: json['images'],
      urlAsset: json['url_asset'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['images'] = this.images;
    data['url_asset'] = this.urlAsset;
    data['is_active'] = this.isActive;
    return data;
  }
}
