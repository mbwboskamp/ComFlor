import 'package:equatable/equatable.dart';

/// Privacy zone entity
/// Represents a geographic area where tracking should be paused
class PrivacyZone extends Equatable {
  /// Unique identifier
  final String id;

  /// User-friendly name for the zone
  final String name;

  /// Address or description of the location
  final String address;

  /// Center latitude of the zone
  final double latitude;

  /// Center longitude of the zone
  final double longitude;

  /// Radius in meters
  final int radius;

  /// Whether the zone is currently active
  final bool isActive;

  /// When the zone was created
  final DateTime createdAt;

  /// When the zone was last updated
  final DateTime? updatedAt;

  const PrivacyZone({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  /// Check if a given coordinate is within this privacy zone
  bool containsPoint(double lat, double lng) {
    // Using Haversine formula to calculate distance
    const double earthRadius = 6371000; // meters
    final double dLat = _toRadians(lat - latitude);
    final double dLng = _toRadians(lng - longitude);

    final double a = _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(latitude)) *
            _cos(_toRadians(lat)) *
            _sin(dLng / 2) *
            _sin(dLng / 2);

    final double c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    final double distance = earthRadius * c;

    return distance <= radius;
  }

  double _toRadians(double degrees) => degrees * 3.14159265359 / 180;
  double _sin(double x) => _taylorSin(x);
  double _cos(double x) => _taylorSin(x + 3.14159265359 / 2);
  double _sqrt(double x) => x > 0 ? _newtonSqrt(x) : 0;
  double _atan2(double y, double x) {
    // Simplified atan2 approximation
    if (x > 0) return _atan(y / x);
    if (x < 0 && y >= 0) return _atan(y / x) + 3.14159265359;
    if (x < 0 && y < 0) return _atan(y / x) - 3.14159265359;
    if (x == 0 && y > 0) return 3.14159265359 / 2;
    if (x == 0 && y < 0) return -3.14159265359 / 2;
    return 0;
  }

  double _atan(double x) {
    // Taylor series approximation for atan
    if (x.abs() > 1) {
      return (x > 0 ? 1 : -1) * (3.14159265359 / 2 - _atan(1 / x));
    }
    double result = x;
    double term = x;
    for (int i = 1; i < 10; i++) {
      term *= -x * x * (2 * i - 1) / (2 * i + 1);
      result += term;
    }
    return result;
  }

  double _taylorSin(double x) {
    // Normalize angle to [-pi, pi]
    while (x > 3.14159265359) x -= 2 * 3.14159265359;
    while (x < -3.14159265359) x += 2 * 3.14159265359;

    double result = x;
    double term = x;
    for (int i = 1; i < 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  double _newtonSqrt(double x) {
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  /// Create a copy with updated fields
  PrivacyZone copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? radius,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrivacyZone(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        radius,
        isActive,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'PrivacyZone(id: $id, name: $name, radius: ${radius}m, active: $isActive)';
  }
}
