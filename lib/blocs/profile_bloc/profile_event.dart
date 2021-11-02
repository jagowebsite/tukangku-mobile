part of 'profile_bloc.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class UpdateProfile extends ProfileEvent {
  final User user;
  UpdateProfile(this.user);
}

class UpdatePhoto extends ProfileEvent {
  final File file;
  UpdatePhoto(this.file);
}

class ChangePassword extends ProfileEvent {
  final String currentPass, newPass, confirmPass;
  ChangePassword(this.currentPass, this.newPass, this.confirmPass);
}
