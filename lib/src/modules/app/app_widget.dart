import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizing/sizing.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../generated/l10n.dart';
import '../../common/theme/app_theme.dart';
import '../../common/theme/app_theme_wrapper.dart';
import '../../common/utils/getit_utils.dart';
import '../../core/application/providers/lang_provider.dart';
import 'app_router.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>();
    final talker = getIt<Talker>();
    return SizingBuilder(
      baseSize: const Size(390, 844),
      builder: () => Consumer(
        builder: (context, ref, _) {
          final locale = ref.watch(langProvider);
          return AppThemeWrapper(
              appTheme: AppTheme.create(locale),
              builder: (BuildContext context, ThemeData themeData) {
                return MaterialApp.router(
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  locale: locale,
                  theme: themeData,
                  routerConfig: router.config(
                    navigatorObservers: () => [TalkerRouteObserver(talker)],
                  ),
                );
              });
        },
      ),
    );
  }
}
