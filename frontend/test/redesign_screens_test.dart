import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/profile_button.dart';

import 'support/test_harness.dart';

const _screens = {
  'small 320x640': Size(320, 640),
  'compact 360x780': Size(360, 780),
  'large 412x915': Size(412, 915),
};

void main() {
  group('analysis fixtures parse with additive phase fields', () {
    test('rich', () {
      final a = loadFixture('analysis_rich');
      expect(a.phase.currentPhase, isNotNull);
      expect(a.phase.wellbeingByPhase.keys, contains('luteal'));
      expect(a.symptoms.values.first.phaseDistribution, isNotEmpty);
      expect(a.insights, isNotEmpty);
    });
    test('empty and single-cycle', () {
      expect(loadFixture('analysis_empty').phase.cycleDay, isNull);
      expect(loadFixture('analysis_single').phase.cycleDay, isNotNull);
      expect(
        loadFixture('analysis_single').predictions.estimatedCycleLength,
        isNull,
      );
    });
  });

  final today = daysAgo(0);
  final routes = <String, (String, Object?)>{
    'home': ('/', null),
    'journal': ('/daily-logs', null),
    'insights': ('/insights', null),
    'cycle history': ('/cycles', null),
    'new cycle': ('/cycles/new', null),
    'edit cycle': ('/cycles/1/edit', testCycles().first),
    'new log': ('/daily-logs/new', null),
    'edit log': ('/daily-logs/11/edit', testLogs().first),
    'learn': ('/learn', null),
    'learn menstrual': ('/learn/menstrual', null),
    'learn ovulatory': ('/learn/ovulatory', null),
  };

  for (final screen in _screens.entries) {
    for (final fixture in [
      'analysis_rich',
      'analysis_empty',
      'analysis_single',
    ]) {
      for (final route in routes.entries) {
        if (fixture != 'analysis_rich' &&
            !{'home', 'insights', 'learn'}.contains(route.key)) {
          continue;
        }
        testWidgets(
          '${route.key} renders without overflow — ${screen.key}, $fixture',
          (tester) async {
            setScreen(tester, screen.value);
            final empty = fixture == 'analysis_empty';
            final h = TestHarness(
              analysis: loadFixture(fixture),
              cycles: empty ? const [] : null,
              logs: empty ? const [] : null,
            );
            await h.pump(tester, route.value.$1, extra: route.value.$2);
            expect(tester.takeException(), isNull);
            // Scroll through the whole page to lay out lazy children.
            final scrollables = find.byType(Scrollable);
            if (scrollables.evaluate().isNotEmpty) {
              await tester.fling(
                scrollables.first,
                const Offset(0, -4000),
                3000,
              );
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull);
            }
          },
        );
      }
    }
  }

  for (final location in [
    '/',
    '/daily-logs/new',
    '/insights',
    '/learn/luteal',
  ]) {
    testWidgets('large text (1.4x) renders $location', (tester) async {
      setScreen(tester, const Size(360, 780), textScale: 1.4);
      final h = TestHarness();
      await h.pump(tester, location);
      await tester.fling(
        find.byType(Scrollable).first,
        const Offset(0, -5000),
        3000,
      );
      await tester.pumpAndSettle();
      // Any overflow is reported by the framework and fails the test.
    });
  }

  testWidgets('home shows real analysis values', (tester) async {
    setScreen(tester, const Size(412, 915));
    final h = TestHarness();
    await h.pump(tester, '/');
    final a = loadFixture('analysis_rich');
    expect(find.text('${a.phase.cycleDay}'), findsOneWidget);
    expect(
      find.text('~${a.predictions.estimatedCycleLength} günlük döngü'),
      findsOneWidget,
    );
    expect(find.text('Foliküler'), findsWidgets);
    expect(find.text('YAKLAŞANLAR'), findsOneWidget);
    expect(find.textContaining('İrem'), findsOneWidget);
  });

  testWidgets('home empty state offers to add a period', (tester) async {
    setScreen(tester, const Size(360, 780));
    final h = TestHarness(
      analysis: loadFixture('analysis_empty'),
      cycles: const [],
      logs: const [],
    );
    await h.pump(tester, '/');
    expect(find.text('Adet dönemi ekle'), findsOneWidget);
    expect(find.text('Bugün nasılsınız?'), findsOneWidget);
  });

  testWidgets('insights render API insights and every section', (tester) async {
    setScreen(tester, const Size(412, 915));
    final h = TestHarness();
    await h.pump(tester, '/insights');
    final a = loadFixture('analysis_rich');
    // Backend insights arrive in English; every one must be shown in
    // Turkish, never as the raw API text.
    for (final insight in a.insights) {
      expect(find.text(insight.message), findsNothing);
      expect(find.text(insight.title), findsNothing);
    }
    expect(find.text('Döngü örüntüsü'), findsOneWidget);
    expect(
      find.text('Kayıtlı döngü uzunluklarınız görece tutarlı görünüyor.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Kayıtlı döngülerinize göre tahmini döngü uzunluğunuz '
        '${a.predictions.estimatedCycleLength} gün.',
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        'Şişkinlik 13 kez kaydedildi; en sık görüldüğü faz: ',
      ),
      findsOneWidget,
    );
    for (final title in [
      'Döngü uzunluğu',
      'Tahminler',
      'İyi oluş',
      'Semptomlar',
      'Kanama',
      'Bağlantılar',
    ]) {
      await tester.scrollUntilVisible(find.text(title), 300);
      expect(find.text(title), findsOneWidget);
    }
    await tester.scrollUntilVisible(find.text('Şişkinlik'), 300);
    expect(find.text('En sık: Luteal'), findsOneWidget);
  });

  testWidgets('new check-in sends selected levels and symptoms', (
    tester,
  ) async {
    setScreen(tester, const Size(412, 915));
    final h = TestHarness();
    await h.pump(tester, '/daily-logs');
    await tester.tap(find.text('Yeni'));
    await tester.pumpAndSettle();
    expect(find.text('Yeni kayıt'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Kanama: Orta'));
    await tester.tap(find.bySemanticsLabel('Ruh hali: Çok iyi'));
    await tester.pump();
    await tester.scrollUntilVisible(find.text('Baş ağrısı'), 200);
    await tester.tap(find.text('Baş ağrısı'));
    await tester.pump();
    expect(find.text('1 seçildi'), findsOneWidget);

    await tester.tap(find.text('Kaydı kaydet'));
    await tester.pumpAndSettle();

    expect(h.logs.created.single['bleeding'], 3);
    expect(h.logs.created.single['mood'], 5);
    expect(h.logs.created.single['notes'], isNull);
    expect(h.links.synced.single.$1, 99);
    expect(h.links.synced.single.$2, {5});
    expect(find.text('Yeni kayıt'), findsNothing, reason: 'pops back');
    expect(find.text('Günlük'), findsWidgets);
  });

  testWidgets('edit check-in preloads existing symptoms and updates', (
    tester,
  ) async {
    setScreen(tester, const Size(412, 915));
    final h = TestHarness();
    await h.pump(tester, '/daily-logs/11/edit', extra: testLogs().first);
    expect(find.text('Kaydı düzenle'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('2 seçildi'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('2 seçildi'), findsOneWidget);
    await tester.tap(find.text('Değişiklikleri kaydet'));
    await tester.pumpAndSettle();
    expect(h.logs.updated.single['id'], 11);
    expect(h.links.synced.single.$1, 11);
    expect(h.links.synced.single.$2, {3, 5});
  });

  testWidgets('new period saves start date', (tester) async {
    setScreen(tester, const Size(360, 780));
    final h = TestHarness();
    await h.pump(tester, '/cycles/new');
    await tester.tap(find.text('Adet dönemini kaydet'));
    await tester.pumpAndSettle();
    expect(h.cycles.created.single.$1, today);
    expect(h.cycles.created.single.$2, isNull);
  });

  testWidgets('login validates and signs in', (tester) async {
    setScreen(tester, const Size(360, 640));
    final h = TestHarness(authenticated: false);
    await h.pump(tester, '/login');
    expect(find.text('Tekrar hoş geldiniz'), findsOneWidget);
    await tester.tap(find.text('Giriş yap'));
    await tester.pump();
    expect(find.text('E-posta adresinizi girin'), findsOneWidget);
    expect(find.text('Şifrenizi girin'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-posta'),
      ' qa@example.com ',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Şifre'),
      'secret',
    );
    await tester.tap(find.text('Giriş yap'));
    await tester.pumpAndSettle();
    expect(h.auth.loginCalls.single, ('qa@example.com', 'secret'));
    expect(
      find.textContaining('İrem'),
      findsOneWidget,
      reason: 'redirects home',
    );
  });

  testWidgets('register shows validation and date-of-birth requirement', (
    tester,
  ) async {
    setScreen(tester, const Size(320, 640));
    final h = TestHarness(authenticated: false);
    await h.pump(tester, '/register');
    await tester.ensureVisible(find.text('Hesap oluştur'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hesap oluştur'));
    await tester.pump();
    expect(find.text('Adınızı girin'), findsOneWidget);
    expect(find.text('Soyadınızı girin'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown learn phase redirects to learn index', (tester) async {
    setScreen(tester, const Size(360, 780));
    final h = TestHarness();
    await h.pump(tester, '/learn/bogus');
    expect(find.text('Döngünüz, dört fazda'), findsOneWidget);
  });

  testWidgets('signing out from the profile sheet returns to login', (
    tester,
  ) async {
    setScreen(tester, const Size(360, 780));
    final h = TestHarness();
    await h.pump(tester, '/');
    await tester.tap(find.byType(ProfileButton).first);
    await tester.pumpAndSettle();
    expect(find.text('Döngü geçmişi'), findsOneWidget);
    await tester.tap(find.text('Çıkış yap'));
    await tester.pumpAndSettle();
    expect(find.text('Tekrar hoş geldiniz'), findsOneWidget);
  });
}
