import 'package:equatable/equatable.dart';

/// User entity representing an authenticated driver
class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String language;
  final bool totpEnabled;
  final String? phoneNumber;
  final String? avatarUrl;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.language,
    required this.totpEnabled,
    this.phoneNumber,
    this.avatarUrl,
    this.createdAt,
  });

  /// Full name of the user
  String get fullName => '$firstName $lastName';

  /// Initials for avatar placeholder
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  /// Check if user is a driver
  bool get isDriver => role == 'driver';

  /// Check if user is a manager
  bool get isManager => role == 'manager';

  /// Check if 2FA is required for this user
  bool get requires2FA => totpEnabled;

  /// Create a copy with modifications
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    String? language,
    bool? totpEnabled,
    String? phoneNumber,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      language: language ?? this.language,
      totpEnabled: totpEnabled ?? this.totpEnabled,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        role,
        language,
        totpEnabled,
        phoneNumber,
        avatarUrl,
        createdAt,
      ];

  /// Empty user for initial state
  static const empty = User(
    id: '',
    email: '',
    firstName: '',
    lastName: '',
    role: '',
    language: 'nl',
    totpEnabled: false,
  );

  /// Check if user is empty
  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;
}

/// Authentication tokens
class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime? expiresAt;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'bearer',
    required this.expiresIn,
    this.expiresAt,
  });

  /// Check if token is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if token should be refreshed (within 5 minutes of expiry)
  bool get shouldRefresh {
    if (expiresAt == null) return false;
    final refreshThreshold = expiresAt!.subtract(const Duration(minutes: 5));
    return DateTime.now().isAfter(refreshThreshold);
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, tokenType, expiresIn, expiresAt];

  static const empty = AuthTokens(
    accessToken: '',
    refreshToken: '',
    expiresIn: 0,
  );

  bool get isEmpty => accessToken.isEmpty;
}
