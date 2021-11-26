import 'package:bloc/bloc.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  AuthRepository _authRepo = AuthRepository();
  TransactionRepository _transactionRepo = TransactionRepository();
  List<TransactionModel> listTransactions = [];
  int page = 1;

  TransactionBloc() : super(TransactionInitial()) {
    on<GetTransaction>(_getTransaction);
    on<ConfirmTransaction>(_confirmTransaction);
    on<CancelTransaction>(_cancelTransaction);
  }

  Future _getTransaction(
      GetTransaction event, Emitter<TransactionState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init transaction ...');
        page = 1;
        emit(GetTransactionLoading());
        List<TransactionModel>? data = await _transactionRepo
            .getTransactions(_token!, page: page, limit: event.limit);
        if (data != null) {
          listTransactions = data;
          data.length < event.limit
              ? emit(TransactionData(listTransactions, true))
              : emit(TransactionData(listTransactions, false));
        } else {
          emit(TransactionData(listTransactions, false));
        }
      } else {
        print('Get more transaction ...');
        page++;
        List<TransactionModel>? data = await _transactionRepo
            .getTransactions(_token!, page: page, limit: event.limit);
        if (data != null) {
          listTransactions.addAll(data);
          data.length < event.limit
              ? emit(TransactionData(listTransactions, true))
              : emit(TransactionData(listTransactions, false));
        } else {
          emit(TransactionData(listTransactions, false));
        }
      }
    } catch (e) {
      emit(TransactionError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _confirmTransaction(
      ConfirmTransaction event, Emitter<TransactionState> emit) async {
    try {
      print('Confirm transaction ...');
      emit(ConfirmTransactionLoading());
      String? _token = await _authRepo.hasToken();
      ResponseModel? data =
          await _transactionRepo.confirmTransaction(_token!, event.id);
      if (data != null) {
        if (data.status == 'success') {
          emit(ConfirmTransactionSuccess(data.message ?? ''));
        } else {
          emit(ConfirmTransactionError(data.message ?? ''));
        }
      } else {
        emit(ConfirmTransactionError('Data tidak ditemukan'));
      }
    } catch (e) {
      emit(ConfirmTransactionError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _cancelTransaction(
      CancelTransaction event, Emitter<TransactionState> emit) async {
    try {
      print('Cancel transaction  ...');
      emit(CancelTransactionLoading());
      String? _token = await _authRepo.hasToken();
      ResponseModel? data =
          await _transactionRepo.cancelTransaction(_token!, event.id);
      if (data != null) {
        if (data.status == 'success') {
          emit(CancelTransactionSuccess(data.message ?? ''));
        } else {
          emit(CancelTransactionError(data.message ?? ''));
        }
      } else {
        emit(CancelTransactionError('Data tidak ditemukan'));
      }
    } catch (e) {
      emit(CancelTransactionError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
