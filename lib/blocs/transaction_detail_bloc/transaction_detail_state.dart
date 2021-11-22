part of 'transaction_detail_bloc.dart';

abstract class TransactionDetailState {
  const TransactionDetailState();
}

class TransactionDetailInitial extends TransactionDetailState {}

class GetTransactionDetailLoading extends TransactionDetailState {}

class TransactionDetailData extends TransactionDetailState {
  final TransactionModel transactionModel;
  TransactionDetailData(this.transactionModel);
}

class TransactionDetailSuccess extends TransactionDetailState {
  final String message;
  TransactionDetailSuccess(this.message);
}

class TransactionDetailError extends TransactionDetailState {
  final String message;
  TransactionDetailError(this.message);
}

class ConfirmTransactionDetailLoading extends TransactionDetailState {}

class ConfirmTransactionDetailSuccess extends TransactionDetailState {
  final String message;
  ConfirmTransactionDetailSuccess(this.message);
}

class ConfirmTransactionDetailError extends TransactionDetailState {
  final String message;
  ConfirmTransactionDetailError(this.message);
}

class CancelTransactionDetailLoading extends TransactionDetailState {}

class CancelTransactionDetailSuccess extends TransactionDetailState {
  final String message;
  CancelTransactionDetailSuccess(this.message);
}

class CancelTransactionDetailError extends TransactionDetailState {
  final String message;
  CancelTransactionDetailError(this.message);
}
