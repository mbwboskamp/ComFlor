import 'package:flutter/material.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/theme/app_typography.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';

/// White-label theme configuration for tenant customization
class WhiteLabelTheme {
  final String tenantSlug;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final String? logoUrl;
  final String appName;

  const WhiteLabelTheme({
    required this.tenantSlug,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.logoUrl,
    required this.appName,
  });

  /// Default DriverSense theme
  static const defaultTheme = WhiteLabelTheme(
    tenantSlug: 'driversense',
    primaryColor: AppColors.primary,
    secondaryColor: AppColors.secondary,
    accentColor: AppColors.accent,
    appName: 'DriverSense',
  );

  /// Create from JSON response
  factory WhiteLabelTheme.fromJson(Map<String, dynamic> json) {
    return WhiteLabelTheme(
      tenantSlug: json['slug'] as String? ?? 'default',
      primaryColor: _parseColor(json['colors']?['primary']),
      secondaryColor: _parseColor(json['colors']?['secondary']),
      accentColor: _parseColor(json['colors']?['accent']),
      logoUrl: json['logo_url'] as String?,
      appName: json['app_name'] as String? ?? 'DriverSense',
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'slug': tenantSlug,
      'colors': {
        'primary': '#${primaryColor.value.toRadixString(16).substring(2)}',
        'secondary': '#${secondaryColor.value.toRadixString(16).substring(2)}',
        'accent': '#${accentColor.value.toRadixString(16).substring(2)}',
      },
      'logo_url': logoUrl,
      'app_name': appName,
    };
  }

  /// Parse color from hex string
  static Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      return AppColors.primary;
    }
    try {
      final hexValue = hex.replaceFirst('#', '');
      return Color(int.parse(hexValue, radix: 16) + 0xFF000000);
    } catch (e) {
      return AppColors.primary;
    }
  }

  /// Generate ThemeData from white-label configuration
  ThemeData toThemeData({bool isDark = false}) {
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final background = isDark ? AppColors.backgroundDark : AppColors.background;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final onBackground = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final onSurface = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primaryColor,
      onPrimary: _getContrastColor(primaryColor),
      secondary: secondaryColor,
      onSecondary: _getContrastColor(secondaryColor),
      tertiary: accentColor,
      onTertiary: _getContrastColor(accentColor),
      error: AppColors.error,
      onError: Colors.white,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: onBackground,
        displayColor: onBackground,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: primaryColor,
        foregroundColor: _getContrastColor(primaryColor),
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: _getContrastColor(primaryColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: _getContrastColor(primaryColor),
          elevation: 0,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          textStyle: AppTypography.buttonLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          side: BorderSide(color: primaryColor),
          textStyle: AppTypography.buttonLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: AppSpacing.buttonPaddingCompact,
          textStyle: AppTypography.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: AppSpacing.inputPadding,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: _getContrastColor(accentColor),
        elevation: 4,
        shape: const CircleBorder(),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryColor,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        circularTrackColor: primaryColor.withOpacity(0.2),
        linearTrackColor: primaryColor.withOpacity(0.2),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withOpacity(0.3),
        thumbColor: primaryColor,
        overlayColor: primaryColor.withOpacity(0.1),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return null;
        }),
      ),
    );
  }

  /// Get contrasting text color (black or white) for a background color
  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Copy with modifications
  WhiteLabelTheme copyWith({
    String? tenantSlug,
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
    String? logoUrl,
    String? appName,
  }) {
    return WhiteLabelTheme(
      tenantSlug: tenantSlug ?? this.tenantSlug,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      logoUrl: logoUrl ?? this.logoUrl,
      appName: appName ?? this.appName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WhiteLabelTheme &&
        other.tenantSlug == tenantSlug &&
        other.primaryColor == primaryColor &&
        other.secondaryColor == secondaryColor &&
        other.accentColor == accentColor &&
        other.logoUrl == logoUrl &&
        other.appName == appName;
  }

  @override
  int get hashCode {
    return Object.hash(
      tenantSlug,
      primaryColor,
      secondaryColor,
      accentColor,
      logoUrl,
      appName,
    );
  }
}
