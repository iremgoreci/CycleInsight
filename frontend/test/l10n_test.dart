import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/errors/api_exception.dart';
import 'package:frontend/core/presentation/error_messages.dart';
import 'package:frontend/core/presentation/formatters.dart';
import 'package:frontend/data/models/analysis.dart';
import 'package:frontend/l10n/l10n.dart';
import 'package:frontend/screens/analysis/analysis_labels.dart';
import 'package:frontend/screens/learn/learn_content.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'support/test_harness.dart';

void main() {
  final l10n = lookupAppLocalizations(AppLocales.tr);

  setUpAll(() async {
    await initializeDateFormatting('tr');
    Intl.defaultLocale = 'tr';
  });

  group('ErrorText maps backend errors to Turkish', () {
    String map(String message, [int? status]) =>
        ErrorText.of(l10n, ApiException(message: message, statusCode: status));

    test('known backend details', () {
      expect(
        map('Incorrect email or password', 401),
        l10n.errorInvalidCredentials,
      );
      expect(map('Email already exists.', 400), l10n.errorEmailExists);
      expect(
        map('A daily log already exists for this date.', 409),
        l10n.errorDailyLogExists,
      );
      expect(
        map('A cycle with this start date already exists.', 400),
        l10n.errorCycleDuplicateStart,
      );
      expect(
        map('Value error, End date cannot be before start date.', 422),
        l10n.errorEndBeforeStart,
      );
      expect(map('Daily log not found', 404), l10n.errorDailyLogNotFound);
      expect(map('Cycle not found', 404), l10n.errorCycleNotFound);
      expect(
        map('Could not validate credentials', 401),
        l10n.errorSessionExpired,
      );
      expect(map('Unable to reach the server'), l10n.errorNetwork);
    });

    test('unknown English details never reach the UI', () {
      expect(map('field required', 422), l10n.errorInvalidInput);
      expect(map('Internal Server Error', 500), l10n.errorServer);
      expect(map('Something odd', 418), l10n.errorGeneric);
      expect(map('Request failed'), l10n.errorGeneric);
      expect(
        ErrorText.of(l10n, StateError('x'), fallback: l10n.loginFailed),
        l10n.loginFailed,
      );
    });
  });

  group('Turkish formatting', () {
    test('uppercase respects dotted and dotless i', () {
      expect(Fmt.upper('Kişisel rapor'), 'KİŞİSEL RAPOR');
      expect(Fmt.upper('Kayıtlarınız'), 'KAYITLARINIZ');
      expect(Fmt.upper("CycleInsight'ta"), "CYCLEINSIGHT'TA");
      expect(Fmt.upper('ilknur'), 'İLKNUR');
    });

    test('numbers, percentages and dates use Turkish conventions', () {
      expect(Fmt.number(28.5), '28,5');
      expect(Fmt.number(29), '29');
      expect(Fmt.fixed(0.0704, 2), '0,07');
      expect(Fmt.percent(0.22), '%22');
      expect(Fmt.date(DateTime(2026, 11, 4)), '4 Kas 2026');
      expect(Fmt.monthYear(DateTime(2026, 11, 4)), 'Kasım 2026');
      expect(Fmt.weekdayDate(DateTime(2026, 11, 4)), '4 Kasım Çarşamba');
    });

    test('relative days', () {
      final today = DateUtils.dateOnly(DateTime.now());
      expect(Fmt.relativeDay(l10n, today), 'Bugün');
      expect(
        Fmt.relativeDay(l10n, today.add(const Duration(days: 5))),
        '5 gün sonra',
      );
      expect(
        Fmt.relativeDay(l10n, today.subtract(const Duration(days: 3))),
        '3 gün önce',
      );
    });
  });

  group('InsightText', () {
    final analysis = loadFixture('analysis_rich');

    test('unknown insight types fall back to the API text', () {
      const insight = Insight(
        type: 'future_type',
        title: 'New insight',
        message: 'Shown as-is until translated.',
        priority: 'low',
      );
      final text = InsightText.of(l10n, insight, analysis);
      expect(text.title, 'New insight');
      expect(text.message, 'Shown as-is until translated.');
    });

    test('symptom insight waits for names, then localizes', () {
      final insight = analysis.insights.firstWhere(
        (i) => i.type == 'symptom_pattern',
      );
      expect(InsightText.of(l10n, insight, analysis).message, insight.message);
      final text = InsightText.of(
        l10n,
        insight,
        analysis,
        symptomNames: {for (final type in testSymptomTypes) type.id: type.name},
      );
      expect(text.title, 'Tekrarlayan semptomlar');
      expect(text.message, startsWith('Şişkinlik 13 kez kaydedildi'));
    });
  });

  group('Learn content', () {
    final content = LearnContent.of(AppLocales.tr);

    test('covers all four phases', () {
      expect(content.chapters.map((c) => c.phase).toSet().length, 4);
    });

    test('states individual variability and that estimates are not '
        'diagnoses or guarantees', () {
      expect(content.variability, contains('kişiden kişiye değişir'));
      expect(content.estimateNote, contains('tahmin'));
      expect(content.estimateNote, contains('Tıbbi teşhis değildir'));
      expect(content.estimateNote, contains('garanti'));
      expect(content.disclaimer, contains('tıbbi tavsiye değildir'));
    });

    test('lists https sources', () {
      expect(LearnContent.sources, isNotEmpty);
      for (final source in LearnContent.sources) {
        expect(source.url, startsWith('https://'));
      }
    });
  });
}
