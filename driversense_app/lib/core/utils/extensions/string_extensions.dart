/// String extension methods
extension StringExtensions on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize first letter of each word
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(this);
  }

  /// Check if string is numeric
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Remove all whitespace
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Convert to snake_case
  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Convert to camelCase
  String toCamelCase() {
    final parts = split('_');
    if (parts.length == 1) return this;
    return parts.first +
        parts.skip(1).map((part) => part.capitalize()).join();
  }

  /// Get initials from name
  String get initials {
    final words = trim().split(' ').where((w) => w.isNotEmpty);
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  /// Parse as nullable int
  int? toIntOrNull() => int.tryParse(this);

  /// Parse as nullable double
  double? toDoubleOrNull() => double.tryParse(this);
}

/// Nullable string extensions
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Return empty string if null
  String orEmpty() => this ?? '';

  /// Return default value if null or empty
  String orDefault(String defaultValue) {
    return isNullOrEmpty ? defaultValue : this!;
  }
}
