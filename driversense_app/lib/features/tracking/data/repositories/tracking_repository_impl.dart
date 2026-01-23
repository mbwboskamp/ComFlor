import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/core/network/network_info.dart';
import 'package:driversense_app/features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:driversense_app/features/tracking/data/datasources/tracking_local_datasource.dart';
import 'package:driversense_app/features/tracking/domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDatasource _remoteDatasource;
  final TrackingLocalDatasource _localDatasource;
  final NetworkInfo _networkInfo;

  TrackingRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, String>> startTracking(Map<String, dynamic> data) async {
    try {
      final tripId = await _remoteDatasource.startTracking(data);
      await _localDatasource.saveTrip({'id': tripId, ...data});
      return Right(tripId);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopTracking(String tripId, Map<String, dynamic> data) async {
    try {
      await _remoteDatasource.stopTracking(tripId, data);
      await _localDatasource.clearActiveTrip();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLocation(String tripId, Map<String, dynamic> location) async {
    try {
      await _remoteDatasource.updateLocation(tripId, location);
      await _localDatasource.saveTrackPoint(location);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
