part of 'category_service_bloc.dart';

abstract class CategoryServiceEvent {
  const CategoryServiceEvent();
}

class GetServiceCategory extends CategoryServiceEvent {
  final int limit;
  final bool isInit;
  GetServiceCategory(this.limit, this.isInit);
}

class CreateServiceCategory extends CategoryServiceEvent {
  final CategoryServiceModel categoryService;
  CreateServiceCategory(this.categoryService);
}

class UpdateServiceCategory extends CategoryServiceEvent {
  final CategoryServiceModel categoryService;
  UpdateServiceCategory(this.categoryService);
}

class DeleteServiceCategory extends CategoryServiceEvent {
  final CategoryServiceModel categoryService;
  DeleteServiceCategory(this.categoryService);
}
