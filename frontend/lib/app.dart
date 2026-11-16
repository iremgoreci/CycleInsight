import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/l10n.dart';

class CycleInsightApp extends ConsumerWidget {
  const CycleInsightApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: AppLocales.current,
      supportedLocales: AppLocales.supported,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // Dates and numbers (intl) follow the active app locale.
        Intl.defaultLocale = Localizations.localeOf(context).toLanguageTag();
        return child ?? const SizedBox.shrink();
      },
      routerConfig: router,
    );
  }
}
