import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';

/// Styled text field for the app
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLength,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          autofocus: autofocus,
          maxLength: maxLength,
          maxLines: obscureText ? 1 : maxLines,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            counterText: '', // Hide character counter
          ),
        ),
      ],
    );
  }
}

/// Numeric text field optimized for number input
class NumericTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? suffix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool allowDecimals;
  final bool allowNegative;
  final int? maxLength;

  const NumericTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.suffix,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.allowDecimals = false,
    this.allowNegative = false,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    String pattern = allowDecimals
        ? (allowNegative ? r'^-?[\d]*\.?[\d]*' : r'^[\d]*\.?[\d]*')
        : (allowNegative ? r'^-?[\d]*' : r'^[\d]*');

    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      hint: hint,
      helperText: helperText,
      keyboardType: TextInputType.numberWithOptions(
        decimal: allowDecimals,
        signed: allowNegative,
      ),
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      maxLength: maxLength,
      suffixIcon: suffix != null
          ? Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Text(
                suffix!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : null,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(pattern)),
      ],
    );
  }
}
