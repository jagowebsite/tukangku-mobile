import 'package:bloc/bloc.dart';
import 'package:tukangku/models/category_service_model.dart';
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
}
