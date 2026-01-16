import 'package:flutter/material.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/shared/widgets/buttons/primary_button.dart';

/// Secondary action button (outlined style)
class SecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final ButtonSize size;
  final Color? color;

  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.size = ButtonSize.large,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: size.height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: buttonColor,
          side: BorderSide(color: buttonColor),
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
                  valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                ),
              )
            : _buildContent(context, buttonColor),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color color) {
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
