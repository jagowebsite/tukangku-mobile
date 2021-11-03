part of 'banner_bloc.dart';

abstract class BannerEvent {
  const BannerEvent();
}

class GetBanner extends BannerEvent {
  final int limit;
  final bool isInit;
  GetBanner(this.limit, this.isInit);
}

class CreateBanner extends BannerEvent {
  final BannerModel bannerModel;
  CreateBanner(this.bannerModel);
}

class UpdateBanner extends BannerEvent {
  final BannerModel bannerModel;
  UpdateBanner(this.bannerModel);
}

class DeleteBanner extends BannerEvent {
  final BannerModel bannerModel;
  DeleteBanner(this.bannerModel);
}
