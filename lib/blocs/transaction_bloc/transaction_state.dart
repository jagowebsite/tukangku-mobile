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
