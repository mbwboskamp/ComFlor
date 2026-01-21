import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/tracking/domain/entities/trip.dart';
import 'package:driversense_app/features/tracking/domain/repositories/tracking_repository.dart';

/// Parameters for starting a trip
class StartTrackingParams {
  final String? vehicleId;
  final double? latitude;
  final double? longitude;

  const StartTrackingParams({
    this.vehicleId,
    this.latitude,
    this.longitude,
  });
}

/// Use case to start trip tracking
class StartTrackingUseCase {
  final TrackingRepository _repository;

  StartTrackingUseCase(this._repository);

  Future<Either<Failure, Trip>> call(StartTrackingParams params) {
    return _repository.startTrip(
      vehicleId: params.vehicleId,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}
