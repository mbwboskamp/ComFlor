import 'package:driversense_app/core/network/api_client.dart';

abstract class TrackingRemoteDatasource {
  Future<String> startTracking(Map<String, dynamic> data);
  Future<void> stopTracking(String tripId, Map<String, dynamic> data);
  Future<void> updateLocation(String tripId, Map<String, dynamic> location);
}

class TrackingRemoteDatasourceImpl implements TrackingRemoteDatasource {
  final ApiClient _apiClient;

  TrackingRemoteDatasourceImpl(this._apiClient);

  @override
  Future<String> startTracking(Map<String, dynamic> data) async {
    // TODO: Implement API call
    return 'trip_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<void> stopTracking(String tripId, Map<String, dynamic> data) async {
    // TODO: Implement API call
  }

  @override
  Future<void> updateLocation(String tripId, Map<String, dynamic> location) async {
    // TODO: Implement API call
  }
}
