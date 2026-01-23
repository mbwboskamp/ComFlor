import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/tracking/domain/repositories/tracking_repository.dart';

class StartTrackingUseCase {
  final TrackingRepository _repository;

  StartTrackingUseCase(this._repository);

  Future<Either<Failure, String>> call(Map<String, dynamic> data) {
    return _repository.startTracking(data);
  }
}
