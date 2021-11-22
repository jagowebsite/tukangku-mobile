import 'package:bloc/bloc.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/transaction_repository.dart';

part 'transaction_detail_event.dart';
part 'transaction_detail_state.dart';

class TransactionDetailBloc
    extends Bloc<TransactionDetailEvent, TransactionDetailState> {
  TransactionRepository _transactionRepo = TransactionRepository();
  AuthRepository _authRepo = AuthRepository();

  TransactionDetailBloc() : super(TransactionDetailInitial()) {
    on<GetTransactionDetail>(_getTransactionDetail);
    on<ConfirmTransactionDetail>(_confirmTransactionDetail);
    on<CancelTransactionDetail>(_cancelTransactionDetail);
  }

  Future _getTransactionDetail(
      GetTransactionDetail event, Emitter<TransactionDetailState> emit) async {
    try {
      print('Get init Banner ...');
      emit(GetTransactionDetailLoading());
      String? token = await _authRepo.hasToken();
      TransactionModel? data = await _transactionRepo.getTransactionDetail(
          token: token, id: event.id);
      if (data != null) {
        emit(TransactionDetailData(data));
      } else {
        emit(TransactionDetailError('Data tidak ditemukan'));
      }
    } catch (e) {
      emit(TransactionDetailError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _confirmTransactionDetail(ConfirmTransactionDetail event,
      Emitter<TransactionDetailState> emit) async {
    try {
      print('Confirm transaction detail ...');
      emit(ConfirmTransactionDetailLoading());
      String? _token = await _authRepo.hasToken();
      ResponseModel? data = await _transactionRepo.confirmTransactionDetail(
          _token!, event.transactionDetail);
      if (data != null) {
        if (data.status == 'success') {
          emit(ConfirmTransactionDetailSuccess(data.message ?? ''));
        } else {
          emit(ConfirmTransactionDetailError(data.message ?? ''));
        }
      } else {
        emit(ConfirmTransactionDetailError('Data tidak ditemukan'));
      }
    } catch (e) {
      emit(ConfirmTransactionDetailError(
          'Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _cancelTransactionDetail(CancelTransactionDetail event,
      Emitter<TransactionDetailState> emit) async {
    try {
      print('Cancel transaction detail ...');
      emit(CancelTransactionDetailLoading());
      String? _token = await _authRepo.hasToken();
      ResponseModel? data =
          await _transactionRepo.cancelTransactionDetail(_token!, event.id);
      if (data != null) {
        if (data.status == 'success') {
          emit(CancelTransactionDetailSuccess(data.message ?? ''));
        } else {
          emit(CancelTransactionDetailError(data.message ?? ''));
        }
      } else {
        emit(CancelTransactionDetailError('Data tidak ditemukan'));
      }
    } catch (e) {
      emit(CancelTransactionDetailError(
          'Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
