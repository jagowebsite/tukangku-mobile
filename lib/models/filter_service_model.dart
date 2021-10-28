import 'package:tukangku/models/category_service_model.dart';

class FilterServiceModel {
  String? q;
  CategoryServiceModel? categoryService;

  FilterServiceModel({this.q, this.categoryService});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['q'] = this.q;
    data['category'] = this.categoryService!.toJson();
    return data;
  }
}
