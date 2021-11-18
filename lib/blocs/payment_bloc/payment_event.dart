part of 'payment_bloc.dart';

abstract class PaymentEvent {
  const PaymentEvent();
}

class GetPayment extends PaymentEvent {
  final int limit;
  final bool isInit;
  GetPayment(this.limit, this.isInit);
}

class CreatePayment extends PaymentEvent {
  final PaymentModel paymentModel;
  CreatePayment(this.paymentModel);
}

class UpdatePayment extends PaymentEvent {
  final PaymentModel paymentModel;
  UpdatePayment(this.paymentModel);
}

class ConfirmPayment extends PaymentEvent {
  final int id;
  ConfirmPayment(this.id);
}

class CancelPayment extends PaymentEvent {
  final int id;
  CancelPayment(this.id);
}
