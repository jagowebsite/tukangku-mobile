part of 'transaction_user_bloc.dart';

abstract class TransactionUserEvent{
  const TransactionUserEvent();
}

class GetTransactionUser extends TransactionUserEvent {
  final int limit;
  final bool isInit;
  GetTransactionUser(this.limit, this.isInit);
}

class GetTransactionDetailUser extends TransactionUserEvent {
  final int id;
  GetTransactionDetailUser(this.id);
}
