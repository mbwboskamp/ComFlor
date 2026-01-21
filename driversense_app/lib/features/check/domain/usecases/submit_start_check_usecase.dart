import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/check/domain/entities/check.dart';
import 'package:driversense_app/features/check/domain/repositories/check_repository.dart';

/// Parameters for submitting a start check
class SubmitStartCheckParams {
  final String tripId;
  final List<CheckAnswer> answers;
  final String? notes;

  const SubmitStartCheckParams({
    required this.tripId,
    required this.answers,
    this.notes,
  });
}

/// Use case to submit a start check
class SubmitStartCheckUseCase {
  final CheckRepository _repository;

  SubmitStartCheckUseCase(this._repository);

  Future<Either<Failure, Check>> call(SubmitStartCheckParams params) {
    return _repository.submitStartCheck(
      tripId: params.tripId,
      answers: params.answers,
      notes: params.notes,
    );
  }
}
