part of 'history_bloc.dart';

abstract class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {}

class GetHistoryEmployeeLoading extends HistoryState {}

class HistoryEmployeeData extends HistoryState {
  final List<HistoryEmployeeModel> listHistories;
  final bool hasReachMax;
  HistoryEmployeeData(this.listHistories, this.hasReachMax);
}

class HistoryEmployeeSuccess extends HistoryState {
  final String message;
  HistoryEmployeeSuccess(this.message);
}

class HistoryEmployeeError extends HistoryState {
  final String message;
  HistoryEmployeeError(this.message);
}

class GetHistoryConsumenLoading extends HistoryState {}

class HistoryConsumenData extends HistoryState {
  final List<ReportModel> listHistories;
  final bool hasReachMax;
  HistoryConsumenData(this.listHistories, this.hasReachMax);
}

class HistoryConsumenSuccess extends HistoryState {
  final String message;
  HistoryConsumenSuccess(this.message);
}

class HistoryConsumenError extends HistoryState {
  final String message;
  HistoryConsumenError(this.message);
}
