import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

import '../../../../generated/colors.gen.dart';
import '../../extensions/build_context_x.dart';

/// A customizable solid button with loading state support
///
/// This button provides consistent styling with various customization options
/// including colors, dimensions, and state handling (enabled/disabled/loading).
/// By default, it follows the Android XML style 'general_btn_black_font_white' with:
/// - Black background
/// - White text color
/// - 10dp top/bottom padding
/// - 30dp left/right padding
/// - 18dp text size
///
/// The [text] is displayed as the button label.
/// The [onPressed] callback is triggered when the button is tapped while enabled.
/// The [isEnabled] flag determines if the button is interactive.
/// The [isLoading] flag shows a loading indicator instead of text when true.
/// The [margin] allows customization of the button's external spacing.
///
/// The button automatically adapts its appearance based on enabled state
/// and respects theme settings while allowing custom color overrides.
class SolidButton extends StatelessWidget {
  const SolidButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 40,
    this.radius = 0,
    this.isEnabled = true,
    this.isLoading = false,
    this.width = double.infinity,
    this.fontSize = 16,
    this.foregroundColor = Colors.white, // Default to white text color
    this.backgroundColor = Colors.black, // Default to black background
    this.disabledBackgroundColor = ColorName.buttonDisabled,
    this.disabledForegroundColor,
    this.switchDuration = const Duration(milliseconds: 300),
    this.elevation = 0, // Add elevation property with default value 0
    this.margin, // Added margin property
  });

  /// The text label displayed on the button
  final String text;

  /// The button's corner radius
  final double radius;

  /// Whether the button is enabled and interactive
  final bool isEnabled;

  /// Whether the button is in loading state
  final bool isLoading;

  /// The height of the button
  final double height;

  /// The font size for the button text
  final double fontSize;

  /// The width of the button (defaults to full width)
  final double width;

  /// Background color of the enabled button (defaults to black)
  final Color backgroundColor;

  /// Text color of the enabled button (defaults to white)
  final Color foregroundColor;

  /// Text color of the disabled button (optional)
  final Color? disabledForegroundColor;

  /// Background color of the disabled button
  final Color disabledBackgroundColor;

  /// Callback triggered when the button is tapped
  final GestureTapCallback? onPressed;
  
  /// Duration for the AnimatedSwitcher transition
  final Duration switchDuration;

  /// The elevation/shadow depth of the button
  final double elevation;
  
  /// External margin around the button
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final Widget buttonWidget = SizedBox(
      width: width,
      height: height.ss,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: isEnabled ? foregroundColor : disabledForegroundColor,
          padding: EdgeInsets.zero,
          disabledForegroundColor: disabledForegroundColor ??
              ColorName.textSecondary.withValues(alpha: 0.5),
          disabledBackgroundColor: disabledBackgroundColor,
          elevation: elevation, // Use the elevation property
          alignment: Alignment.center,
          textStyle: context.textTheme.bold.copyWith(
            fontSize: fontSize.fss,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: _ButtonContent(
          text: text,
          isLoading: isLoading,
          switchDuration: switchDuration,
          loadingColor: backgroundColor,
        ),
      ),
    );
    
    // Apply margin if provided, otherwise return the button as is
    return margin != null 
        ? Padding(padding: margin!, child: buttonWidget) 
        : buttonWidget;
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.text,
    required this.isLoading,
    required this.switchDuration,
    required this.loadingColor,
  });
  
  final String text;
  final bool isLoading;
  final Duration switchDuration;
  final Color loadingColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: switchDuration,
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      child: isLoading 
        ? _LoadingIndicator(key: const ValueKey('loading'), color: loadingColor) 
        : Text(text, key: const ValueKey('text')),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({
    super.key,
    required this.color,
  });
  
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          // Use inverted color for better visibility
          color,
        ),
      ),
    );
  }
}
