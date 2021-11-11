part of 'role_permission_bloc.dart';

abstract class RolePermissionEvent {
  const RolePermissionEvent();
}

class GetRolePermission extends RolePermissionEvent {
  final int limit;
  final bool isInit;
  GetRolePermission(this.limit, this.isInit);
}

class CreateRolePermission extends RolePermissionEvent {
  final RolePermissionModel rolePermissionModel;
  CreateRolePermission(this.rolePermissionModel);
}

class UpdateRolePermission extends RolePermissionEvent {
  final RolePermissionModel rolePermissionModel;
  UpdateRolePermission(this.rolePermissionModel);
}

class DeleteRolePermission extends RolePermissionEvent {
  final RolePermissionModel rolePermissionModel;
  DeleteRolePermission(this.rolePermissionModel);
}
