import 'dart:io';

class Constants {
  static const toastDuration = 3;
  static const String mobileKindIOS = '1';
  static const String mobileKindAndroid = '2';
  static const String appVersionDefault = '';

  /// Determines mobile kind value based on platform
  /// Returns '1' for iOS, '2' for Android
  static String getMobileKind() {
    return switch (Platform.operatingSystem) {
      'ios' => mobileKindIOS,
      'android' => mobileKindAndroid,
      _ => mobileKindAndroid, // Default to Android for other platforms
    };
  }
}
