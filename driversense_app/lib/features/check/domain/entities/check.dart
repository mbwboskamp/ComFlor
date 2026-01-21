import 'package:equatable/equatable.dart';

/// Check entity representing a pre/post-trip safety check
class Check extends Equatable {
  final String id;
  final String tripId;
  final String driverId;
  final CheckType type;
  final CheckStatus status;
  final List<CheckAnswer> answers;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? notes;

  const Check({
    required this.id,
    required this.tripId,
    required this.driverId,
    required this.type,
    required this.status,
    required this.answers,
    required this.startedAt,
    this.completedAt,
    this.notes,
  });

  Check copyWith({
    String? id,
    String? tripId,
    String? driverId,
    CheckType? type,
    CheckStatus? status,
    List<CheckAnswer>? answers,
    DateTime? startedAt,
    DateTime? completedAt,
    String? notes,
  }) {
    return Check(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      driverId: driverId ?? this.driverId,
      type: type ?? this.type,
      status: status ?? this.status,
      answers: answers ?? this.answers,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tripId,
        driverId,
        type,
        status,
        answers,
        startedAt,
        completedAt,
        notes,
      ];
}

/// Check type enum
enum CheckType { start, end }

/// Check status enum
enum CheckStatus { pending, inProgress, completed, cancelled }

/// Question entity for check flow
class Question extends Equatable {
  final String id;
  final String code;
  final String category;
  final String text;
  final QuestionType type;
  final Map<int, String> scaleLabels;
  final int sortOrder;
  final bool isRequired;

  const Question({
    required this.id,
    required this.code,
    required this.category,
    required this.text,
    required this.type,
    required this.scaleLabels,
    required this.sortOrder,
    this.isRequired = true,
  });

  @override
  List<Object?> get props => [
        id,
        code,
        category,
        text,
        type,
        scaleLabels,
        sortOrder,
        isRequired,
      ];
}

/// Question type enum
enum QuestionType { scale, yesNo, text, multiSelect }

/// Answer to a check question
class CheckAnswer extends Equatable {
  final String questionId;
  final dynamic value;
  final DateTime answeredAt;

  const CheckAnswer({
    required this.questionId,
    required this.value,
    required this.answeredAt,
  });

  @override
  List<Object?> get props => [questionId, value, answeredAt];
}
