part of 'check_bloc.dart';

abstract class CheckEvent extends Equatable {
  const CheckEvent();

  @override
  List<Object?> get props => [];
}

class CheckStarted extends CheckEvent {
  final String checkType;

  const CheckStarted({required this.checkType});

  @override
  List<Object> get props => [checkType];
}

class CheckSubmitted extends CheckEvent {
  final Map<String, dynamic> data;
  final bool isStartCheck;

  const CheckSubmitted({
    required this.data,
    required this.isStartCheck,
  });

  @override
  List<Object> get props => [data, isStartCheck];
}
