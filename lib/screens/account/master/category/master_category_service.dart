import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/category_service_bloc/category_service_bloc.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';

class MasterCategoryService extends StatefulWidget {
  const MasterCategoryService({Key? key}) : super(key: key);

  @override
  _MasterCategoryServiceState createState() => _MasterCategoryServiceState();
}

class _MasterCategoryServiceState extends State<MasterCategoryService> {
  late CategoryServiceBloc categoryServiceBloc;

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
      categoryServiceBloc.add(GetServiceCategory(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    categoryServiceBloc.add(GetServiceCategory(10, true));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    categoryServiceBloc.add(GetServiceCategory(10, true));
  }

  @override
  void initState() {
    categoryServiceBloc = BlocProvider.of<CategoryServiceBloc>(context);
    categoryServiceBloc.add(GetServiceCategory(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return BlocListener<CategoryServiceBloc, CategoryServiceState>(
      listener: (context, state) {
        if (state is CategoryServiceData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Kategori Jasa',
                style: TextStyle(color: Colors.black87),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
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
              child: BlocBuilder<CategoryServiceBloc, CategoryServiceState>(
                builder: (context, state) {
                  if (state is CategoryServiceData) {
                    return ListView.builder(
                        itemCount: state.hasReachMax
                            ? state.listCategoryServices.length
                            : state.listCategoryServices.length + 1,
                        itemBuilder: (context, index) {
                          if (index < state.listCategoryServices.length) {
                            return ListTile(
                              onTap: () {},
                              leading: Container(
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  child: ClipOval(
                                    child: CircleAvatar(
                                      child: CustomCachedImage.build(context,
                                          imgUrl: state
                                                  .listCategoryServices[index]
                                                  .images ??
                                              'https://i.pravatar.cc/300'),
                                    ),
                                  ),
                                ),
                              ),
                              title: Container(
                                child: Text(
                                  state.listCategoryServices[index].name ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
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
                        });
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
              ))),
    );
  }
}
