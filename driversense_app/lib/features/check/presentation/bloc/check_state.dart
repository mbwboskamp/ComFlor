part of 'check_bloc.dart';

/// Status of the check state
enum CheckStateStatus {
  initial,
  loading,
  loaded,
  submitting,
  submitted,
  error,
}

/// State for the check flow
class CheckState extends Equatable {
  final CheckStateStatus status;
  final CheckType? checkType;
  final List<Question> questions;
  final Map<String, dynamic> answers;
  final Check? submittedCheck;
  final String? errorMessage;

  const CheckState({
    this.status = CheckStateStatus.initial,
    this.checkType,
    this.questions = const [],
    this.answers = const {},
    this.submittedCheck,
    this.errorMessage,
  });

  CheckState copyWith({
    CheckStateStatus? status,
    CheckType? checkType,
    List<Question>? questions,
    Map<String, dynamic>? answers,
    Check? submittedCheck,
    String? errorMessage,
  }) {
    return CheckState(
      status: status ?? this.status,
      checkType: checkType ?? this.checkType,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      submittedCheck: submittedCheck ?? this.submittedCheck,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Check if all required questions are answered
  bool get isComplete {
    final requiredQuestions = questions.where((q) => q.isRequired);
    return requiredQuestions.every((q) => answers.containsKey(q.id));
  }

  /// Get current question index (for step indicator)
  int get currentQuestionIndex => answers.length;

  /// Get total number of questions
  int get totalQuestions => questions.length;

  /// Progress percentage (0.0 to 1.0)
  double get progress {
    if (questions.isEmpty) return 0.0;
    return answers.length / questions.length;
  }

  @override
  List<Object?> get props => [
        status,
        checkType,
        questions,
        answers,
        submittedCheck,
        errorMessage,
      ];
}
