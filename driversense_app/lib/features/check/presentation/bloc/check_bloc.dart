import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driversense_app/features/check/domain/entities/check.dart';
import 'package:driversense_app/features/check/domain/usecases/get_questions_usecase.dart';
import 'package:driversense_app/features/check/domain/usecases/submit_start_check_usecase.dart';
import 'package:driversense_app/features/check/domain/usecases/submit_end_check_usecase.dart';
import 'package:driversense_app/features/check/data/datasources/check_local_datasource.dart';

part 'check_event.dart';
part 'check_state.dart';

/// BLoC for managing check flow
class CheckBloc extends Bloc<CheckEvent, CheckState> {
  final GetQuestionsUseCase _getQuestionsUseCase;
  final SubmitStartCheckUseCase _submitStartCheckUseCase;
  final SubmitEndCheckUseCase _submitEndCheckUseCase;
  final CheckLocalDatasource _localDatasource;

  CheckBloc(
    this._getQuestionsUseCase,
    this._submitStartCheckUseCase,
    this._submitEndCheckUseCase,
    this._localDatasource,
  ) : super(const CheckState()) {
    on<CheckQuestionsRequested>(_onQuestionsRequested);
    on<CheckAnswerUpdated>(_onAnswerUpdated);
    on<CheckStartSubmitted>(_onStartSubmitted);
    on<CheckEndSubmitted>(_onEndSubmitted);
    on<CheckReset>(_onReset);
  }

  Future<void> _onQuestionsRequested(
    CheckQuestionsRequested event,
    Emitter<CheckState> emit,
  ) async {
    emit(state.copyWith(status: CheckStateStatus.loading));

    final result = await _getQuestionsUseCase(event.checkType);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CheckStateStatus.error,
        errorMessage: failure.message,
      )),
      (questions) => emit(state.copyWith(
        status: CheckStateStatus.loaded,
        questions: questions,
        checkType: event.checkType,
        answers: {},
      )),
    );
  }

  void _onAnswerUpdated(
    CheckAnswerUpdated event,
    Emitter<CheckState> emit,
  ) {
    final newAnswers = Map<String, dynamic>.from(state.answers);
    newAnswers[event.questionId] = event.value;
    emit(state.copyWith(answers: newAnswers));
  }

  Future<void> _onStartSubmitted(
    CheckStartSubmitted event,
    Emitter<CheckState> emit,
  ) async {
    emit(state.copyWith(status: CheckStateStatus.submitting));

    final answers = state.answers.entries.map((entry) => CheckAnswer(
      questionId: entry.key,
      value: entry.value,
      answeredAt: DateTime.now(),
    )).toList();

    final result = await _submitStartCheckUseCase(SubmitStartCheckParams(
      tripId: event.tripId,
      answers: answers,
      notes: event.notes,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: CheckStateStatus.error,
        errorMessage: failure.message,
      )),
      (check) => emit(state.copyWith(
        status: CheckStateStatus.submitted,
        submittedCheck: check,
      )),
    );
  }

  Future<void> _onEndSubmitted(
    CheckEndSubmitted event,
    Emitter<CheckState> emit,
  ) async {
    emit(state.copyWith(status: CheckStateStatus.submitting));

    final answers = state.answers.entries.map((entry) => CheckAnswer(
      questionId: entry.key,
      value: entry.value,
      answeredAt: DateTime.now(),
    )).toList();

    final result = await _submitEndCheckUseCase(SubmitEndCheckParams(
      tripId: event.tripId,
      answers: answers,
      notes: event.notes,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: CheckStateStatus.error,
        errorMessage: failure.message,
      )),
      (check) => emit(state.copyWith(
        status: CheckStateStatus.submitted,
        submittedCheck: check,
      )),
    );
  }

  void _onReset(
    CheckReset event,
    Emitter<CheckState> emit,
  ) {
    emit(const CheckState());
  }
}
