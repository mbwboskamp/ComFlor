import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/check/domain/repositories/check_repository.dart';

class SubmitEndCheckUseCase {
  final CheckRepository _repository;

  SubmitEndCheckUseCase(this._repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> data) {
    return _repository.submitEndCheck(data);
  }
}
