import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/tracking/domain/entities/trip.dart';
import 'package:driversense_app/features/tracking/domain/repositories/tracking_repository.dart';

/// Parameters for stopping a trip
class StopTrackingParams {
  final String tripId;
  final double? latitude;
  final double? longitude;

  const StopTrackingParams({
    required this.tripId,
    this.latitude,
    this.longitude,
  });
}

/// Use case to stop trip tracking
class StopTrackingUseCase {
  final TrackingRepository _repository;

  StopTrackingUseCase(this._repository);

  Future<Either<Failure, Trip>> call(StopTrackingParams params) {
    return _repository.endTrip(
      tripId: params.tripId,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}
