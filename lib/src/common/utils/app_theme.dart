import 'package:flutter/material.dart';

import '../../../generated/colors.gen.dart';
import '../theme/text_theme_interfaces.dart';
import '../theme/text_theme_provider.dart';

class AppTheme {
  final TextThemeFactory factory;

  AppTheme._(this.factory);

  factory AppTheme.create(Locale locale) {
    final provider = TextThemeFactoryProvider.of(locale);
    return AppTheme._(provider);
  }

  ThemeData build() {
    return ThemeData(
      primarySwatch: ColorName.materialPrimary,
      textTheme: factory.create(),
    );
  }
}
