import 'package:driversense_app/core/storage/database/app_database.dart';

abstract class TrackingLocalDatasource {
  Future<void> saveTrip(Map<String, dynamic> trip);
  Future<Map<String, dynamic>?> getActiveTrip();
  Future<void> saveTrackPoint(Map<String, dynamic> trackPoint);
  Future<List<Map<String, dynamic>>> getTrackPoints(String tripId);
  Future<void> clearActiveTrip();
}

class TrackingLocalDatasourceImpl implements TrackingLocalDatasource {
  final AppDatabase _database;

  TrackingLocalDatasourceImpl(this._database);

  @override
  Future<void> saveTrip(Map<String, dynamic> trip) async {
    // TODO: Implement local storage
  }

  @override
  Future<Map<String, dynamic>?> getActiveTrip() async {
    // TODO: Implement local storage
    return null;
  }

  @override
  Future<void> saveTrackPoint(Map<String, dynamic> trackPoint) async {
    // TODO: Implement local storage
  }

  @override
  Future<List<Map<String, dynamic>>> getTrackPoints(String tripId) async {
    // TODO: Implement local storage
    return [];
  }

  @override
  Future<void> clearActiveTrip() async {
    // TODO: Implement local storage
  }
}
