import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:driversense_app/features/check/data/datasources/check_local_datasource.dart';
import 'package:driversense_app/features/check/domain/usecases/get_questions_usecase.dart';
import 'package:driversense_app/features/check/domain/usecases/submit_start_check_usecase.dart';
import 'package:driversense_app/features/check/domain/usecases/submit_end_check_usecase.dart';

part 'check_event.dart';
part 'check_state.dart';

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
    on<CheckStarted>(_onCheckStarted);
    on<CheckSubmitted>(_onCheckSubmitted);
  }

  Future<void> _onCheckStarted(
    CheckStarted event,
    Emitter<CheckState> emit,
  ) async {
    emit(state.copyWith(status: CheckStatus.loading));

    final result = await _getQuestionsUseCase(event.checkType);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CheckStatus.error,
        error: failure.message,
      )),
      (questions) => emit(state.copyWith(
        status: CheckStatus.loaded,
        questions: questions,
      )),
    );
  }

  Future<void> _onCheckSubmitted(
    CheckSubmitted event,
    Emitter<CheckState> emit,
  ) async {
    emit(state.copyWith(status: CheckStatus.submitting));

    final result = event.isStartCheck
        ? await _submitStartCheckUseCase(event.data)
        : await _submitEndCheckUseCase(event.data);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CheckStatus.error,
        error: failure.message,
      )),
      (_) => emit(state.copyWith(status: CheckStatus.submitted)),
    );
  }
}
