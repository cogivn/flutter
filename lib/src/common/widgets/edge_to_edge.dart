import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:io';

/// A widget that provides edge-to-edge content functionality.
///
/// This widget creates a true edge-to-edge UI experience by making the system navigation
/// and status bars transparent when using Android's full gesture navigation mode (mode 2).
/// For other navigation modes or platforms, it applies a customized light system overlay style
/// with white navigation bar and dark navigation bar icons.
///
/// The edge-to-edge effect is achieved by applying a custom [SystemUiOverlayStyle] that sets
/// both [SystemUiOverlayStyle.systemNavigationBarColor] and [SystemUiOverlayStyle.statusBarColor]
/// to transparent.
class EdgeToEdge extends HookWidget {
  /// Navigation mode constants for Android devices
  ///
  /// These constants represent the different navigation modes available on Android devices:
  /// - [kNavigationMode3Button]: Traditional 3-button navigation (back, home, recents)
  /// - [kNavigationMode2Button]: 2-button navigation (back, home/recents pill)
  /// - [kNavigationModeGesture]: Full gesture navigation (no buttons, only swipe gestures)
  static const int kNavigationMode3Button = 0;
  static const int kNavigationMode2Button = 1;
  static const int kNavigationModeGesture = 2;

  /// Creates an EdgeToEdge widget.
  ///
  /// * [child] is the widget below this widget in the tree. This widget will
  ///   be displayed edge-to-edge when conditions are met.
  /// * [systemOverlayStyle] is an optional custom overlay style. If provided,
  ///   only the navigation and status bar colors will be modified when needed.
  const EdgeToEdge({
    super.key,
    required this.child,
    this.systemOverlayStyle,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Optional custom system overlay style to use as a base.
  ///
  /// If provided, only the [SystemUiOverlayStyle.systemNavigationBarColor] and
  /// [SystemUiOverlayStyle.statusBarColor] properties will be modified.
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    // Get the current navigation mode using a custom hook
    final navigationMode = _useNavigationMode();

    // Create a modified light style with white navigation bar and dark icons
    final lightStyleWithWhiteNavBar = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    );

    // Base style is either the provided style or our custom light style
    var baseStyle = systemOverlayStyle ?? lightStyleWithWhiteNavBar;

    // Apply different styles based on navigation mode
    if (navigationMode == kNavigationModeGesture) {
      // For gesture navigation mode (mode 2), make navigation and status bars transparent
      baseStyle = baseStyle.copyWith(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      );
    }

    // Apply the style using AnnotatedRegion and provide the NavigationMode through inherited widget
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: baseStyle,
      child: EdgeToEdgeInherited(
        navigationMode: navigationMode,
        child: child,
      ),
    );
  }

  /// Static method to access the navigation mode from anywhere in the widget tree
  ///
  /// Returns the navigation mode value where:
  /// * [kNavigationMode3Button] = 3-button navigation
  /// * [kNavigationMode2Button] = 2-button navigation
  /// * [kNavigationModeGesture] = Gesture navigation (full screen gestures)
  ///
  /// Returns null if not called within an EdgeToEdge widget's subtree
  static int? of(BuildContext context) {
    final inheritedWidget = context.dependOnInheritedWidgetOfExactType<EdgeToEdgeInherited>();
    return inheritedWidget?.navigationMode;
  }

  /// Static method to check if the current navigation mode is gesture navigation
  ///
  /// Returns true if the mode is gesture navigation (mode 2), false otherwise.
  /// This method should be used only within the context of an EdgeToEdge widget.
  /// If called outside of an EdgeToEdge widget's subtree, it will return false.
  /// This is useful for determining if the app is in gesture navigation mode
  /// and can be used to adjust UI elements accordingly.
  static bool isGestureNavigation(BuildContext context) {
    final mode = of(context);
    return mode == kNavigationModeGesture;
  }
}

/// An InheritedWidget that provides the current navigation mode to child widgets
class EdgeToEdgeInherited extends InheritedWidget {
  /// Creates an EdgeToEdgeInherited widget.
  ///
  /// The [navigationMode] and [child] parameters must not be null.
  const EdgeToEdgeInherited({
    super.key,
    required this.navigationMode,
    required super.child,
  });

  /// The current navigation mode value.
  ///
  /// * 0 = 3-button navigation
  /// * 1 = 2-button navigation
  /// * 2 = Gesture navigation (full screen gestures)
  final int navigationMode;

  @override
  bool updateShouldNotify(EdgeToEdgeInherited oldWidget) {
    return navigationMode != oldWidget.navigationMode;
  }
}

/// A custom hook that retrieves the current navigation mode on Android devices.
///
/// Returns a navigation mode value where:
/// * 0 = 3-button navigation
/// * 1 = 2-button navigation
/// * 2 = Gesture navigation (full screen gestures)
///
/// Always returns 2 (gesture navigation) for non-Android platforms.
int _useNavigationMode() {
  // Create MethodChannel instance once
  final platform = useMemoized(
    () => const MethodChannel('dev.vietnam.flutter_base/navigation-mode'),
  );

  // State to hold the navigation mode. Default to full screen gesture mode
  final navigationMode = useState<int>(EdgeToEdge.kNavigationModeGesture);

  // Effect to fetch the navigation mode from Android
  useEffect(() {
    Future<void> getNavigationMode() async {
      if (!Platform.isAndroid) return;

      try {
        final mode = await platform.invokeMethod<int>('getNavigationMode');
        if (mode != null) {
          navigationMode.value = mode;
        }
      } on PlatformException {
        // Keep default value on error
      }
    }

    getNavigationMode();
    return null; // No cleanup needed
  }, [platform]); // Only runs when platform changes (effectively once)

  return navigationMode.value;
}
