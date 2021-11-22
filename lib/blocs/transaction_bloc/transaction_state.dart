part of 'transaction_bloc.dart';

abstract class TransactionState {
  const TransactionState();
}

class TransactionInitial extends TransactionState {}

class GetTransactionLoading extends TransactionState {}

class TransactionData extends TransactionState {
  final List<TransactionModel> listTransactions;
  final bool hasReachMax;
  TransactionData(this.listTransactions, this.hasReachMax);
}

class TransactionSuccess extends TransactionState {
  final String message;
  TransactionSuccess(this.message);
}

class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
}

class ConfirmTransactionLoading extends TransactionState {}

class ConfirmTransactionSuccess extends TransactionState {
  final String message;
  ConfirmTransactionSuccess(this.message);
}

class ConfirmTransactionError extends TransactionState {
  final String message;
  ConfirmTransactionError(this.message);
}

class CancelTransactionLoading extends TransactionState {}

class CancelTransactionSuccess extends TransactionState {
  final String message;
  CancelTransactionSuccess(this.message);
}

class CancelTransactionError extends TransactionState {
  final String message;
  CancelTransactionError(this.message);
}
