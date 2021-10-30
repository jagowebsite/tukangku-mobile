part of 'profile_bloc.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class UpdateProfile extends ProfileEvent {
  final User user;
  UpdateProfile(this.user);
}
