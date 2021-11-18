part of 'transaction_detail_bloc.dart';

abstract class TransactionDetailState extends Equatable {
  const TransactionDetailState();
  
  @override
  List<Object> get props => [];
}

class TransactionDetailInitial extends TransactionDetailState {}
