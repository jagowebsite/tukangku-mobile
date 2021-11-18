part of 'payment_bloc.dart';

abstract class PaymentState {
  const PaymentState();
}

class PaymentInitial extends PaymentState {}

class GetPaymentLoading extends PaymentState {}

class PaymentData extends PaymentState {
  final List<PaymentModel> listPayments;
  final bool hasReachMax;
  PaymentData(this.listPayments, this.hasReachMax);
}

class PaymentSuccess extends PaymentState {
  final String message;
  PaymentSuccess(this.message);
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}

class CreatePaymentLoading extends PaymentState {}

class CreatePaymentSuccess extends PaymentState {
  final String message;
  CreatePaymentSuccess(this.message);
}

class CreatePaymentError extends PaymentState {
  final String message;
  CreatePaymentError(this.message);
}

class UpdatePaymentLoading extends PaymentState {}

class UpdatePaymentSuccess extends PaymentState {
  final String message;
  UpdatePaymentSuccess(this.message);
}

class UpdatePaymentError extends PaymentState {
  final String message;
  UpdatePaymentError(this.message);
}

class ConfirmPaymentLoading extends PaymentState {}

class ConfirmPaymentSuccess extends PaymentState {
  final String message;
  ConfirmPaymentSuccess(this.message);
}

class ConfirmPaymentError extends PaymentState {
  final String message;
  ConfirmPaymentError(this.message);
}

class CancelPaymentLoading extends PaymentState {}

class CancelPaymentSuccess extends PaymentState {
  final String message;
  CancelPaymentSuccess(this.message);
}

class CancelPaymentError extends PaymentState {
  final String message;
  CancelPaymentError(this.message);
}
