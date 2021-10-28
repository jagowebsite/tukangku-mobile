import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tukangku/blocs/design_bloc/design_bloc.dart';
import 'package:tukangku/screens/widgets/service_item.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class Design extends StatefulWidget {
  const Design({Key? key}) : super(key: key);

  @override
  _DesignState createState() => _DesignState();
}

class _DesignState extends State<Design> {
  late DesignBloc _designBloc;
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
      _designBloc.add(GetServiceDesign(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _designBloc.add(GetServiceDesign(10, true));
    print('Refresing...');
  }

  @override
  void initState() {
    _designBloc = BlocProvider.of<DesignBloc>(context);
    _designBloc.add(GetServiceDesign(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  // @override
  // void dispose() {
  //   _designBloc.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DesignBloc, DesignState>(
      listener: (context, state) {
        if (state is ServiceDesignData) {
          _hasReachMax = state.hasReachMax;
        } else if (state is ServiceDesignError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: Column(
            children: [
              Text(
                'Desain',
                style: TextStyle(color: Colors.black87),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/search'),
                child: Container(
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
                                  'Cari desain yang kamu butuhkan sekarang',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 14),
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
            ],
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.all(10),
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.orangeAccent.shade700,
            displacement: 20,
            onRefresh: () => _refresh(),
            child: BlocBuilder<DesignBloc, DesignState>(
              builder: (context, state) {
                if (state is ServiceDesignData) {
                  return GridView.count(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
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
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
