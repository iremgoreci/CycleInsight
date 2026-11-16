import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/l10n.dart';

/// Display formatting shared across screens. Pure presentation helpers —
/// no analysis logic lives here.
///
/// Dates and numbers follow `Intl.defaultLocale`, which the app sets from
/// the active [Locale] (see `app.dart`), so a new locale needs no changes
/// here.
class Fmt {
  const Fmt._();

  static String get _locale => Intl.getCurrentLocale();

  static bool get _isTurkish => _locale.startsWith('tr');

  /// "4 Kas" / "Nov 4"
  static String shortDate(DateTime date) => DateFormat.MMMd().format(date);

  /// "4 Kas 2026" / "Nov 4, 2026"
  static String date(DateTime date) => DateFormat.yMMMd().format(date);

  /// "Çarşamba, 4 Kasım"
  static String weekdayDate(DateTime date) =>
      DateFormat.MMMMEEEEd().format(date);

  /// "Çar" / "Wed"
  static String weekday(DateTime date) => DateFormat.E().format(date);

  /// "Kasım 2026" / "November 2026"
  static String monthYear(DateTime date) => DateFormat.yMMMM().format(date);

  static int daysFromToday(DateTime date) {
    final today = DateUtils.dateOnly(DateTime.now());
    return DateUtils.dateOnly(date).difference(today).inDays;
  }

  /// "Bugün", "Yarın", "5 gün sonra", "3 gün önce".
  static String relativeDay(AppLocalizations l10n, DateTime date) {
    final diff = daysFromToday(date);
    return switch (diff) {
      0 => l10n.commonToday,
      1 => l10n.commonTomorrow,
      -1 => l10n.commonYesterday,
      > 1 => l10n.relativeInDays(diff),
      _ => l10n.relativeDaysAgo(diff.abs()),
    };
  }

  static bool isToday(DateTime date) => daysFromToday(date) == 0;

  /// One decimal unless whole: 28 / 28,5 (locale decimal separator).
  static String number(num value) => NumberFormat('#,##0.#').format(value);

  /// Fixed decimals: 0,07.
  static String fixed(num value, int decimals) =>
      NumberFormat('0.${'0' * decimals}').format(value);

  /// Locale percent: "%22" (tr) / "22%" (en).
  static String percent(double fraction) =>
      NumberFormat.percentPattern().format(fraction);

  /// Locale-aware uppercase. Dart's `toUpperCase` is not, so Turkish
  /// i/ı are mapped to İ/I first. The brand name keeps its casing rule
  /// ("CYCLEINSIGHT"), as it is not a Turkish word.
  static String upper(String value) {
    if (!_isTurkish) {
      return value.toUpperCase();
    }
    const brand = 'CycleInsight';
    return value
        .split(brand)
        .map((part) => part.replaceAll('i', 'İ').replaceAll('ı', 'I'))
        .join(brand)
        .toUpperCase();
  }
}
