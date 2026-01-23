part of 'check_bloc.dart';

enum CheckStatus {
  initial,
  loading,
  loaded,
  submitting,
  submitted,
  error,
}

class CheckState extends Equatable {
  final CheckStatus status;
  final List<Map<String, dynamic>> questions;
  final String? error;

  const CheckState({
    this.status = CheckStatus.initial,
    this.questions = const [],
    this.error,
  });

  CheckState copyWith({
    CheckStatus? status,
    List<Map<String, dynamic>>? questions,
    String? error,
  }) {
    return CheckState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, questions, error];
}
