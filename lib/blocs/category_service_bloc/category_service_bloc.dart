import 'package:bloc/bloc.dart';
import 'package:tukangku/models/category_service_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/category_service_repository.dart';

part 'category_service_event.dart';
part 'category_service_state.dart';

class CategoryServiceBloc
    extends Bloc<CategoryServiceEvent, CategoryServiceState> {
  AuthRepository _authRepo = AuthRepository();
  CategoryServiceRepository _categoryServiceRepo = CategoryServiceRepository();
  List<CategoryServiceModel> listCategories = [];
  int page = 1;

  CategoryServiceBloc() : super(CategoryServiceInitial()) {
    on<GetServiceCategory>(_getServiceCategory);
    on<CreateServiceCategory>(_createCategoryService);
    on<UpdateServiceCategory>(_updateCategoryService);
    on<DeleteServiceCategory>(_deleteCategoryService);
  }

  Future _getServiceCategory(
      GetServiceCategory event, Emitter<CategoryServiceState> emit) async {
    try {
      if (event.isInit) {
        print('Get init Banner ...');
        page = 1;
        emit(GetCategoryServiceLoading());
        List<CategoryServiceModel>? data = await _categoryServiceRepo
            .getCategoryServices(page: page, limit: event.limit);
        if (data != null) {
          listCategories = data;
          data.length < event.limit
              ? emit(CategoryServiceData(listCategories, true))
              : emit(CategoryServiceData(listCategories, false));
        } else {
          emit(CategoryServiceData(listCategories, false));
        }
      } else {
        print('Get more banner ...');
        page++;
        List<CategoryServiceModel>? data = await _categoryServiceRepo
            .getCategoryServices(page: page, limit: event.limit);
        if (data != null) {
          listCategories.addAll(data);
          data.length < event.limit
              ? emit(CategoryServiceData(listCategories, true))
              : emit(CategoryServiceData(listCategories, false));
        } else {
          emit(CategoryServiceData(listCategories, false));
        }
      }
    } catch (e) {
      emit(CategoryServiceError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _createCategoryService(
      CreateServiceCategory event, Emitter<CategoryServiceState> emit) async {
    emit(CreateCategoryServiceLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel = await _categoryServiceRepo
            .createCategoryService(_token, event.categoryService);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(CreateCategoryServiceSuccess(responseModel.message ?? ''));
          } else {
            emit(CreateCategoryServiceError(responseModel.message ?? ''));
          }
        } else {
          emit(CreateCategoryServiceError(
              'Tambah kategori service gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(CreateCategoryServiceError(
          'Tambah kategori service gagal, silahkan coba kembali'));
    }
  }

  Future _updateCategoryService(
      UpdateServiceCategory event, Emitter<CategoryServiceState> emit) async {
    emit(UpdateCategoryServiceLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel = await _categoryServiceRepo
            .updateCategoryService(_token, event.categoryService);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(UpdateCategoryServiceSuccess(responseModel.message ?? ''));
          } else {
            emit(UpdateCategoryServiceError(responseModel.message ?? ''));
          }
        } else {
          emit(UpdateCategoryServiceError(
              'Update kategori service, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(UpdateCategoryServiceError(
          'Update kategori service, silahkan coba kembali'));
    }
  }

  Future _deleteCategoryService(
      DeleteServiceCategory event, Emitter<CategoryServiceState> emit) async {
    emit(DeleteCategoryServiceLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel = await _categoryServiceRepo
            .deleteCategoryService(_token, event.categoryService);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(DeleteCategoryServiceSuccess(responseModel.message ?? ''));
          } else {
            emit(DeleteCategoryServiceError(responseModel.message ?? ''));
          }
        } else {
          emit(DeleteCategoryServiceError(
              'Delete kategori service, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(DeleteCategoryServiceError(
          'Delete kategori service, silahkan coba kembali'));
    }
  }
}
