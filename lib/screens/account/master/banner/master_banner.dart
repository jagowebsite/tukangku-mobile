import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/banner_bloc/banner_bloc.dart';
import 'package:tukangku/screens/account/master/banner/master_banner_edit.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';

class MasterBanner extends StatefulWidget {
  const MasterBanner({Key? key}) : super(key: key);

  @override
  _MasterBannerState createState() => _MasterBannerState();
}

class _MasterBannerState extends State<MasterBanner> {
  late BannerBloc bannerBloc;
  ScrollController _scrollController = ScrollController();

  /// Set default hasReachMax value false
  /// Variabel ini digunakan untuk menangani agaer scrollController tidak-
  /// Berlangsung terus menerus.
  bool _hasReachMax = false;

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && !_hasReachMax) {
      print('iam scrolling');
      bannerBloc.add(GetBanner(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    bannerBloc.add(GetBanner(10, true));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    bannerBloc.add(GetBanner(10, true));
  }

  @override
  void initState() {
    bannerBloc = BlocProvider.of<BannerBloc>(context);
    bannerBloc.add(GetBanner(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BannerBloc, BannerState>(
      listener: (context, state) {
        if (state is BannerData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Master Data Banner',
                style: TextStyle(color: Colors.black87),
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed('/master-banner-create')
                      .then(onGoBack),
                  icon: Icon(
                    Icons.add,
                    color: Colors.black87,
                  ),
                )
              ],
              centerTitle: true,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  ))),
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.orangeAccent.shade700,
            displacement: 20,
            onRefresh: () => _refresh(),
            child: BlocBuilder<BannerBloc, BannerState>(
              builder: (context, state) {
                if (state is BannerData) {
                  return ListView.separated(
                      controller: _scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index < state.listBanners.length) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MasterBannerEdit(
                                    bannerModel: state.listBanners[index]);
                              })).then(onGoBack);
                            },
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: ClipRRect(
                                  child: CustomCachedImage.build(
                                context,
                                imgUrl: state.listBanners[index].images ??
                                    'https://picsum.photos/64',
                              )),
                            ),
                            title: Container(
                              child: Text(
                                state.listBanners[index].name ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            subtitle: Text(
                                state.listBanners[index].isActive != null
                                    ? (state.listBanners[index].isActive!
                                        ? 'Aktif'
                                        : 'Nonaktif')
                                    : ''),
                            trailing: Icon(Icons.chevron_right,
                                color: Colors.black87),
                          );
                        } else {
                          return Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                  color: Colors.orange.shade600,
                                  strokeWidth: 2),
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 0.3,
                        );
                      },
                      itemCount: state.hasReachMax
                          ? state.listBanners.length
                          : state.listBanners.length + 1);
                } else {
                  return Center(
                      child: Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                        color: Colors.orange.shade600, strokeWidth: 3),
                  ));
                }
              },
            ),
          )),
    );
  }
}
