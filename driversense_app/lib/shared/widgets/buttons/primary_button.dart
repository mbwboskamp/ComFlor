import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';

/// Primary action button
class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final ButtonSize size;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.size = ButtonSize.large,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: size.height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.5),
          disabledForegroundColor: theme.colorScheme.onPrimary.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: size.iconSize),
          const SizedBox(width: AppSpacing.sm),
          Text(text, style: TextStyle(fontSize: size.fontSize)),
        ],
      );
    }
    return Text(text, style: TextStyle(fontSize: size.fontSize));
  }
}

/// Button size options
enum ButtonSize {
  small(36, 14, 18),
  medium(44, 15, 20),
  large(56, 16, 24);

  final double height;
  final double fontSize;
  final double iconSize;

  const ButtonSize(this.height, this.fontSize, this.iconSize);
}
