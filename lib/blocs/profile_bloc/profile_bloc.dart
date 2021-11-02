import 'dart:io';

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
    on<UpdatePhoto>(_updatePhoto);
    on<ChangePassword>(_changePassword);
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

  Future _updatePhoto(UpdatePhoto event, Emitter<ProfileState> emit) async {
    emit(UpdatePhotoLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _profileRepo.updatePhoto(_token, event.file);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(UpdatePhotoSuccess(responseModel.message ?? ''));
          } else {
            emit(UpdatePhotoError(responseModel.message ?? ''));
          }
        } else {
          emit(UpdatePhotoError('Update foto gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      emit(UpdatePhotoError(e.toString()));
    }
  }

  Future _changePassword(
      ChangePassword event, Emitter<ProfileState> emit) async {
    emit(ChangePasswordLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel = await _profileRepo.updatePassword(
            _token, event.currentPass, event.newPass, event.confirmPass);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(ChangePasswordSuccess(responseModel.message ?? ''));
          } else {
            emit(ChangePasswordError(responseModel.message ?? ''));
          }
        } else {
          emit(ChangePasswordError('Update foto gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      emit(ChangePasswordError(e.toString()));
    }
  }
}
