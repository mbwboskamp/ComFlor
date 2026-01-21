import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:driversense_app/core/config/app_config.dart';
import 'package:driversense_app/core/utils/logger.dart';
import 'package:driversense_app/features/tracking/domain/entities/privacy_zone.dart';

/// Service for GPS location tracking
@lazySingleton
class LocationService {
  StreamSubscription<Position>? _positionSubscription;
  final StreamController<Position> _positionController =
      StreamController<Position>.broadcast();

  List<PrivacyZone> _privacyZones = [];

  /// Stream of position updates
  Stream<Position> get positionStream => _positionController.stream;

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Check if we have permission
  Future<bool> hasPermission() async {
    final permission = await checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppLogger.warning('Location services are disabled');
        return null;
      }

      final permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          AppLogger.warning('Location permission denied');
          return null;
        }
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      AppLogger.error('Failed to get current position', e);
      return null;
    }
  }

  /// Start location tracking
  Future<void> startTracking({
    required Function(Position) onPosition,
    int? distanceFilter,
  }) async {
    try {
      final hasLocationPermission = await hasPermission();
      if (!hasLocationPermission) {
        throw Exception('Location permission not granted');
      }

      final locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter ?? AppConfig.gpsDistanceFilterMeters,
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (position) {
          _positionController.add(position);
          onPosition(position);
        },
        onError: (error) {
          AppLogger.error('Location stream error', error);
        },
      );

      AppLogger.info('Location tracking started');
    } catch (e) {
      AppLogger.error('Failed to start location tracking', e);
      rethrow;
    }
  }

  /// Stop location tracking
  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    AppLogger.info('Location tracking stopped');
  }

  /// Set privacy zones
  void setPrivacyZones(List<PrivacyZone> zones) {
    _privacyZones = zones;
  }

  /// Check if position is in a privacy zone
  bool isInPrivacyZone(Position position) {
    for (final zone in _privacyZones) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        zone.latitude,
        zone.longitude,
      );
      if (distance <= zone.radius) {
        return true;
      }
    }
    return false;
  }

  /// Calculate distance between two points
  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Calculate bearing between two points
  static double calculateBearing(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.bearingBetween(startLat, startLng, endLat, endLng);
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Dispose resources
  void dispose() {
    _positionSubscription?.cancel();
    _positionController.close();
  }
}
