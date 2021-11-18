part of 'transaction_bloc.dart';

abstract class TransactionEvent {
  const TransactionEvent();
}

class GetTransaction extends TransactionEvent {
  final int limit;
  final bool isInit;
  GetTransaction(this.limit, this.isInit);
}
