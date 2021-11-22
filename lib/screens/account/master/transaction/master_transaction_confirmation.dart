import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/transaction_detail_bloc/transaction_detail_bloc.dart';
import 'package:tukangku/models/employee_model.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/employee_repository.dart';
import 'package:tukangku/screens/widgets/bottom_sheet_modal.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class MasterTransactionConfirmation extends StatefulWidget {
  final TransactionDetail transactionDetail;
  const MasterTransactionConfirmation(
      {Key? key, required this.transactionDetail})
      : super(key: key);

  @override
  _MasterTransactionConfirmationState createState() =>
      _MasterTransactionConfirmationState();
}

class _MasterTransactionConfirmationState
    extends State<MasterTransactionConfirmation> {
  EmployeeRepository employeeRepo = EmployeeRepository();
  AuthRepository authRepo = AuthRepository();
  late TransactionDetailBloc transactionDetailBloc;

  TextEditingController salaryController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<EmployeeModel> listEmployees = [];
  EmployeeModel? employeeSelected;

  Future getEmployee() async {
    String? _token = await authRepo.hasToken();
    List<EmployeeModel>? data = await employeeRepo.getEmployees(_token!);
    if (data != null) {
      if (data.length != 0) {
        employeeSelected = data[0];
      }
      listEmployees = data;
    }
    setState(() {});
  }

  Future confirmTransaction() async {
    if (salaryController.text == '' ||
        employeeSelected == null ||
        durationController.text == '' ||
        typeController.text == '') {
      CustomSnackbar.showSnackbar(
          context, 'Input tidak boleh ada yang kosong', SnackbarType.warning);
    } else {
      TransactionDetail transactionDetail = TransactionDetail(
        id: widget.transactionDetail.id,
        employeeModel: employeeSelected,
        typeWorkDuration: typeController.text.toLowerCase(),
        workDuration: durationController.text,
        salaryEmployee: int.parse(salaryController.text),
        description: descriptionController.text,
      );
      transactionDetailBloc.add(ConfirmTransactionDetail(transactionDetail));
    }
  }

  Future cancelTransaction() async {
    BottomSheetModal.show(context, children: [
      const Text('Apakah kamu yakin ingin membatalkan transaksi?'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(primary: Colors.orangeAccent.shade700),
            child: const Text('Ya, batalkan',
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              transactionDetailBloc
                  .add(CancelTransactionDetail(widget.transactionDetail.id!));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ]);
  }

  @override
  void initState() {
    transactionDetailBloc = BlocProvider.of<TransactionDetailBloc>(context);
    typeController.text = widget.transactionDetail.serviceModel!.typeQuantity!;
    getEmployee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<TransactionDetailBloc, TransactionDetailState>(
      listener: (context, state) {
        if (state is ConfirmTransactionDetailSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is ConfirmTransactionDetailError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        } else if (state is CancelTransactionDetailSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is CancelTransactionDetailError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Konfirmasi Transaksi',
                style: TextStyle(color: Colors.black87),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  ))),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      width: size.width,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: Text(
                                'Data Konfirmasi',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Pilih Tukang'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: DropdownButton<EmployeeModel>(
                              dropdownColor: Colors.grey.shade100,
                              value: employeeSelected,
                              isExpanded: true,
                              icon: Icon(Icons.expand_more),
                              iconSize: 24,
                              elevation: 1,
                              style: TextStyle(color: Colors.black),
                              underline: Container(),
                              onChanged: (EmployeeModel? newValue) {
                                setState(() {
                                  employeeSelected = newValue!;
                                });
                              },
                              items: listEmployees.map((EmployeeModel value) {
                                return DropdownMenuItem<EmployeeModel>(
                                  value: value,
                                  child: Text(value.name ?? ''),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Upah Tukang'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: salaryController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Jumlah/Durasi Kerja'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: durationController,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Tipe Durasi Kerja'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              readOnly: true,
                              controller: typeController,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Deskripsi (Opsional)'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: descriptionController,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 7,
                                offset: Offset(0, 5),
                              )
                            ],
                          ),
                          child: Container(
                            color: Colors.red.shade500,
                            child: TextButton(
                              onPressed: () => cancelTransaction(),
                              child: Text('Batalkan',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 7,
                                offset: Offset(0, 5),
                              )
                            ],
                          ),
                          child: Container(
                            color: Colors.green.shade600,
                            child: TextButton(
                              onPressed: () => confirmTransaction(),
                              child: Text('Konfirmasi',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<TransactionDetailBloc, TransactionDetailState>(
                builder: (context, state) {
                  if (state is ConfirmTransactionDetailLoading ||
                      state is CancelTransactionDetailLoading) {
                    return Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Center(
                          child: Container(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                color: Colors.orangeAccent.shade700,
                                strokeWidth: 3,
                              )),
                        ));
                  } else {
                    return Container();
                  }
                },
              )
            ],
          )),
    );
  }
}
