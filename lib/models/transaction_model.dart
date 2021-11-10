import 'package:tukangku/models/employee_model.dart';
import 'package:tukangku/models/service_model.dart';

class TransactionModel {
  final int? id;
  final String? invoiceId, statusOrder;
  final TransactionDetail? transactionDetail;

  TransactionModel(
      {this.id, this.invoiceId, this.statusOrder, this.transactionDetail});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      invoiceId: json['invoice_id'],
      statusOrder: json['status_order'],
      transactionDetail: json['transaction_detail'] != null
          ? TransactionDetail.fromJson(json['transaction_detail'])
          : null,
    );
  }
}

class TransactionDetail {
  final int? id, quantity, price, totalPrice, salaryEmployee;
  final String? description, statusOrderDetail, workDuration, typeWorkDuration;
  final ServiceModel? serviceModel;
  final EmployeeModel? employeeModel;

  TransactionDetail(
      {this.id,
      this.quantity,
      this.price,
      this.totalPrice,
      this.description,
      this.statusOrderDetail,
      this.workDuration,
      this.typeWorkDuration,
      this.salaryEmployee,
      this.employeeModel,
      this.serviceModel});

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      id: json['id'],
      quantity: json['quantity'],
      price: json['price'],
      totalPrice: json['total_price'],
      description: json['description'],
      statusOrderDetail: json['status_order_detail'],
      serviceModel: json['service'] != null
          ? ServiceModel.fromJson(json['service'])
          : null,
    );
  }
}
