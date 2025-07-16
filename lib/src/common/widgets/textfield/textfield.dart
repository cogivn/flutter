import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizing/sizing.dart';

import '../../../../generated/colors.gen.dart';
import '../../extensions/build_context_x.dart';
import 'input_decoration.dart';

/// A customizable text field with consistent styling that uses UnderlineInputDecoration by default
///
/// This widget provides a styled text field with underline border that follows
/// the design system guidelines. It supports various customization options
/// including label, error messages, helper text, and input formatting.
///
/// The [label] is displayed as the field label or placeholder.
/// The [isEnabled] flag determines if the field is interactive.
/// The [error] displays validation error messages below the field.
///
/// This text field automatically adapts its appearance based on focus state,
/// error state, and disabled state using the app's color system.
class AppTextField extends StatelessWidget {
  /// Creates a customizable text field with underline decoration by default
  ///
  /// The [label] parameter is required and displayed as the field label.
  /// Other parameters provide various customization options for appearance and behavior.
  const AppTextField({
    super.key,
    required this.label,
    this.isEnabled = true,
    this.hint,
    this.error,
    this.helper,
    this.helperMaxLines = 1,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.opacity = 0.5,
    this.onChanged,
    this.focusNode,
    this.controller,
    this.inputFormatters,
    this.decoration,
    this.style,
    this.keyboardType,
    this.cursorColor,
    this.onTap,
    this.enableInteractiveSelection,
    this.onEditingComplete,
    this.validator,
    this.autovalidateMode,
    this.obscureText = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.textInputAction = TextInputAction.done,
    this.autoFocus = false,
    this.readOnly = false,
    this.onTapOutside,
    this.onSubmitted,
  });

  /// The label text displayed for this field
  final String label;
  
  /// Optional hint text displayed when the field is empty
  final String? hint;
  
  /// Optional error message displayed below the field
  final String? error;
  
  /// Optional helper text displayed below the field
  final String? helper;
  
  /// Maximum number of lines for helper text
  final int helperMaxLines;
  
  /// Minimum number of lines for the text field
  final int? minLines;
  
  /// Maximum number of lines for the text field
  final int? maxLines;
  
  /// Maximum number of characters allowed for input
  final int? maxLength;
  
  /// Opacity level for disabled state (0.0 to 1.0)
  final double opacity;
  
  /// Whether the text field is enabled and interactive
  final bool isEnabled;
  
  /// Whether the text field is read-only
  final bool readOnly;
  
  /// Callback triggered when the text changes
  final ValueChanged<String>? onChanged;
  
  /// Focus node for controlling the focus state
  final FocusNode? focusNode;
  
  /// Controller for the text field
  final TextEditingController? controller;
  
  /// Keyboard type to display for this field
  final TextInputType? keyboardType;
  
  /// Input formatters to restrict or format text input
  final List<TextInputFormatter>? inputFormatters;
  
  /// Action button to display on the keyboard
  final TextInputAction textInputAction;
  
  /// Color of the text cursor
  final Color? cursorColor;
  
  /// Whether to auto-focus this field when displayed
  final bool autoFocus;
  
  /// Whether to show the cursor
  final bool? showCursor;
  
  /// Whether to obscure text input (for passwords)
  final bool obscureText;
  
  /// Character used to obscure text when obscureText is true
  final String obscuringCharacter;
  
  /// Custom decoration for the text field
  final InputDecoration? decoration;
  
  /// Custom text style for the input text
  final TextStyle? style;
  
  /// Callback triggered when editing is complete
  final VoidCallback? onEditingComplete;
  
  /// Whether interactive selection is enabled
  final bool? enableInteractiveSelection;
  
  /// Callback triggered when the field is tapped
  final GestureTapCallback? onTap;
  
  /// Validator function for form validation
  final FormFieldValidator<String>? validator;
  
  /// Auto-validation mode for forms
  final AutovalidateMode? autovalidateMode;
  
  /// Callback when user taps outside the field
  final TapRegionCallback? onTapOutside;
  
  /// Callback triggered when the text is submitted
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final decorationToUse = decoration ?? 
        UnderlineInputDecoration.styleFrom(
          context,
          labelText: label,
          helperText: helper,
          hintText: hint,
          errorText: error,
          helperMaxLines: helperMaxLines,
          fillColor: isEnabled
              ? Colors.transparent
              : ColorName.backgroundDisabled.withValues(alpha: .3),
          disabledColor: ColorName.line.withValues(alpha: .5),
          borderColor: ColorName.line,
        );
        
    return TextFormField(
      readOnly: readOnly,
      autofocus: autoFocus,
      enabled: isEnabled,
      showCursor: showCursor,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      controller: controller,
      onChanged: onChanged,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines ?? minLines,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      onTapOutside: onTapOutside,
      obscuringCharacter: obscuringCharacter,
      onEditingComplete: onEditingComplete,
      onTap: onTap,
      validator: validator,
      autovalidateMode: autovalidateMode,
      enableInteractiveSelection: enableInteractiveSelection,
      style: style ?? context.textTheme.medium.copyWith(fontSize: 16.fss),
      cursorColor: cursorColor ?? ColorName.primary,
      decoration: decorationToUse,
      onFieldSubmitted: onSubmitted,
    );
  }
}
