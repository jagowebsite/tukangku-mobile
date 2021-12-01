import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tukangku/blocs/service_bloc/service_bloc.dart';
import 'package:tukangku/models/category_service_model.dart';
import 'package:tukangku/models/filter_service_model.dart';
import 'package:tukangku/screens/widgets/service_item.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class Services extends StatefulWidget {
  final FilterServiceModel filterService;
  const Services({Key? key, required this.filterService}) : super(key: key);

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  TextEditingController searchController = TextEditingController();
  late ServiceBloc serviceBloc;
  ScrollController _scrollController = ScrollController();
  CategoryServiceModel? categoryService;

  /// Set default hasReachMax value false
  /// Variabel ini digunakan untuk menangani agaer scrollController tidak-
  /// Berlangsung terus menerus.
  bool _hasReachMax = false;

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && !_hasReachMax) {
      print('iam scrolling');
      serviceBloc.add(GetService(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    searchController.text = '';
    serviceBloc.filterService = null;
    serviceBloc.add(GetService(10, true));

    setState(() {
      categoryService = null;
    });
    print('Refresing...');
  }

  @override
  void initState() {
    categoryService = widget.filterService.categoryService;
    serviceBloc = BlocProvider.of<ServiceBloc>(context);
    serviceBloc.filterService = FilterServiceModel(
        q: widget.filterService.q,
        categoryService: widget.filterService.categoryService);
    serviceBloc.add(GetService(10, true));

    searchController.text = widget.filterService.q ?? '';

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceBloc, ServiceState>(
      listener: (context, state) {
        if (state is ServiceData) {
          _hasReachMax = state.hasReachMax;
        } else if (state is ServiceError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 25,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.black87,
            icon: Icon(Icons.arrow_back),
          ),
          title: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    textAlignVertical: TextAlignVertical.bottom,
                    maxLines: 1,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      serviceBloc.filterService =
                          FilterServiceModel(q: searchController.text);
                      serviceBloc.add(GetService(10, true));
                    },
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.only(left: 10, top: 6, bottom: 11),
                        hintText: 'Cari layanan disini...',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: 14),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          size: 25,
                          color: Colors.grey,
                        )),
                  ),
                ),
              ])),
          // actions: [
          //   IconButton(
          //     constraints: BoxConstraints(),
          //     padding: EdgeInsets.zero,
          //     onPressed: () => Navigator.of(context).pushNamed('/filter'),
          //     color: Colors.black87,
          //     icon: Icon(Icons.filter_alt),
          //   ),
          //   SizedBox(
          //     width: 5,
          //   )
          // ],
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.orangeAccent.shade700,
          displacement: 20,
          onRefresh: () => _refresh(),
          child: BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              if (state is ServiceData) {
                return GridView.count(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(10),
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
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      );
                    }
                  }),
                );
              } else {
                return Center(
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.orangeAccent,
                        strokeWidth: 3,
                      )),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
