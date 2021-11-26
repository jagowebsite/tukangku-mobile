part of 'transaction_user_bloc.dart';

abstract class TransactionUserState{
  const TransactionUserState();
}

class TransactionUserInitial extends TransactionUserState {}

class GetTransactionUserLoading extends TransactionUserState {}

class TransactionUserData extends TransactionUserState {
  final List<TransactionModel> listTransactions;
  final bool hasReachMax;
  TransactionUserData(this.listTransactions, this.hasReachMax);
}

class TransactionUserSuccess extends TransactionUserState {
  final String message;
  TransactionUserSuccess(this.message);
}

class TransactionUserError extends TransactionUserState {
  final String message;
  TransactionUserError(this.message);
}

class GetTransactionDetailUserLoading extends TransactionUserState {}

class TransactionDetailUserData extends TransactionUserState {
  final TransactionModel transactionModel;
  TransactionDetailUserData(this.transactionModel);
}

class TransactionDetailUserSuccess extends TransactionUserState {
  final String message;
  TransactionDetailUserSuccess(this.message);
}

class TransactionDetailUserError extends TransactionUserState {
  final String message;
  TransactionDetailUserError(this.message);
}
