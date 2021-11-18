import 'package:bloc/bloc.dart';
import 'package:tukangku/models/payment_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  AuthRepository _authRepo = AuthRepository();
  PaymentRepository _paymentRepo = PaymentRepository();
  List<PaymentModel> listPayments = [];
  int page = 1;

  PaymentBloc() : super(PaymentInitial()) {
    on<GetPayment>(_getPayment);
    on<CreatePayment>(_createPayment);
    on<UpdatePayment>(_updatePayment);
    on<ConfirmPayment>(_confirmPayment);
    on<CancelPayment>(_cancelPayment);
  }

  Future _getPayment(GetPayment event, Emitter<PaymentState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init payment ...');
        page = 1;
        emit(GetPaymentLoading());
        List<PaymentModel>? data = await _paymentRepo.getPayments(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listPayments = data;
          data.length < event.limit
              ? emit(PaymentData(listPayments, true))
              : emit(PaymentData(listPayments, false));
        } else {
          emit(PaymentData(listPayments, false));
        }
      } else {
        print('Get more banner ...');
        page++;
        List<PaymentModel>? data = await _paymentRepo.getPayments(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listPayments.addAll(data);
          data.length < event.limit
              ? emit(PaymentData(listPayments, true))
              : emit(PaymentData(listPayments, false));
        } else {
          emit(PaymentData(listPayments, false));
        }
      }
    } catch (e) {
      emit(PaymentError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _createPayment(CreatePayment event, Emitter<PaymentState> emit) async {
    emit(CreatePaymentLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _paymentRepo.createPayment(_token, event.paymentModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(CreatePaymentSuccess(responseModel.message ?? ''));
          } else {
            emit(CreatePaymentError(responseModel.message ?? ''));
          }
        } else {
          emit(CreatePaymentError(
              'Tambah payment gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(CreatePaymentError('Tambah payment gagal, silahkan coba kembali'));
    }
  }

  Future _updatePayment(UpdatePayment event, Emitter<PaymentState> emit) async {
    emit(UpdatePaymentLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _paymentRepo.updatePayment(_token, event.paymentModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(UpdatePaymentSuccess(responseModel.message ?? ''));
          } else {
            emit(UpdatePaymentError(responseModel.message ?? ''));
          }
        } else {
          emit(UpdatePaymentError(
              'Update payment gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(UpdatePaymentError('Update payment gagal, silahkan coba kembali'));
    }
  }

  Future _confirmPayment(
      ConfirmPayment event, Emitter<PaymentState> emit) async {
    emit(ConfirmPaymentLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _paymentRepo.confirmPayment(_token, event.id);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(ConfirmPaymentSuccess(responseModel.message ?? ''));
          } else {
            emit(ConfirmPaymentError(responseModel.message ?? ''));
          }
        } else {
          emit(ConfirmPaymentError(
              'Confirm payment gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(ConfirmPaymentError('Confirm payment gagal, silahkan coba kembali'));
    }
  }

  Future _cancelPayment(CancelPayment event, Emitter<PaymentState> emit) async {
    emit(CancelPaymentLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _paymentRepo.cancelPayment(_token, event.id);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(CancelPaymentSuccess(responseModel.message ?? ''));
          } else {
            emit(CancelPaymentError(responseModel.message ?? ''));
          }
        } else {
          emit(CancelPaymentError(
              'Cancel payment gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(CancelPaymentError('Cancel payment gagal, silahkan coba kembali'));
    }
  }
}
