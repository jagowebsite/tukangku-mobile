import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/models/transaction_model.dart';

class ReportModel {
  int? id, quantity, price, totalPrice;
  TransactionModel? transactionModel;
  ServiceModel? serviceModel;
  String? description, statusOrderDetail, verifiedAt, createdAt;

  ReportModel(
      {this.id,
      this.price,
      this.totalPrice,
      this.transactionModel,
      this.serviceModel,
      this.description,
      this.statusOrderDetail,
      this.verifiedAt,
      this.createdAt});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      price: json['price'],
      totalPrice: json['total_price'],
      description: json['description'],
      statusOrderDetail: json['status_order_detail'],
      verifiedAt: json['verified_at'],
      createdAt: json['created_at'],
      transactionModel: json['order'] != null
          ? TransactionModel.fromJson(json['order'])
          : null,
      serviceModel: json['service'] != null
          ? ServiceModel.fromJson(json['service'])
          : null,
    );
  }
}
