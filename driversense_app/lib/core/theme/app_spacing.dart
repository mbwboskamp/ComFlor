import 'package:flutter/material.dart';

/// Application spacing constants
class AppSpacing {
  AppSpacing._();

  // Base spacing values
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Screen padding
  static const double screenPaddingHorizontal = 16.0;
  static const double screenPaddingVertical = 16.0;
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenPaddingHorizontal,
    vertical: screenPaddingVertical,
  );

  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(sm);

  // List item spacing
  static const double listItemSpacing = sm;
  static const double listItemSpacingLarge = md;

  // Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
  static const EdgeInsets buttonPaddingCompact = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  // Input field padding
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: 14.0,
  );

  // Dialog padding
  static const EdgeInsets dialogPadding = EdgeInsets.all(lg);

  // Form spacing
  static const double formFieldSpacing = md;
  static const double formSectionSpacing = xl;

  // Border radius values
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // Common border radius
  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadiusFull = BorderRadius.all(Radius.circular(radiusFull));

  // Icon sizes
  static const double iconSizeXs = 16.0;
  static const double iconSizeSm = 20.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 48.0;

  // Avatar sizes
  static const double avatarSizeSm = 32.0;
  static const double avatarSizeMd = 40.0;
  static const double avatarSizeLg = 56.0;
  static const double avatarSizeXl = 80.0;

  // Button heights
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;

  // Input heights
  static const double inputHeight = 56.0;
  static const double inputHeightSmall = 44.0;

  // Bottom navigation
  static const double bottomNavHeight = 64.0;

  // App bar
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 64.0;

  // Touch target minimum (accessibility)
  static const double minTouchTarget = 48.0;

  /// Create vertical spacing SizedBox
  static SizedBox vertical(double height) => SizedBox(height: height);

  /// Create horizontal spacing SizedBox
  static SizedBox horizontal(double width) => SizedBox(width: width);

  // Commonly used vertical spacers
  static const SizedBox verticalXs = SizedBox(height: xs);
  static const SizedBox verticalSm = SizedBox(height: sm);
  static const SizedBox verticalMd = SizedBox(height: md);
  static const SizedBox verticalLg = SizedBox(height: lg);
  static const SizedBox verticalXl = SizedBox(height: xl);
  static const SizedBox verticalXxl = SizedBox(height: xxl);

  // Commonly used horizontal spacers
  static const SizedBox horizontalXs = SizedBox(width: xs);
  static const SizedBox horizontalSm = SizedBox(width: sm);
  static const SizedBox horizontalMd = SizedBox(width: md);
  static const SizedBox horizontalLg = SizedBox(width: lg);
  static const SizedBox horizontalXl = SizedBox(width: xl);
}
