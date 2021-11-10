class RoleAccessModel {
  final int? id;
  final String? name, guardName;
  final List<String>? permissions;

  RoleAccessModel({this.id, this.name, this.guardName, this.permissions});

  factory RoleAccessModel.fromJson(Map<String, dynamic> json) {
    return RoleAccessModel(
        id: json['id'],
        name: json['name'],
        guardName: json['guard_name'],
        permissions: json["permissions"] != null
            ? List<String>.from(json["permissions"])
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
