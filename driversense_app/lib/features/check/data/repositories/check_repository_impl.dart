import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/core/network/network_info.dart';
import 'package:driversense_app/features/check/data/datasources/check_remote_datasource.dart';
import 'package:driversense_app/features/check/data/datasources/check_local_datasource.dart';
import 'package:driversense_app/features/check/domain/repositories/check_repository.dart';

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
  Future<Either<Failure, List<Map<String, dynamic>>>> getQuestions(String checkType) async {
    try {
      final questions = await _remoteDatasource.getQuestions(checkType);
      return Right(questions);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitStartCheck(Map<String, dynamic> data) async {
    try {
      await _remoteDatasource.submitStartCheck(data);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitEndCheck(Map<String, dynamic> data) async {
    try {
      await _remoteDatasource.submitEndCheck(data);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
