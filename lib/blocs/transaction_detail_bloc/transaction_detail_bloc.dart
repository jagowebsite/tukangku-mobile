import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tukangku/models/transaction_model.dart';

part 'transaction_detail_event.dart';
part 'transaction_detail_state.dart';

class TransactionDetailBloc
    extends Bloc<TransactionDetailEvent, TransactionDetailState> {
  TransactionDetailBloc() : super(TransactionDetailInitial()) {
    on<TransactionDetailEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
