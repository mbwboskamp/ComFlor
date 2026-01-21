import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/core/error/error_handler.dart';
import 'package:driversense_app/core/network/network_info.dart';
import 'package:driversense_app/features/check/data/datasources/check_remote_datasource.dart';
import 'package:driversense_app/features/check/data/datasources/check_local_datasource.dart';
import 'package:driversense_app/features/check/domain/entities/check.dart';
import 'package:driversense_app/features/check/domain/repositories/check_repository.dart';

/// Implementation of CheckRepository
class CheckRepositoryImpl implements CheckRepository {
  final CheckRemoteDatasource _remoteDatasource;
  final CheckLocalDatasource _localDatasource;
  final NetworkInfo _networkInfo;

  CheckRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<Question>>> getQuestions({
    required CheckType checkType,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final questions = await _remoteDatasource.getQuestions(
          checkType: checkType,
        );
        // Cache questions locally
        await _localDatasource.cacheQuestions(questions);
        return Right(questions);
      } else {
        // Try to get from cache
        final cached = await _localDatasource.getCachedQuestions(
          checkType: checkType,
        );
        if (cached.isNotEmpty) {
          return Right(cached);
        }
        return const Left(NetworkFailure());
      }
    } catch (e, stackTrace) {
      // Try cache on error
      try {
        final cached = await _localDatasource.getCachedQuestions(
          checkType: checkType,
        );
        if (cached.isNotEmpty) {
          return Right(cached);
        }
      } catch (_) {}
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, Check>> submitStartCheck({
    required String tripId,
    required List<CheckAnswer> answers,
    String? notes,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final check = await _remoteDatasource.submitStartCheck(
        tripId: tripId,
        answers: answers,
        notes: notes,
      );

      // Save locally for offline access
      await _localDatasource.saveCheck(check);

      return Right(check);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, Check>> submitEndCheck({
    required String tripId,
    required List<CheckAnswer> answers,
    String? notes,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final check = await _remoteDatasource.submitEndCheck(
        tripId: tripId,
        answers: answers,
        notes: notes,
      );

      // Save locally for offline access
      await _localDatasource.saveCheck(check);

      return Right(check);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, Check>> getCheckById(String checkId) async {
    try {
      if (await _networkInfo.isConnected) {
        final check = await _remoteDatasource.getCheckById(checkId);
        await _localDatasource.saveCheck(check);
        return Right(check);
      } else {
        final localCheck = await _localDatasource.getCheckById(checkId);
        if (localCheck != null) {
          return Right(localCheck);
        }
        return const Left(CacheFailure(message: 'Check not found in cache'));
      }
    } catch (e, stackTrace) {
      // Try local on error
      final localCheck = await _localDatasource.getCheckById(checkId);
      if (localCheck != null) {
        return Right(localCheck);
      }
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, List<Check>>> getChecksForTrip(String tripId) async {
    try {
      final checks = await _localDatasource.getChecksForTrip(tripId);
      return Right(checks);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, void>> cacheQuestions(List<Question> questions) async {
    try {
      await _localDatasource.cacheQuestions(questions);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getCachedQuestions({
    required CheckType checkType,
  }) async {
    try {
      final questions = await _localDatasource.getCachedQuestions(
        checkType: checkType,
      );
      return Right(questions);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }
}
