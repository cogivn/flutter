import 'package:flutter/material.dart';

import 'base_text_theme_factory.dart';
import 'text_theme_interfaces.dart';

class TextThemeFactoryProvider {

  static TextThemeFactory of(Locale locale) {
    return _findTextThemeFactoryBy(locale);
  }

  static TextThemeFactory _findTextThemeFactoryBy(Locale locale) {
    switch (locale.countryCode) {
      default:
        return BaseTextThemeFactory();
    }
  }
}
