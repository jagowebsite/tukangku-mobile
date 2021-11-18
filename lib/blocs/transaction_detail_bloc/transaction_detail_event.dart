part of 'transaction_detail_bloc.dart';

abstract class TransactionDetailEvent {
  const TransactionDetailEvent();
}

class GetTransactionDetail extends TransactionDetailEvent {
  final int id;
  GetTransactionDetail(this.id);
}

class ConfirmTransactionDetail extends TransactionDetailEvent {
  final TransactionDetail transactionDetail;
  ConfirmTransactionDetail(this.transactionDetail);
}

class CancelTransactionDetail extends TransactionDetailEvent {
  final int id;
  CancelTransactionDetail(this.id);
}
