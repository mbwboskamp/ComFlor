import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/core/error/error_handler.dart';
import 'package:driversense_app/core/network/network_info.dart';
import 'package:driversense_app/features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:driversense_app/features/tracking/data/datasources/tracking_local_datasource.dart';
import 'package:driversense_app/features/tracking/domain/entities/trip.dart';
import 'package:driversense_app/features/tracking/domain/entities/privacy_zone.dart';
import 'package:driversense_app/features/tracking/domain/repositories/tracking_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementation of TrackingRepository
class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDatasource _remoteDatasource;
  final TrackingLocalDatasource _localDatasource;
  final NetworkInfo _networkInfo;
  final Uuid _uuid = const Uuid();

  TrackingRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, Trip>> startTrip({
    String? vehicleId,
    double? latitude,
    double? longitude,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final trip = await _remoteDatasource.startTrip(
          vehicleId: vehicleId,
          latitude: latitude,
          longitude: longitude,
        );
        await _localDatasource.saveTrip(trip);
        return Right(trip);
      } else {
        // Create local trip for offline mode
        final trip = Trip(
          id: _uuid.v4(),
          driverId: '', // Would be filled from auth
          vehicleId: vehicleId,
          status: TripStatus.active,
          startedAt: DateTime.now(),
          startLatitude: latitude,
          startLongitude: longitude,
        );
        await _localDatasource.saveTrip(trip);
        return Right(trip);
      }
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, Trip>> endTrip({
    required String tripId,
    double? latitude,
    double? longitude,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final trip = await _remoteDatasource.endTrip(
          tripId: tripId,
          latitude: latitude,
          longitude: longitude,
        );
        await _localDatasource.saveTrip(trip);
        return Right(trip);
      } else {
        // Update local trip
        final existingTrip = await _localDatasource.getTripById(tripId);
        if (existingTrip == null) {
          return const Left(CacheFailure(message: 'Trip not found'));
        }
        final updatedTrip = existingTrip.copyWith(
          status: TripStatus.completed,
          endedAt: DateTime.now(),
          endLatitude: latitude,
          endLongitude: longitude,
        );
        await _localDatasource.saveTrip(updatedTrip);
        return Right(updatedTrip);
      }
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, Trip?>> getActiveTrip() async {
    try {
      // First check local
      final localTrip = await _localDatasource.getActiveTrip();
      if (localTrip != null) {
        return Right(localTrip);
      }

      // Then check remote if connected
      if (await _networkInfo.isConnected) {
        final remoteTrip = await _remoteDatasource.getActiveTrip();
        if (remoteTrip != null) {
          await _localDatasource.saveTrip(remoteTrip);
        }
        return Right(remoteTrip);
      }

      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, Trip>> getTripById(String tripId) async {
    try {
      final localTrip = await _localDatasource.getTripById(tripId);
      if (localTrip != null) {
        return Right(localTrip);
      }

      if (await _networkInfo.isConnected) {
        final remoteTrip = await _remoteDatasource.getTripById(tripId);
        await _localDatasource.saveTrip(remoteTrip);
        return Right(remoteTrip);
      }

      return const Left(CacheFailure(message: 'Trip not found'));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, List<Trip>>> getTripHistory({
    int? limit,
    int? offset,
  }) async {
    try {
      final trips = await _localDatasource.getTripHistory(
        limit: limit,
        offset: offset,
      );
      return Right(trips);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, void>> addTrackPoint({
    required String tripId,
    required double latitude,
    required double longitude,
    double? altitude,
    double? speed,
    double? heading,
    double? accuracy,
  }) async {
    try {
      final trackPoint = TrackPoint(
        id: _uuid.v4(),
        tripId: tripId,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        speed: speed,
        heading: heading,
        accuracy: accuracy,
        recordedAt: DateTime.now(),
      );

      await _localDatasource.saveTrackPoint(trackPoint);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, List<TrackPoint>>> getTrackPoints(String tripId) async {
    try {
      final trackPoints = await _localDatasource.getTrackPoints(tripId);
      return Right(trackPoints);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, List<PrivacyZone>>> getPrivacyZones() async {
    try {
      if (await _networkInfo.isConnected) {
        final zones = await _remoteDatasource.getPrivacyZones();
        await _localDatasource.savePrivacyZones(zones);
        return Right(zones);
      } else {
        final zones = await _localDatasource.getPrivacyZones();
        return Right(zones);
      }
    } catch (e, stackTrace) {
      // Try local on error
      try {
        final zones = await _localDatasource.getPrivacyZones();
        return Right(zones);
      } catch (_) {}
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, PrivacyZone>> addPrivacyZone({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int radius,
  }) async {
    try {
      final zone = PrivacyZone(
        id: _uuid.v4(),
        name: name,
        address: address,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        createdAt: DateTime.now(),
      );

      // Save locally
      await _localDatasource.savePrivacyZones([zone]);

      return Right(zone);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, void>> deletePrivacyZone(String zoneId) async {
    try {
      // Implementation would delete from local and sync to server
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }
}
