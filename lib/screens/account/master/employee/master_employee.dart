import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/employee_bloc/employee_bloc.dart';
import 'package:tukangku/screens/account/master/employee/master_employee_edit.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';

class MasterEmployee extends StatefulWidget {
  const MasterEmployee({Key? key}) : super(key: key);

  @override
  _MasterEmployeeState createState() => _MasterEmployeeState();
}

class _MasterEmployeeState extends State<MasterEmployee> {
  late EmployeeBloc employeeBloc;
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
      employeeBloc.add(GetEmployee(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    employeeBloc.add(GetEmployee(10, true));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    employeeBloc.add(GetEmployee(10, true));
  }

  List<String> employees = [
    'Pak Budi',
    'Andriono Sujiwo',
    'Lukito Muldoko',
    'Sudijo Buwono'
  ];

  @override
  void initState() {
    employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    employeeBloc.add(GetEmployee(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeData) {}
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Master Data Tukang',
                style: TextStyle(color: Colors.black87),
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed('/master-employee-create')
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
            child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeData) {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        if (index < state.listEmployees.length) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MasaterEmployeeEdit(
                                    employeeModel: state.listEmployees[index]);
                              })).then(onGoBack);
                            },
                            leading: Container(
                              decoration: BoxDecoration(
                                  color: Colors.orange, shape: BoxShape.circle),
                              child: Container(
                                width: 45,
                                height: 45,
                                child: ClipOval(
                                  child: CircleAvatar(
                                    child: CustomCachedImage.build(context,
                                        imgUrl:
                                            state.listEmployees[index].images ??
                                                'https://i.pravatar.cc/300'),
                                  ),
                                ),
                              ),
                            ),
                            title: Container(
                              child: Text(
                                state.listEmployees[index].name ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            subtitle: Text(state.listEmployees[index]
                                    .categoryService!.name ??
                                ''),
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
                          ? state.listEmployees.length
                          : state.listEmployees.length + 1);
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
