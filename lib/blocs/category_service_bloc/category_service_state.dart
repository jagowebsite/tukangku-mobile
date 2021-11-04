part of 'category_service_bloc.dart';

abstract class CategoryServiceState {
  const CategoryServiceState();
}

class CategoryServiceInitial extends CategoryServiceState {}

class GetCategoryServiceLoading extends CategoryServiceState {}

class CategoryServiceData extends CategoryServiceState {
  final List<CategoryServiceModel> listCategoryServices;
  final bool hasReachMax;
  CategoryServiceData(this.listCategoryServices, this.hasReachMax);
}

class CategoryServiceSuccess extends CategoryServiceState {
  final String message;
  CategoryServiceSuccess(this.message);
}

class CategoryServiceError extends CategoryServiceState {
  final String message;
  CategoryServiceError(this.message);
}

class CreateCategoryServiceLoading extends CategoryServiceState {}

class CreateCategoryServiceSuccess extends CategoryServiceState {
  final String message;
  CreateCategoryServiceSuccess(this.message);
}

class CreateCategoryServiceError extends CategoryServiceState {
  final String message;
  CreateCategoryServiceError(this.message);
}

class UpdateCategoryServiceLoading extends CategoryServiceState {}

class UpdateCategoryServiceSuccess extends CategoryServiceState {
  final String message;
  UpdateCategoryServiceSuccess(this.message);
}

class UpdateCategoryServiceError extends CategoryServiceState {
  final String message;
  UpdateCategoryServiceError(this.message);
}

class DeleteCategoryServiceLoading extends CategoryServiceState {}

class DeleteCategoryServiceSuccess extends CategoryServiceState {
  final String message;
  DeleteCategoryServiceSuccess(this.message);
}

class DeleteCategoryServiceError extends CategoryServiceState {
  final String message;
  DeleteCategoryServiceError(this.message);
}
