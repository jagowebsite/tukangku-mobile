import 'package:bloc/bloc.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/user_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  AuthRepository _authRepo = AuthRepository();
  ProfileRepository _profileRepo = ProfileRepository();

  ProfileBloc() : super(ProfileInitial()) {
    on<UpdateProfile>(_updateProfile);
  }

  Future _updateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(UpdateProfileLoading());
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _profileRepo.updateProfile(_token, event.user);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(UpdateProfileSuccess(responseModel.message ?? ''));
          } else {
            emit(UpdateProfileError(responseModel.message ?? ''));
          }
        } else {
          emit(
              UpdateProfileError('Update profil gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      emit(UpdateProfileError(e.toString()));
    }
  }
}
