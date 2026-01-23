import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';

abstract class CheckRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getQuestions(String checkType);
  Future<Either<Failure, void>> submitStartCheck(Map<String, dynamic> data);
  Future<Either<Failure, void>> submitEndCheck(Map<String, dynamic> data);
}
