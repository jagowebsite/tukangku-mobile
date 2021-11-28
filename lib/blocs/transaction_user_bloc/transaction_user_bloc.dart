import 'package:bloc/bloc.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/transaction_repository.dart';

part 'transaction_user_event.dart';
part 'transaction_user_state.dart';

class TransactionUserBloc
    extends Bloc<TransactionUserEvent, TransactionUserState> {
  AuthRepository _authRepo = AuthRepository();
  TransactionRepository _transactionRepo = TransactionRepository();
  List<TransactionModel> listTransactions = [];
  int page = 1;

  TransactionUserBloc() : super(TransactionUserInitial()) {
    on<GetTransactionUser>(_getTransactionUser);
    on<GetTransactionDetailUser>(_getTransactionDetailUser);
  }

  Future _getTransactionUser(
      GetTransactionUser event, Emitter<TransactionUserState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init transaction user...');
        page = 1;
        emit(GetTransactionUserLoading());
        List<TransactionModel>? data = await _transactionRepo
            .getMyTransactions(_token!, page: page, limit: event.limit);
        if (data != null) {
          listTransactions = data;
          data.length < event.limit
              ? emit(TransactionUserData(listTransactions, true))
              : emit(TransactionUserData(listTransactions, false));
        } else {
          emit(TransactionUserData(listTransactions, false));
        }
      } else {
        print('Get more transaction user ...');
        page++;
        List<TransactionModel>? data = await _transactionRepo
            .getMyTransactions(_token!, page: page, limit: event.limit);
        if (data != null) {
          listTransactions.addAll(data);
          data.length < event.limit
              ? emit(TransactionUserData(listTransactions, true))
              : emit(TransactionUserData(listTransactions, false));
        } else {
          emit(TransactionUserData(listTransactions, false));
        }
      }
    } catch (e) {
      emit(TransactionUserError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _getTransactionDetailUser(GetTransactionDetailUser event,
      Emitter<TransactionUserState> emit) async {
    try {
      print('Get init transaction detail ...');
      emit(GetTransactionDetailUserLoading());
      String? token = await _authRepo.hasToken();
      TransactionModel? data = await _transactionRepo.getTransactionDetail(
          token: token, id: event.id);
      if (data != null) {
        emit(TransactionDetailUserData(data));
      } else {
        emit(TransactionDetailUserError('Data tidak ditemukan'));
      }
    } catch (e) {
      emit(TransactionDetailUserError(
          'Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
