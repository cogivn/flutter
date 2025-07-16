import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizing/sizing.dart';

import '../../../../generated/colors.gen.dart';
import '../../extensions/build_context_x.dart';

/// # BaseAppBarThemeExtension Usage Guide
///
/// This extension provides consistent styling for app bars across your MightyBush application.
/// 
/// ## 1. Adding to Your Theme
/// 
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:your_app/src/common/widgets/appbar.dart';
/// import 'package:your_app/generated/colors.gen.dart';
/// 
/// ThemeData buildAppTheme() {
///   return ThemeData(
///     // Other theme properties...
///     extensions: [
///       BaseAppBarThemeExtension(
///         backgroundColor: ColorName.primary,
///         titleColor: Colors.white,
///         iconColor: Colors.white,
///         elevation: 0,
///         padding: const EdgeInsets.symmetric(horizontal: 8.0), // Custom padding for all app bars
///       ),
///     ],
///   );
/// }
/// ```
/// 
/// ## 2. Accessing in Widgets
/// 
/// ```dart
/// // Using BuildContext extension
/// final appBarTheme = context.BaseAppBarTheme;
/// 
/// return AppBar(
///   backgroundColor: appBarTheme.backgroundColor,
///   title: Text(
///     'My Title',
///     style: TextStyle(color: appBarTheme.titleColor),
///   ),
///   iconTheme: IconThemeData(color: appBarTheme.iconColor),
///   elevation: appBarTheme.elevation,
/// );
/// 
/// // Alternatively, using ThemeData extension
/// final appBarTheme = Theme.of(context).BaseAppBarTheme;
/// ```
/// 
/// ## 3. Creating Multiple Theme Variations
/// 
/// ```dart
/// // Light theme extension
/// final lightAppBarTheme = BaseAppBarThemeExtension(
///   backgroundColor: ColorName.primary,
///   titleColor: Colors.black,
///   iconColor: Colors.black,
///   elevation: 0,
///   padding: const EdgeInsets.symmetric(horizontal: 8.0),
/// );
/// 
/// // Dark theme extension
/// final darkAppBarTheme = BaseAppBarThemeExtension(
///   backgroundColor: ColorName.darkGrey,
///   titleColor: Colors.white,
///   iconColor: Colors.white,
///   elevation: 1.0,
///   padding: const EdgeInsets.symmetric(horizontal: 16.0), // Different padding for dark theme
/// );
/// 
/// // Add to respective themes
/// ThemeData lightTheme = ThemeData.light().copyWith(
///   extensions: [lightAppBarTheme],
/// );
/// 
/// ThemeData darkTheme = ThemeData.dark().copyWith(
///   extensions: [darkAppBarTheme],
/// );
/// ```
/// 
/// ## 4. Using with BaseAppBar
/// 
/// The [BaseAppBar] widget automatically uses this theme extension,
/// so you don't need to specify these properties manually:
/// 
/// ```dart
/// Scaffold(
///   appBar: BaseAppBar(
///     titleText: 'Home Screen',
///     // backgroundColor, elevation, padding, etc. will automatically
///     // use values from BaseAppBarThemeExtension
///   ),
///   body: YourBody(),
/// )
/// ```
/// 
/// ## 5. Customizing Individual App Bars
/// 
/// You can override the theme padding for individual app bars:
/// 
/// ```dart
/// BaseAppBar(
///   titleText: 'Custom Padding',
///   padding: EdgeInsets.symmetric(horizontal: 24.0),
///   // This overrides the theme padding just for this app bar
/// )
/// ```

/// Extension on [ThemeData] to access [BaseAppBarThemeExtension].
extension AppBarThemeExtensionGetter on ThemeData {
  /// Gets the [BaseAppBarThemeExtension] from the current theme.
  BaseAppBarThemeExtension get baseAppBarTheme =>
      extension<BaseAppBarThemeExtension>() ?? BaseAppBarThemeExtension.fallback;
}

/// Extension on [BuildContext] to access [BaseAppBarThemeExtension] from the current theme.
extension AppBarThemeExtensionContext on BuildContext {
  /// Gets the [BaseAppBarThemeExtension] from the current theme.
  BaseAppBarThemeExtension get baseAppBarTheme =>
      Theme.of(this).extension<BaseAppBarThemeExtension>() ?? BaseAppBarThemeExtension.fallback;
}

/// Custom theme extension for AppBar styling in the Mighty Bush application.
/// 
/// This extension provides consistent styling options for AppBars across the app,
/// including default colors, text styles, and icon themes.
class BaseAppBarThemeExtension extends ThemeExtension<BaseAppBarThemeExtension> {
  /// The default background color for AppBars.
  final Color backgroundColor;
  
  /// The default text color for AppBar titles.
  final Color titleColor;
  
  /// The default color for AppBar icons.
  final Color iconColor;
  
  /// The default elevation for AppBars.
  final double elevation;
  
  /// The default content padding for AppBars.
  /// 
  /// This controls the padding around all content in the AppBar.
  /// If null, the default AppBar padding is used.
  final EdgeInsetsGeometry? padding;
  
  /// Creates an [BaseAppBarThemeExtension] with the given styling properties.
  const BaseAppBarThemeExtension({
    required this.backgroundColor,
    required this.titleColor,
    required this.iconColor,
    required this.elevation,
    this.padding,
  });
  
  /// Creates a fallback [BaseAppBarThemeExtension] with default values.
  static const fallback = BaseAppBarThemeExtension(
    backgroundColor: ColorName.primary,
    titleColor: Colors.black,
    iconColor: Colors.black,
    elevation: 0,
    padding: null,
  );
  
  @override
  ThemeExtension<BaseAppBarThemeExtension> copyWith({
    Color? backgroundColor,
    Color? titleColor,
    Color? iconColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
  }) {
    return BaseAppBarThemeExtension(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleColor: titleColor ?? this.titleColor,
      iconColor: iconColor ?? this.iconColor,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
    );
  }
  
  @override
  ThemeExtension<BaseAppBarThemeExtension> lerp(
    covariant ThemeExtension<BaseAppBarThemeExtension>? other, 
    double t,
  ) {
    if (other is! BaseAppBarThemeExtension) {
      return this;
    }
    
    return BaseAppBarThemeExtension(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      titleColor: Color.lerp(titleColor, other.titleColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      elevation: t < 0.5 ? elevation : other.elevation,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
    );
  }
}

/// A custom AppBar for the Mighty Bush application that provides consistent styling
/// and behavior across the app.
///
/// The [BaseAppBar] supports common AppBar customizations while applying
/// the app's default styling and behavior patterns.
///
/// ## Basic Usage
/// 
/// ```dart
/// Scaffold(
///   appBar: BaseAppBar(
///     titleText: 'Home Screen',
///     actions: [
///       AppBarAction.notification(
///         onPressed: () => showNotifications(context),
///         unreadCount: 3,
///       ),
///       AppBarAction.settings(
///         onPressed: () => openSettings(context),
///       ),
///     ],
///   ),
///   body: HomeBody(),
/// )
/// ```
///
/// ## With Back Button
///
/// ```dart
/// Scaffold(
///   appBar: BaseAppBar(
///     titleText: 'Product Details',
///     leading: AppBarAction.back(
///       onPressed: () => Navigator.of(context).pop(),
///     ),
///   ),
///   body: ProductDetailsBody(),
/// )
/// ```
///
/// ## Transparent AppBar
/// 
/// ```dart
/// Scaffold(
///   appBar: BaseAppBar.transparent(
///     titleText: 'Photo View',
///     leading: AppBarAction.close(
///       onPressed: () => Navigator.of(context).pop(),
///     ),
///     actions: [
///       AppBarAction.share(
///         onPressed: () => shareImage(),
///       ),
///     ],
///   ),
///   body: PhotoViewerBody(),
/// )
/// ```
///
/// ## Customizing Appearance
/// 
/// ```dart
/// Scaffold(
///   appBar: BaseAppBar(
///     titleText: 'Search Results',
///     backgroundColor: ColorName.secondary,
///     elevation: 4.0,
///     iconTheme: IconThemeData(color: Colors.white),
///     automaticallyImplyLeading: false,
///   ),
///   body: SearchResultsBody(),
/// )
/// ```
///
/// To use theme-based styling, add [BaseAppBarThemeExtension] to your app's theme:
/// 
/// ```dart
/// ThemeData(
///   // Other theme properties...
///   extensions: [
///     BaseAppBarThemeExtension(
///       backgroundColor: ColorName.primary,
///       titleColor: Colors.white,
///       iconColor: Colors.white,
///       elevation: 0,
///     ),
///   ],
/// )
/// ```
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    super.key,
    this.title,
    this.titleText,
    this.leading,
    this.actions,
    this.toolbarHeight = kToolbarHeight,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
    this.titleSpacing,
    this.shadowColor,
    this.shape,
    this.iconTheme,
    this.actionsIconTheme,
    this.flexibleSpace,
    this.bottom,
    this.foregroundColor,
    this.systemOverlayStyle,
    this.padding,
  });

  /// Creates a transparent app bar with no elevation, suitable for overlaying content.
  /// 
  /// This factory constructor creates an app bar with a transparent background,
  /// zero elevation, and system UI that allows content to appear underneath
  /// the status bar.
  /// 
  /// Ideal for photo viewers, immersive galleries, or any screen where
  /// the content should extend to the edges of the screen.
  factory BaseAppBar.transparent({
    Key? key,
    Widget? title,
    String? titleText,
    Widget? leading,
    List<Widget>? actions,
    double toolbarHeight = kToolbarHeight,
    bool centerTitle = true,
    bool automaticallyImplyLeading = false,
    double? titleSpacing,
    ShapeBorder? shape,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    Color? foregroundColor,
    SystemUiOverlayStyle? systemOverlayStyle,
    EdgeInsetsGeometry? padding,
  }) {
    return BaseAppBar(
      key: key,
      title: title,
      titleText: titleText,
      leading: leading,
      actions: actions,
      toolbarHeight: toolbarHeight,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleSpacing: titleSpacing,
      shadowColor: Colors.transparent,
      shape: shape,
      iconTheme: iconTheme ?? const IconThemeData(color: Colors.white),
      actionsIconTheme: actionsIconTheme ?? const IconThemeData(color: Colors.white),
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      foregroundColor: foregroundColor ?? Colors.white,
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.light,
      padding: padding,
    );
  }

  /// A widget to display as the title in the app bar.
  /// If both [title] and [titleText] are provided, [title] takes precedence.
  final Widget? title;
  
  /// A text string to display as the title in the app bar.
  /// This is converted to a Text widget if [title] is not provided.
  final String? titleText;
  
  /// A widget to display before the title.
  /// Typically a BackButton or an IconButton with a menu icon.
  final Widget? leading;
  
  /// A list of widgets to display in a row after the title.
  /// Typically IconButtons representing common actions.
  final List<Widget>? actions;
  
  /// The height of the app bar. Defaults to [kToolbarHeight].
  final double toolbarHeight;
  
  /// The background color of the app bar. 
  /// If null, uses the [BaseAppBarThemeExtension.backgroundColor] from the current theme.
  final Color? backgroundColor;
  
  /// The elevation of the app bar. 
  /// If null, uses the [BaseAppBarThemeExtension.elevation] from the current theme.
  final double? elevation;
  
  /// Whether to center the title. Defaults to true.
  final bool centerTitle;
  
  /// Whether to automatically imply a leading widget if none is provided.
  /// Defaults to false in BaseAppBar (unlike standard AppBar which defaults to true).
  final bool automaticallyImplyLeading;
  
  /// The spacing around the title. If null, then [NavigationToolbar.kMiddleSpacing] is used.
  final double? titleSpacing;
  
  /// The color of the shadow below the app bar.
  final Color? shadowColor;
  
  /// The shape of the app bar's material and its shadow.
  final ShapeBorder? shape;
  
  /// The color, opacity, and size to use for app bar icons.
  final IconThemeData? iconTheme;
  
  /// The color, opacity, and size to use for action icons in the app bar.
  final IconThemeData? actionsIconTheme;
  
  /// A widget to place behind the [title] in the app bar.
  final Widget? flexibleSpace;
  
  /// A widget to display at the bottom of the app bar.
  final PreferredSizeWidget? bottom;
  
  /// The default color for the title, icons, etc.
  final Color? foregroundColor;
  
  /// The style of the system overlays to apply to the app bar.
  final SystemUiOverlayStyle? systemOverlayStyle;
  
  /// Custom padding to apply to the AppBar content.
  /// 
  /// If null, the default padding is used or the padding defined in the theme.
  /// This allows customizing the spacing around all content in the AppBar.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final appBarTheme = context.baseAppBarTheme;
    
    final Widget titleWidget = title ?? (titleText != null 
        ? Text(
            titleText!,
            style: context.textTheme.bold.copyWith(
              fontSize: 18.fss,
              color: appBarTheme.titleColor,
            ),
          ) 
        : const SizedBox());

    // Get the effective padding from instance property or theme
    final effectivePadding = padding ?? appBarTheme.padding;
    
    if (effectivePadding != null) {
      // Create wrapped versions of the leading, title, and actions with padding
      final paddedLeading = leading != null 
          ? Padding(padding: EdgeInsets.only(left: effectivePadding.horizontal / 2), child: leading)
          : null;
      
      final paddedTitle = Padding(
        padding: EdgeInsets.symmetric(horizontal: effectivePadding.horizontal / 2),
        child: titleWidget,
      );
      
      final paddedActions = actions?.map((action) =>
              Padding(
                padding: EdgeInsets.only(right: effectivePadding.horizontal / actions!.length / 2),
                child: action,
              )
            ).toList();

      return AppBar(
        title: paddedTitle,
        leading: paddedLeading,
        actions: paddedActions,
        backgroundColor: backgroundColor ?? appBarTheme.backgroundColor,
        toolbarHeight: toolbarHeight,
        elevation: elevation ?? appBarTheme.elevation,
        centerTitle: centerTitle,
        automaticallyImplyLeading: automaticallyImplyLeading,
        titleSpacing: 0, // Use custom padding instead of titleSpacing
        shadowColor: shadowColor,
        shape: shape,
        iconTheme: iconTheme ?? IconThemeData(color: appBarTheme.iconColor),
        actionsIconTheme: actionsIconTheme ?? IconThemeData(color: appBarTheme.iconColor),
        flexibleSpace: flexibleSpace,
        bottom: bottom,
        foregroundColor: foregroundColor,
        systemOverlayStyle: systemOverlayStyle,
      );
    }
    
    // If no padding is specified, use the standard AppBar
    return AppBar(
      title: titleWidget,
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor,
      toolbarHeight: toolbarHeight,
      elevation: elevation ?? appBarTheme.elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleSpacing: titleSpacing,
      shadowColor: shadowColor,
      shape: shape,
      iconTheme: iconTheme ?? IconThemeData(color: appBarTheme.iconColor),
      actionsIconTheme: actionsIconTheme ?? IconThemeData(color: appBarTheme.iconColor),
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      foregroundColor: foregroundColor,
      systemOverlayStyle: systemOverlayStyle,
    );
  }

  @override
  Size get preferredSize {
    // Calculate the preferred size, accounting for padding if present
    final verticalPadding = padding?.vertical ?? 0;
    return Size.fromHeight(
      toolbarHeight + (bottom?.preferredSize.height ?? 0) + verticalPadding
    );
  }
}

/// Global navigator key for accessing navigator state from static methods.
/// This should be set in your MaterialApp or CupertinoApp.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
