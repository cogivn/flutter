import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

import '../../../../generated/assets.gen.dart';
import '../../extensions/build_context_x.dart';
import 'appbar.dart';

/// A flexible action button widget that can be used in AppBar or anywhere else
/// in the application.
///
/// Provides consistent styling and behavior for action buttons with various
/// factory constructors for common button types.
///
/// ## Usage with BaseAppBar
///
/// ```dart
/// BaseAppBar(
///   titleText: 'Home',
///   actions: [
///     AppBarAction.notification(
///       onPressed: () => showNotifications(context),
///       unreadCount: 3,
///     ),
///     AppBarAction.settings(
///       onPressed: () => openSettings(context),
///     ),
///   ],
/// )
/// ```
///
/// ## Usage with back button
///
/// ```dart
/// BaseAppBar(
///   titleText: 'Product Details',
///   leading: AppBarAction.back(
///     onPressed: () => Navigator.of(context).pop(),
///   ),
/// )
/// ```
///
/// ## Usage outside AppBar
///
/// ```dart
/// Row(
///   mainAxisAlignment: MainAxisAlignment.end,
///   children: [
///     AppBarAction.favorite(
///       onPressed: () => toggleFavorite(),
///       isSelected: isFavorite,
///     ),
///     AppBarAction.share(
///       onPressed: () => shareContent(),
///     ),
///   ],
/// )
/// ```
///
/// ## Available action button types
///
/// - `AppBarAction.back()` - Back button
/// - `AppBarAction.close()` - Close button (X)
/// - `AppBarAction.menu()` - Menu button (hamburger)
/// - `AppBarAction.settings()` - Settings button
/// - `AppBarAction.notification()` - Notification button (with badge support)
/// - `AppBarAction.search()` - Search button
/// - `AppBarAction.more()` - More options button (3 vertical dots)
/// - `AppBarAction.share()` - Share button
/// - `AppBarAction.favorite()` - Favorite button (with selected state)
/// - `AppBarAction.filter()` - Filter button (with selected state)
///
/// ## Advanced customization
///
/// You can also create a custom action button with the default constructor:
///
/// ```dart
/// AppBarAction(
///   icon: Icons.verified_user,
///   onPressed: () => verifyAccount(),
///   color: ColorName.success,
///   badge: 1,
///   badgeColor: Colors.red,
/// )
/// ```
///
/// Or with a custom icon widget:
///
/// ```dart
/// AppBarAction(
///   iconWidget: SvgPicture.asset(
///     'assets/icons/custom_icon.svg',
///     width: 24,
///     height: 24,
///     color: ColorName.primary,
///   ),
///   onPressed: () => customAction(),
/// )
/// ```
class AppBarAction extends StatelessWidget {
  /// Default constructor with full customization options
  const AppBarAction({
    super.key,
    this.icon,
    this.iconWidget,
    required this.onPressed,
    this.color,
    this.size = 18.0,
    this.tooltip,
    this.isSelected = false,
    this.badge,
    this.badgeColor = Colors.red,
  }) : assert(icon != null || iconWidget != null,
            'Either icon or iconWidget must be provided');

  /// The icon to display (ignored if iconWidget is provided)
  final IconData? icon;

  /// A custom widget to use instead of an icon
  /// Useful for SVG icons or other custom widgets
  final Widget? iconWidget;

  /// Called when the button is tapped
  final VoidCallback onPressed;

  /// The color to use for the icon
  final Color? color;

  /// The size of the icon (defaults to 18.w for consistency)
  final double size;

  /// The tooltip to show when long-pressing the button
  final String? tooltip;

  /// Whether this action is currently selected
  final bool isSelected;

  /// Optional badge count to display over the icon
  final int? badge;

  /// Color for the badge background
  final Color badgeColor;

  /// Creates a back button action
  ///
  /// This action displays a back arrow icon that triggers the [onPressed] callback
  /// when tapped.
  factory AppBarAction.back({
    Key? key,
    required VoidCallback onPressed,
    Color? color,
    double? size,
    String? tooltip,
    Widget? iconWidget,
  }) {
    return AppBarAction(
      key: key,
      icon: iconWidget == null ? Icons.arrow_back_ios : null,
      iconWidget: iconWidget,
      onPressed: onPressed,
      color: color,
      size: size ?? 18.0.ss,
      tooltip: tooltip ?? 'Back',
    );
  }

  /// Creates a close button action
  ///
  /// This action displays a close (X) icon that triggers the [onPressed] callback
  /// when tapped.
  factory AppBarAction.close({
    Key? key,
    required VoidCallback onPressed,
    Color? color,
    double? size,
    String? tooltip,
    Widget? iconWidget,
  }) {
    return AppBarAction(
      key: key,
      icon: iconWidget == null ? Icons.close : null,
      iconWidget: iconWidget,
      onPressed: onPressed,
      color: color,
      size: size ?? 18.0.ss,
      tooltip: tooltip ?? 'Close',
    );
  }

  /// Creates a menu button action
  ///
  /// This action displays a hamburger menu icon that triggers the [onPressed] callback
  /// when tapped, typically used to open a drawer.
  factory AppBarAction.icon({
    Key? key,
    required VoidCallback onPressed,
    required IconData iconData,
    Color? color,
    double? size,
    String? tooltip,
  }) {
    return AppBarAction(
      key: key,
      icon: iconData,
      onPressed: onPressed,
      color: color,
      size: size ?? 18.0.ss,
      tooltip: tooltip ?? 'Menu',
    );
  }

  /// Creates a menu button action
  ///
  /// This action displays a hamburger menu icon that triggers the [onPressed] callback
  /// when tapped, typically used to open a drawer.
  factory AppBarAction.imageIcon({
    Key? key,
    required VoidCallback onPressed,
    required AssetGenImage icon,
    Color? color,
    double? size,
    String? tooltip,
  }) {
    return AppBarAction(
      key: key,
      iconWidget: icon.image(
        width: size ?? 24.0.ss,
        height: size ?? 24.0.ss,
        color: color,
      ),
      onPressed: onPressed,
      color: color,
      size: size ?? 24.0.ss,
    );
  }

  /// Creates a settings button action
  ///
  /// This action displays a settings (gear) icon that triggers the [onPressed] callback
  /// when tapped.
  factory AppBarAction.settings({
    Key? key,
    required VoidCallback onPressed,
    Color? color,
    double? size,
    String? tooltip,
    bool isSelected = false,
    Widget? iconWidget,
  }) {
    return AppBarAction(
      key: key,
      icon: iconWidget == null ? Icons.settings : null,
      iconWidget: iconWidget,
      onPressed: onPressed,
      color: color,
      size: size ?? 18.0.ss,
      tooltip: tooltip ?? 'Settings',
      isSelected: isSelected,
    );
  }

  factory AppBarAction.text({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    required BuildContext context,
    Color? color,
    Widget? iconWidget,
  }) {
    final appBarTheme = context.baseAppBarTheme;
    return AppBarAction(
      key: key,
      iconWidget: Text(text,
          style: context.textTheme.medium.copyWith(
            color: appBarTheme.titleColor,
          )),
      onPressed: onPressed,
    );
  }

  /// Creates a notification button action with optional badge
  ///
  /// This action displays a notification bell icon that triggers the [onPressed]
  /// callback when tapped. If [unreadCount] is provided and greater than 0,
  /// it shows a badge with the count.
  factory AppBarAction.notification({
    Key? key,
    required VoidCallback onPressed,
    Color? color,
    double? size,
    String? tooltip,
    int? unreadCount,
    Color badgeColor = Colors.red,
    bool isSelected = false,
    Widget? iconWidget,
  }) {
    return AppBarAction(
      key: key,
      icon: iconWidget == null ? Icons.notifications : null,
      iconWidget: iconWidget,
      onPressed: onPressed,
      color: color,
      size: size ?? 18.0.ss,
      tooltip: tooltip ?? 'Notifications',
      badge: unreadCount,
      badgeColor: badgeColor,
      isSelected: isSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the icon color from the theme extension instead of hardcoding to ColorName.primary
    final appBarTheme = context.baseAppBarTheme;
    final Color effectiveColor = color ?? appBarTheme.iconColor;

    // Apply responsive sizing to the default size in the build method
    final effectiveSize = size is int ? size.toDouble().ss : size;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: iconWidget != null
              ? iconWidget!
              : Icon(
                  icon,
                  color: isSelected
                      ? effectiveColor
                      : effectiveColor.withValues(alpha: 0.8),
                  size: effectiveSize,
                ),
          tooltip: tooltip,
          onPressed: onPressed,
        ),
        if (badge != null && badge! > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badge! > 99 ? '99+' : badge.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
