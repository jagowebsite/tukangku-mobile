import 'dart:io';

import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/models/user_model.dart';

class PaymentModel {
  final User? user;
  final TransactionModel? transactionModel;
  final String? paymentCode,
      type,
      typeTransfer,
      imagesPayment,
      imagesUser,
      bankNumber,
      bankName,
      accountName,
      longitude,
      latitude,
      status,
      description,
      createdAt,
      address;
  final int? totalPayment, id, accountPaymentId;
  final File? imageUserFile, imagePaymentFile;

  PaymentModel(
      {this.user,
      this.id,
      this.accountPaymentId,
      this.transactionModel,
      this.paymentCode,
      this.type,
      this.typeTransfer,
      this.imagesPayment,
      this.imagesUser,
      this.bankNumber,
      this.bankName,
      this.accountName,
      this.latitude,
      this.longitude,
      this.status,
      this.imagePaymentFile,
      this.imageUserFile,
      this.description,
      this.address,
      this.createdAt,
      this.totalPayment});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      transactionModel: json['transaction'] != null
          ? TransactionModel.fromJson(json['transaction'])
          : null,
      paymentCode: json['payment_code'],
      id: json['id'],
      type: json['type'],
      typeTransfer: json['type_transfer'],
      imagesPayment: json['images_payment'],
      imagesUser: json['images_user'],
      bankNumber: json['bank_number'],
      bankName: json['bank_name'],
      accountName: json['account_name'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      status: json['status'],
      description: json['description'],
      address: json['address'],
      totalPayment: json['total_payment'],
      createdAt: json['created_at'],
    );
  }
}

class AccountPaymentModel {
  int? id;
  String? accountName, accountNumber, bankName;

  AccountPaymentModel(
      {this.id, this.accountName, this.accountNumber, this.bankName});

  factory AccountPaymentModel.fromJson(Map<String, dynamic> json) {
    return AccountPaymentModel(
      id: json['id'],
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      bankName: json['bank_name'],
    );
  }
}
