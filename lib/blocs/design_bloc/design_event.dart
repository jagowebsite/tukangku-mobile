part of 'design_bloc.dart';

abstract class DesignEvent {
  const DesignEvent();
}

class GetServiceDesign extends DesignEvent {
  final int limit;
  final bool isInit;
  GetServiceDesign(this.limit, this.isInit);
}
