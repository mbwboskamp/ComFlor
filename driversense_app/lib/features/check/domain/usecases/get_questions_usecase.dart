import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/check/domain/repositories/check_repository.dart';

class GetQuestionsUseCase {
  final CheckRepository _repository;

  GetQuestionsUseCase(this._repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call(String checkType) {
    return _repository.getQuestions(checkType);
  }
}
