part of 'check_bloc.dart';

/// Base class for check events
abstract class CheckEvent extends Equatable {
  const CheckEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request questions for a check type
class CheckQuestionsRequested extends CheckEvent {
  final CheckType checkType;

  const CheckQuestionsRequested({required this.checkType});

  @override
  List<Object> get props => [checkType];
}

/// Event when an answer is updated
class CheckAnswerUpdated extends CheckEvent {
  final String questionId;
  final dynamic value;

  const CheckAnswerUpdated({
    required this.questionId,
    required this.value,
  });

  @override
  List<Object?> get props => [questionId, value];
}

/// Event to submit start check
class CheckStartSubmitted extends CheckEvent {
  final String tripId;
  final String? notes;

  const CheckStartSubmitted({
    required this.tripId,
    this.notes,
  });

  @override
  List<Object?> get props => [tripId, notes];
}

/// Event to submit end check
class CheckEndSubmitted extends CheckEvent {
  final String tripId;
  final String? notes;

  const CheckEndSubmitted({
    required this.tripId,
    this.notes,
  });

  @override
  List<Object?> get props => [tripId, notes];
}

/// Event to reset check state
class CheckReset extends CheckEvent {
  const CheckReset();
}
