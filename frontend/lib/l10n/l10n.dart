import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// Locales the app ships with.
///
/// The first release is Turkish only. To add English: create
/// `lib/l10n/app_en.arb` with the same keys, add `Locale('en')` to
/// [supported] and decide how [current] is chosen (e.g. device locale).
class AppLocales {
  const AppLocales._();

  static const tr = Locale('tr');
  static const supported = [tr];

  /// Fixed locale for this release, regardless of device language.
  static const Locale current = tr;
}

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
