class RoleAccessModel {
  final int? id;
  final String? name, guardName;
  final List<RolePermissionModel>? permissions;

  RoleAccessModel({this.id, this.name, this.guardName, this.permissions});

  factory RoleAccessModel.fromJson(Map<String, dynamic> json) {
    return RoleAccessModel(
        id: json['id'],
        name: json['name'],
        guardName: json['guard_name'],
        permissions: json["permission"] != null
            ? List<RolePermissionModel>.from(
                json["permission"].map((e) => RolePermissionModel.fromJson(e)))
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['guard_name'] = this.guardName;
    data['permissions'] = this.permissions;
    return data;
  }
}

class RolePermissionModel {
  final int? id;
  final String? name, guardName;

  RolePermissionModel({this.id, this.name, this.guardName});

  factory RolePermissionModel.fromJson(Map<String, dynamic> json) {
    return RolePermissionModel(
        id: json['id'], name: json['name'], guardName: json['guard_name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['guard_name'] = this.guardName;
    return data;
  }
}
