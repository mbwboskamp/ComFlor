import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/check/domain/entities/check.dart';
import 'package:driversense_app/features/check/domain/repositories/check_repository.dart';

/// Use case to get questions for a check
class GetQuestionsUseCase {
  final CheckRepository _repository;

  GetQuestionsUseCase(this._repository);

  Future<Either<Failure, List<Question>>> call(CheckType checkType) {
    return _repository.getQuestions(checkType: checkType);
  }
}
