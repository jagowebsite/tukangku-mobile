import 'package:tukangku/models/employee_model.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/models/transaction_model.dart';

class HistoryEmployeeModel {
  int? id, workDuration, salaryEmployee;
  EmployeeModel? employeeModel;
  HistoryEmployeeDetail? historyEmployeeDetail;
  String? typeWorkDuration, description, createdAt;

  HistoryEmployeeModel(
      {this.id,
      this.workDuration,
      this.salaryEmployee,
      this.employeeModel,
      this.historyEmployeeDetail,
      this.typeWorkDuration,
      this.description,
      this.createdAt});

  factory HistoryEmployeeModel.fromJson(Map<String, dynamic> json) {
    return HistoryEmployeeModel(
      id: json['id'],
      workDuration: json['work_duration'],
      salaryEmployee: json['salary_employee'],
      typeWorkDuration: json['type_work_duration'],
      description: json['description'],
      createdAt: json['created_at'],
      employeeModel: json['employee'] != null
          ? EmployeeModel.fromJson(json['employee'])
          : null,
      historyEmployeeDetail: json['order_detail'] != null
          ? HistoryEmployeeDetail.fromJson(json['order_detail'])
          : null,
    );
  }
}

class HistoryEmployeeDetail {
  int? id, quantity, price, totalPrice;
  String? description, statusOrderDetail, verifiedAt;
  TransactionModel? listTransactions;
  ServiceModel? serviceModel;

  HistoryEmployeeDetail(
      {this.id,
      this.quantity,
      this.price,
      this.totalPrice,
      this.description,
      this.statusOrderDetail,
      this.verifiedAt,
      this.listTransactions,
      this.serviceModel});

  factory HistoryEmployeeDetail.fromJson(Map<dynamic, dynamic> json) {
    return HistoryEmployeeDetail(
      id: json['id'],
      quantity: json['quantity'],
      price: json['price'],
      totalPrice: json['total_price'],
      description: json['description'],
      statusOrderDetail: json['status_order_detail'],
      verifiedAt: json['verified_at'],
      listTransactions: json['order'] != null
          ? TransactionModel.fromJson(json['order'])
          : null,
      serviceModel: json['service'] != null
          ? ServiceModel.fromJson(json['service'])
          : null,
    );
  }
}
