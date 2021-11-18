import 'package:tukangku/models/employee_model.dart';
import 'package:tukangku/models/payment_model.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/models/user_model.dart';

class TransactionModel {
  final int? id, totalAllPrice;
  final String? invoiceId, statusOrder, createdAt;
  final List<TransactionDetail>? transactionDetail;
  final List<PaymentModel>? payment;
  final User? user;

  TransactionModel(
      {this.id,
      this.totalAllPrice,
      this.invoiceId,
      this.statusOrder,
      this.transactionDetail,
      this.payment,
      this.createdAt,
      this.user});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      totalAllPrice: json['total_all_price'],
      invoiceId: json['invoice_id'],
      createdAt: json['created_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      statusOrder: json['status_order'],
      transactionDetail: json["transaction_detail"] != null
          ? List<TransactionDetail>.from(json["transaction_detail"]
              .map((e) => TransactionDetail.fromJson(e)))
          : null,
      payment: json["payment"] != null
          ? List<PaymentModel>.from(
              json["payment"].map((e) => PaymentModel.fromJson(e)))
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
