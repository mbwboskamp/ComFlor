import 'package:driversense_app/core/constants/app_constants.dart';

/// Form validation utilities
class Validators {
  Validators._();

  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mailadres is verplicht';
    }

    final regex = RegExp(AppConstants.emailPattern);
    if (!regex.hasMatch(value)) {
      return 'Voer een geldig e-mailadres in';
    }

    return null;
  }

  /// Validate password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Wachtwoord is verplicht';
    }

    if (value.length < 8) {
      return 'Wachtwoord moet minimaal 8 tekens bevatten';
    }

    return null;
  }

  /// Validate required field
  static String? required(String? value, [String fieldName = 'Dit veld']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is verplicht';
    }
    return null;
  }

  /// Validate 2FA code
  static String? twoFactorCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Verificatiecode is verplicht';
    }

    if (value.length != 6) {
      return 'Code moet 6 cijfers bevatten';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Code mag alleen cijfers bevatten';
    }

    return null;
  }

  /// Validate kilometer reading
  static String? kmReading(String? value, {int? previousReading}) {
    if (value == null || value.isEmpty) {
      return 'Kilometerstand is verplicht';
    }

    final km = int.tryParse(value);
    if (km == null) {
      return 'Voer een geldig getal in';
    }

    if (km < 0) {
      return 'Kilometerstand kan niet negatief zijn';
    }

    if (km > 9999999) {
      return 'Kilometerstand is te hoog';
    }

    if (previousReading != null && km < previousReading) {
      return 'Kilometerstand moet hoger zijn dan $previousReading';
    }

    return null;
  }

  /// Validate license plate
  static String? licensePlate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kenteken is verplicht';
    }

    // Dutch license plate format: XX-999-X, 99-XXX-9, etc.
    // Allow flexible format for international plates
    if (value.length < 4) {
      return 'Voer een geldig kenteken in';
    }

    return null;
  }

  /// Validate phone number
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    if (cleaned.length < 10) {
      return 'Voer een geldig telefoonnummer in';
    }

    if (!RegExp(r'^[+]?[\d]+$').hasMatch(cleaned)) {
      return 'Telefoonnummer mag alleen cijfers bevatten';
    }

    return null;
  }

  /// Validate privacy zone name
  static String? privacyZoneName(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Name is optional
    }

    if (value.length > 50) {
      return 'Naam mag maximaal 50 tekens bevatten';
    }

    return null;
  }

  /// Validate privacy zone radius
  static String? privacyZoneRadius(String? value) {
    if (value == null || value.isEmpty) {
      return 'Radius is verplicht';
    }

    final radius = int.tryParse(value);
    if (radius == null) {
      return 'Voer een geldig getal in';
    }

    if (radius < AppConstants.minPrivacyZoneRadius) {
      return 'Radius moet minimaal ${AppConstants.minPrivacyZoneRadius}m zijn';
    }

    if (radius > AppConstants.maxPrivacyZoneRadius) {
      return 'Radius mag maximaal ${AppConstants.maxPrivacyZoneRadius}m zijn';
    }

    return null;
  }

  /// Validate incident description
  static String? incidentDescription(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional
    }

    if (value.length > 500) {
      return 'Beschrijving mag maximaal 500 tekens bevatten';
    }

    return null;
  }

  /// Validate message content
  static String? messageContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bericht is verplicht';
    }

    if (value.length > 2000) {
      return 'Bericht mag maximaal 2000 tekens bevatten';
    }

    return null;
  }

  /// Combine multiple validators
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
