import 'package:driversense_app/features/auth/domain/entities/user.dart';

/// User data model for API serialization
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.role,
    required super.language,
    required super.totpEnabled,
    super.phoneNumber,
    super.avatarUrl,
    super.createdAt,
  });

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      role: json['role'] as String? ?? 'driver',
      language: json['language'] as String? ?? 'nl',
      totpEnabled: json['totp_enabled'] as bool? ?? false,
      phoneNumber: json['phone_number'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'language': language,
      'totp_enabled': totpEnabled,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Create from entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      role: user.role,
      language: user.language,
      totpEnabled: user.totpEnabled,
      phoneNumber: user.phoneNumber,
      avatarUrl: user.avatarUrl,
      createdAt: user.createdAt,
    );
  }
}
