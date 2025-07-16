import 'package:flutter/material.dart';

import '../../../../generated/colors.gen.dart';
import '../../extensions/build_context_x.dart';

/// A button with underlined text and no elevation
///
/// This widget provides a flat button with underlined text for use cases where
/// a subtle, text-only interactive element is needed. It follows the application's
/// design patterns while providing a distinct underlined appearance.
///
/// The [text] is displayed as the button label with an underline.
/// The [onPressed] callback is triggered when the button is tapped.
/// The [isEnabled] flag determines if the button is interactive.
/// The [alignment] controls the horizontal positioning of the button (left, center, right).
///
/// Example usage:
/// ```dart
/// FlatButton(
///   text: context.s.forgotPassword,
///   onPressed: () => controller.navigateToPasswordReset(),
///   alignment: Alignment.centerRight, // Align button to the right
/// )
/// ```
class FlatButton extends StatelessWidget {
  /// Creates a flat button with underlined text
  ///
  /// The [text] parameter is required and displayed as the button label.
  /// The [onPressed] parameter is required and called when the button is pressed.
  /// The [alignment] parameter controls the button's horizontal position.
  const FlatButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
    this.color = ColorName.textSecondary,
    this.hoverColor,
    this.focusColor,
    this.splashColor,
    this.disabledColor,
    this.fontSize,
    this.textAlign,
    this.isEnabled = true,
    this.alignment = Alignment.center,
  });

  /// The text label displayed on the button with underline
  final String text;

  /// Callback triggered when the button is tapped
  final VoidCallback? onPressed;

  /// Custom text style for the button text
  final TextStyle? textStyle;

  /// Padding around the button content
  final EdgeInsetsGeometry padding;

  /// Primary color for the button text
  final Color? color;

  /// Color when the button is hovered
  final Color? hoverColor;

  /// Color when the button is focused
  final Color? focusColor;

  /// Color for the splash effect when tapped
  final Color? splashColor;

  /// Color when the button is disabled
  final Color? disabledColor;

  /// Optional font size for the button text
  final double? fontSize;

  /// Whether the button is enabled and interactive
  final bool isEnabled;

  /// Text alignment for the button text
  final TextAlign? textAlign;

  /// Horizontal alignment of the button (left, center, right)
  /// Use Alignment.centerLeft, Alignment.center, or Alignment.centerRight
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final buttonColor = isEnabled
        ? (color ?? Theme.of(context).primaryColor)
        : (disabledColor ?? ColorName.textSecondary.withValues(alpha: 0.5));

    final effectiveTextStyle = (textStyle ?? context.textTheme.medium).copyWith(
      decoration: TextDecoration.underline,
      decorationColor: buttonColor, // Make underline color match text color
      fontSize: fontSize,
      color: buttonColor,
    );

    // Follows MCP-ddd-widget-organization: Wrap TextButton with Align widget for positioning
    return Align(
      alignment: alignment,
      child: TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: TextButton.styleFrom(
          padding: padding,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const Size(0, 0),
          backgroundColor: Colors.transparent,
          foregroundColor: color,
          disabledForegroundColor:
              disabledColor ?? ColorName.textSecondary.withValues(alpha: 0.5),
          overlayColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory, // Disable ripple effect
        ),
        child: Text(
          text,
          textAlign: textAlign,
          style: effectiveTextStyle,
        ),
      ),
    );
  }
}
