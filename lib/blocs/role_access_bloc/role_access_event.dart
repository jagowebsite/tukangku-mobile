part of 'role_access_bloc.dart';

abstract class RoleAccessEvent {
  const RoleAccessEvent();
}

class GetRoleAccess extends RoleAccessEvent {
  final int limit;
  final bool isInit;
  GetRoleAccess(this.limit, this.isInit);
}

class CreateRoleAccess extends RoleAccessEvent {
  final RoleAccessModel roleAccessModel;
  CreateRoleAccess(this.roleAccessModel);
}

class UpdateRoleAccess extends RoleAccessEvent {
  final RoleAccessModel roleAccessModel;
  UpdateRoleAccess(this.roleAccessModel);
}

class DeleteRoleAccess extends RoleAccessEvent {
  final RoleAccessModel roleAccessModel;
  DeleteRoleAccess(this.roleAccessModel);
}
