import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tukangku/blocs/master_service_bloc/master_service_bloc.dart';
import 'package:tukangku/screens/account/master/service/master_service_edit.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class MasterService extends StatefulWidget {
  const MasterService({Key? key}) : super(key: key);

  @override
  _MasterServiceState createState() => _MasterServiceState();
}

class _MasterServiceState extends State<MasterService> {
  TextEditingController searchController = TextEditingController();
  late MasterServiceBloc masterServiceBloc;
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
      masterServiceBloc.add(GetServiceMaster(10, false));
    }
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    masterServiceBloc.add(GetServiceMaster(10, true));
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    searchController.text = '';
    masterServiceBloc.filterService = null;
    masterServiceBloc.add(GetServiceMaster(10, true));
    print('Refresing...');
  }

  @override
  void initState() {
    masterServiceBloc = BlocProvider.of<MasterServiceBloc>(context);
    masterServiceBloc.add(GetServiceMaster(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MasterServiceBloc, MasterServiceState>(
      listener: (context, state) {
        if (state is ServiceMasterData) {
          _hasReachMax = state.hasReachMax;
        } else if (state is ServiceMasterError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Master Data Jasa',
              style: TextStyle(color: Colors.black87),
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed('/master-service-create')
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
          child: BlocBuilder<MasterServiceBloc, MasterServiceState>(
            builder: (context, state) {
              if (state is ServiceMasterData) {
                return Container(
                  margin: EdgeInsets.all(10),
                  child: GridView.count(
                    controller: _scrollController,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 1 / 1.3,
                    crossAxisCount: 2,
                    children: List.generate(
                        state.hasReachMax
                            ? state.listServices.length
                            : state.listServices.length % 2 == 0
                                ? state.listServices.length + 2
                                : state.listServices.length + 1, (index) {
                      if (index < state.listServices.length) {
                        return Container(
                          child: Card(
                            elevation: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MasterServiceEdit(
                                      serviceModel: state.listServices[index]);
                                })).then(onGoBack);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade100),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: state.listServices[index]
                                                      .images!.length !=
                                                  0
                                              ? state.listServices[index]
                                                  .images![0]
                                              : 'https://psdfreebies.com/wp-content/uploads/2019/01/Travel-Service-Banner-Ads-Templates-PSD.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black,
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.black
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0, 0, 0.7, 1],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          state.listServices[index].name ?? '',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
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
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                );
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
        ),
      ),
    );
  }
}
