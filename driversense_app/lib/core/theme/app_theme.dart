import 'package:flutter/material.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/theme/app_typography.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  /// Light theme
  static ThemeData get light => _buildTheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.background,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnSecondary,
        onBackground: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      );

  /// Dark theme
  static ThemeData get dark => _buildTheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onBackground: AppColors.textPrimaryDark,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color background,
    required Color surface,
    required Color error,
    required Color onPrimary,
    required Color onSecondary,
    required Color onBackground,
    required Color onSurface,
    required Color onError,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
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
        backgroundColor: surface,
        foregroundColor: onSurface,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          side: BorderSide(
            color: brightness == Brightness.light
                ? AppColors.border
                : AppColors.surfaceVariantDark,
          ),
        ),
        color: surface,
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
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
          foregroundColor: primary,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          side: BorderSide(color: primary),
          textStyle: AppTypography.buttonLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: AppSpacing.buttonPaddingCompact,
          textStyle: AppTypography.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? AppColors.surfaceVariant
            : AppColors.surfaceVariantDark,
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
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: error, width: 2),
        ),
        contentPadding: AppSpacing.inputPadding,
        hintStyle: AppTypography.bodyLarge.copyWith(
          color: AppColors.textHint,
        ),
        labelStyle: AppTypography.bodyLarge.copyWith(
          color: AppColors.textSecondary,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: error,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 4,
        shape: const CircleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.light
            ? AppColors.textPrimary
            : surface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: brightness == Brightness.light
              ? Colors.white
              : onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: onSurface,
        ),
        contentTextStyle: AppTypography.bodyLarge.copyWith(
          color: onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: brightness == Brightness.light
            ? AppColors.border
            : AppColors.surfaceVariantDark,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        minLeadingWidth: 24,
        titleTextStyle: AppTypography.bodyLarge.copyWith(
          color: onSurface,
        ),
        subtitleTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXs,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary.withOpacity(0.5);
          }
          return null;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: primary.withOpacity(0.3),
        thumbColor: primary,
        overlayColor: primary.withOpacity(0.1),
        valueIndicatorColor: primary,
        valueIndicatorTextStyle: AppTypography.labelMedium.copyWith(
          color: onPrimary,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        circularTrackColor: primary.withOpacity(0.2),
        linearTrackColor: primary.withOpacity(0.2),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelLarge,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }
}
