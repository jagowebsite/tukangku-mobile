import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tukangku/blocs/auth_bloc/auth_bloc.dart';
import 'package:tukangku/blocs/home_bloc/home_bloc.dart';
import 'package:tukangku/hive/cart/cart_hive.dart';
import 'package:tukangku/models/banner_model.dart';
import 'package:tukangku/models/category_service_model.dart';
import 'package:tukangku/models/filter_service_model.dart';
import 'package:tukangku/models/social_link_model.dart';
import 'package:tukangku/models/user_model.dart';
import 'package:tukangku/repositories/banner_repository.dart';
import 'package:tukangku/repositories/category_service_repository.dart';
import 'package:tukangku/repositories/profile_repository.dart';
import 'package:tukangku/screens/account/profile/update_profile.dart';
import 'package:tukangku/screens/service/services.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';
import 'package:tukangku/screens/widgets/service_item.dart';
import 'package:tukangku/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  BannerRepository _bannerRepo = BannerRepository();
  CategoryServiceRepository _categoryServiceRepo = CategoryServiceRepository();
  ProfileRepository _profileRepository = ProfileRepository();
  late AuthBloc authBloc;
  late Box cartBox;

  ScrollController _scrollController = ScrollController();

  String? linkSocial;

  // Bloc
  late HomeBloc homeBloc;

  /// Set default hasReachMax value false
  /// Variabel ini digunakan untuk menangani agaer scrollController tidak-
  /// Berlangsung terus menerus.
  bool _hasReachMax = false;

  List<BannerModel>? listBanner;
  List<CategoryServiceModel>? listCategoryService;

  Future getBanner() async {
    listBanner = await _bannerRepo.getBanners();
    setState(() {});
  }

  Future getCategoryService() async {
    listCategoryService = await _categoryServiceRepo.getCategoryServices();
    setState(() {});
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    setState(() {});
  }

  Future getLinkSocial() async {
    SocialLinkModel? socialLink = await _profileRepository.getSocialLink();

    if (socialLink != null) {
      linkSocial = socialLink.link;
      setState(() {});
    }
  }

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && !_hasReachMax) {
      print('iam scrolling');
      homeBloc.add(GetServiceHome(8, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    getInitData();
    print('Refresing...');
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat pagi';
    }
    if (hour < 17) {
      return 'Selamat sore';
    }
    return 'Selamat malam';
  }

  getInitData() {
    getBanner();
    getCategoryService();
    authBloc.add(GetAuthData());
    homeBloc.add(GetServiceHome(8, true));
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  bool validation(User user) {
    if (user.name == '' ||
        user.address == '' ||
        user.ktpImage == '' ||
        user.dateOfBirth == '' ||
        user.number == '') {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    cartBox = Hive.box<CartHive>('cart');
    getInitData();
    getLinkSocial();
    _scrollController.addListener(onScroll);
    super.initState();
  }

  // @override
  // void dispose() {
  //   homeBloc.close();
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is ServiceHomeError) {
              CustomSnackbar.showSnackbar(
                  context, state.message, SnackbarType.error);
            } else if (state is ServiceHomeData) {
              _hasReachMax = state.hasReachMax;
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authorized) {
              print('im here boss');
              if (!validation(state.user)) {
                CustomSnackbar.showSnackbar(
                    context,
                    'Mohon lengkapi data anda terlebih dahulu',
                    SnackbarType.warning);
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const UpdateProfil(
                            isInit: true,
                          )),
                  ModalRoute.withName('/update-profile'),
                );
              }
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${greeting()},',
                style: TextStyle(color: Colors.black87, fontSize: 12),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Text(
                    state is Authorized
                        ? (state.user.name ?? '...')
                        : 'Cari Apa Hari Ini?',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  );
                },
              )
            ],
          ),
          actions: [
            linkSocial != null
                ? IconButton(
                    onPressed: () {
                      _launchURL(linkSocial!);
                    },
                    icon: SizedBox(
                        width: 28,
                        child: Image.asset('assets/logo/whatsapp.png')))
                : Container(),
            IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/cart').then(onGoBack),
              icon: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.grey.shade400,
                      size: 30,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: cartBox.length != 0
                        // ? Icon(
                        //     Icons.circle,
                        //     color: Colors.orangeAccent.shade700,
                        //     size: 15,
                        //   )
                        ? Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orangeAccent.shade700),
                            child: Center(
                              child: Text(cartBox.length.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.orangeAccent.shade700,
          displacement: 20,
          onRefresh: () => _refresh(),
          child: CustomScrollView(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  listBanner != null
                      ? Container(
                          width: size.width,
                          height: size.height * 0.2,
                          margin: EdgeInsets.only(top: 10),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 2.0,
                              enlargeCenterPage: true,
                            ),
                            items: listBanner!
                                .map((item) => GestureDetector(
                                      onTap: () {
                                        _launchURL(item.urlAsset);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: CustomCachedImage.build(
                                              context,
                                              imgUrl: item.images ??
                                                  'https://medi-call.id/img/content/slider/Banner%20HCC%203%20Medi-Call-01.jpg')),
                                    ))
                                .toList(),
                          ),
                        )
                      : Container()
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed('/search')
                        .then(onGoBack),
                    child: Container(
                        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [
                          Expanded(
                            child: TextField(
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  isDense: true,
                                  enabled: false,
                                  contentPadding:
                                      EdgeInsets.only(top: 6, bottom: 11),
                                  hintText:
                                      'Cari layanan yang kamu butuhkan sekarang',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 25,
                                    color: Colors.grey,
                                  )),
                            ),
                          ),
                        ])),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  listCategoryService != null
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Kategori Layanan',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)))
                      : Container(),
                  SizedBox(
                    height: 5,
                  ),
                  listCategoryService != null
                      ? Container(
                          height: 100,
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              padding: EdgeInsets.all(15),
                              scrollDirection: Axis.horizontal,
                              itemCount: listCategoryService!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    FilterServiceModel filterServiceModel =
                                        FilterServiceModel(
                                            categoryService:
                                                listCategoryService![index]);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Services(
                                          filterService: filterServiceModel);
                                    }));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 15),
                                    width: 60,
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            height: 40,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  listCategoryService![index]
                                                      .images!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          listCategoryService![index].name!,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container(),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text('Semua Layanan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700))),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is ServiceHomeData) {
                          return GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 80),
                            childAspectRatio: 1 / 1.3,
                            crossAxisCount: 2,
                            children: List.generate(
                                state.hasReachMax
                                    ? state.listServices.length
                                    : state.listServices.length % 2 == 0
                                        ? state.listServices.length + 2
                                        : state.listServices.length + 1,
                                (index) {
                              if (index < state.listServices.length) {
                                return ServiceItem(
                                    serviceModel: state.listServices[index]);
                              } else {
                                return Card(
                                  elevation: 0,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                );
                              }
                            }),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ])),
              ]),
        ),
      ),
    );
  }
}
