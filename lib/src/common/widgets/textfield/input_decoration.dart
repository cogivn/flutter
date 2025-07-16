import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

import '../../../../generated/colors.gen.dart';
import '../../extensions/build_context_x.dart';

/// A customized input decoration class that applies an underline style
/// to text fields according to the design system guidelines.
///
/// This class creates a consistent text field appearance with an underline border,
/// proper label styling, and appropriate color states for various field conditions
/// like hover, focus, error, and disabled states.
class UnderlineInputDecoration {
  /// Creates an [InputDecoration] with underline border styling
  ///
  /// Use this factory method to create a properly styled input decoration
  /// with underline border that matches the app's design system.
  static InputDecoration styleFrom(
    BuildContext context, {
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
    Color? disabledColor,
    Color? borderColor,
    double? borderWidth,
    int helperMaxLines = 1,
    TextStyle? hintStyle,
  }) {
    final isError = errorText != null && errorText.isNotEmpty;

    // Default colors based on state
    final defaultBorderColor =
        isError ? ColorName.textError : borderColor ?? ColorName.line;

    final defaultDisabledColor = disabledColor ??
        ColorName.line.withValues(
          alpha: 0.5,
        );

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      fillColor: fillColor,
      filled: fillColor != null,
      helperMaxLines: helperMaxLines,
      errorMaxLines: helperMaxLines,

      // Content padding for underline style
      contentPadding: EdgeInsets.symmetric(vertical: 8.ss, horizontal: 0),

      // Label styling
      floatingLabelStyle: context.textTheme.medium.copyWith(
        color: isError ? ColorName.textError : ColorName.primary,
        fontSize: 14.fss,
      ),

      // Error styling
      errorStyle: context.textTheme.medium.copyWith(
        color: ColorName.textError,
        fontSize: 10.fss,
      ),

      // Helper text styling
      helperStyle: context.textTheme.medium.copyWith(
        color: ColorName.textSecondary,
        fontSize: 10.fss,
      ),

      // Label text styling
      labelStyle: context.textTheme.medium.copyWith(
        color: ColorName.textSecondary,
      ),

      hintStyle: hintStyle ?? context.textTheme.medium.copyWith(
        color: ColorName.textSecondary,
      ),

      // Borders
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: defaultBorderColor,
          width: borderWidth ?? 1.5,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: ColorName.primary,
          width: borderWidth ?? 1.5,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: ColorName.textError,
          width: borderWidth ?? 1.5,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: ColorName.textError,
          width: borderWidth ?? 1.5,
        ),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: defaultDisabledColor,
          width: borderWidth ?? 1.5,
          style: BorderStyle.solid,
        ),
      ),
    );
  }
}
