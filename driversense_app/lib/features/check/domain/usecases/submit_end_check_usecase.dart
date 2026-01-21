import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/check/domain/entities/check.dart';
import 'package:driversense_app/features/check/domain/repositories/check_repository.dart';

/// Parameters for submitting an end check
class SubmitEndCheckParams {
  final String tripId;
  final List<CheckAnswer> answers;
  final String? notes;

  const SubmitEndCheckParams({
    required this.tripId,
    required this.answers,
    this.notes,
  });
}

/// Use case to submit an end check
class SubmitEndCheckUseCase {
  final CheckRepository _repository;

  SubmitEndCheckUseCase(this._repository);

  Future<Either<Failure, Check>> call(SubmitEndCheckParams params) {
    return _repository.submitEndCheck(
      tripId: params.tripId,
      answers: params.answers,
      notes: params.notes,
    );
  }
}
