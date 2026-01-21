import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/check/domain/entities/check.dart';

/// Repository interface for check operations
abstract class CheckRepository {
  /// Get questions for a specific check type
  Future<Either<Failure, List<Question>>> getQuestions({
    required CheckType checkType,
  });

  /// Submit a start check
  Future<Either<Failure, Check>> submitStartCheck({
    required String tripId,
    required List<CheckAnswer> answers,
    String? notes,
  });

  /// Submit an end check
  Future<Either<Failure, Check>> submitEndCheck({
    required String tripId,
    required List<CheckAnswer> answers,
    String? notes,
  });

  /// Get check by ID
  Future<Either<Failure, Check>> getCheckById(String checkId);

  /// Get checks for a trip
  Future<Either<Failure, List<Check>>> getChecksForTrip(String tripId);

  /// Cache questions locally
  Future<Either<Failure, void>> cacheQuestions(List<Question> questions);

  /// Get cached questions
  Future<Either<Failure, List<Question>>> getCachedQuestions({
    required CheckType checkType,
  });
}
