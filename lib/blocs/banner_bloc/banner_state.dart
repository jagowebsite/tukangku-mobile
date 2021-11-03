part of 'banner_bloc.dart';

abstract class BannerState {
  const BannerState();
}

class BannerInitial extends BannerState {}

class GetBannerLoading extends BannerState {}

class BannerData extends BannerState {
  final List<BannerModel> listBanners;
  final bool hasReachMax;
  BannerData(this.listBanners, this.hasReachMax);
}

class BannerSuccess extends BannerState {
  final String message;
  BannerSuccess(this.message);
}

class BannerError extends BannerState {
  final String message;
  BannerError(this.message);
}

class CreateBannerLoading extends BannerState {}

class CreateBannerSuccess extends BannerState {
  final String message;
  CreateBannerSuccess(this.message);
}

class CreateBannerError extends BannerState {
  final String message;
  CreateBannerError(this.message);
}

class UpdateBannerLoading extends BannerState {}

class UpdateBannerSuccess extends BannerState {
  final String message;
  UpdateBannerSuccess(this.message);
}

class UpdateBannerError extends BannerState {
  final String message;
  UpdateBannerError(this.message);
}

class DeleteBannerLoading extends BannerState {}

class DeleteBannerSuccess extends BannerState {
  final String message;
  DeleteBannerSuccess(this.message);
}

class DeleteBannerError extends BannerState {
  final String message;
  DeleteBannerError(this.message);
}
