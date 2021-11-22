import 'package:bloc/bloc.dart';
import 'package:tukangku/models/banner_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/banner_repository.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  AuthRepository _authRepo = AuthRepository();
  BannerRepository _bannerRepo = BannerRepository();
  List<BannerModel> listBanners = [];
  int page = 1;

  BannerBloc() : super(BannerInitial()) {
    on<GetBanner>(_getBanner);
    on<CreateBanner>(_createBanner);
    on<UpdateBanner>(_updateBanner);
    on<DeleteBanner>(_deleteBanner);
  }

  Future _getBanner(GetBanner event, Emitter<BannerState> emit) async {
    try {
      if (event.isInit) {
        print('Get init transaction detail ...');
        page = 1;
        emit(GetBannerLoading());
        List<BannerModel>? data =
            await _bannerRepo.getBanners(page: page, limit: event.limit);
        if (data != null) {
          listBanners = data;
          data.length < event.limit
              ? emit(BannerData(listBanners, true))
              : emit(BannerData(listBanners, false));
        } else {
          emit(BannerData(listBanners, false));
        }
      } else {
        print('Get more transaction detail ...');
        page++;
        List<BannerModel>? data =
            await _bannerRepo.getBanners(page: page, limit: event.limit);
        if (data != null) {
          listBanners.addAll(data);
          data.length < event.limit
              ? emit(BannerData(listBanners, true))
              : emit(BannerData(listBanners, false));
        } else {
          emit(BannerData(listBanners, false));
        }
      }
    } catch (e) {
      emit(BannerError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _createBanner(CreateBanner event, Emitter<BannerState> emit) async {
    emit(CreateBannerLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _bannerRepo.createBanner(_token, event.bannerModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(CreateBannerSuccess(responseModel.message ?? ''));
          } else {
            emit(CreateBannerError(responseModel.message ?? ''));
          }
        } else {
          emit(CreateBannerError('Tambah banner gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(CreateBannerError('Tambah banner gagal, silahkan coba kembali'));
    }
  }

  Future _updateBanner(UpdateBanner event, Emitter<BannerState> emit) async {
    emit(UpdateBannerLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _bannerRepo.updateBanner(_token, event.bannerModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(UpdateBannerSuccess(responseModel.message ?? ''));
          } else {
            emit(UpdateBannerError(responseModel.message ?? ''));
          }
        } else {
          emit(UpdateBannerError('Update banner gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(UpdateBannerError('Update banner gagal, silahkan coba kembali'));
    }
  }

  Future _deleteBanner(DeleteBanner event, Emitter<BannerState> emit) async {
    emit(DeleteBannerLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _bannerRepo.deleteBanner(_token, event.bannerModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(DeleteBannerSuccess(responseModel.message ?? ''));
          } else {
            emit(DeleteBannerError(responseModel.message ?? ''));
          }
        } else {
          emit(DeleteBannerError('Delete banner gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(DeleteBannerError('Delete banner gagal, silahkan coba kembali'));
    }
  }
}
