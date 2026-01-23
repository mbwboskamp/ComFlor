import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/tracking/domain/repositories/tracking_repository.dart';

class StopTrackingParams {
  final String tripId;
  final Map<String, dynamic> data;

  StopTrackingParams({required this.tripId, required this.data});
}

class StopTrackingUseCase {
  final TrackingRepository _repository;

  StopTrackingUseCase(this._repository);

  Future<Either<Failure, void>> call(StopTrackingParams params) {
    return _repository.stopTracking(params.tripId, params.data);
  }
}
