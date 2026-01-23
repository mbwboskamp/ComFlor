import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';

abstract class TrackingRepository {
  Future<Either<Failure, String>> startTracking(Map<String, dynamic> data);
  Future<Either<Failure, void>> stopTracking(String tripId, Map<String, dynamic> data);
  Future<Either<Failure, void>> updateLocation(String tripId, Map<String, dynamic> location);
}
