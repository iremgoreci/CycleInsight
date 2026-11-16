// Renders real-font screenshots of each screen for design review.
//
// Skipped by default. Run with:
//   flutter test test/screenshots_test.dart \
//     --dart-define=SCREENSHOT_DIR=<absolute output dir>
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/widgets/profile_button.dart';

import 'support/test_harness.dart';

const _outDir = String.fromEnvironment('SCREENSHOT_DIR');

Future<void> _loadFonts() async {
  final fonts =
      '${Platform.environment['FLUTTER_ROOT'] ?? r'C:\src\flutter'}'
      '/bin/cache/artifacts/material_fonts';
  final roboto = FontLoader('Roboto');
  for (final weight in ['light', 'regular', 'medium', 'bold', 'black']) {
    roboto.addFont(
      Future.value(
        ByteData.sublistView(
          File('$fonts/roboto-$weight.ttf').readAsBytesSync(),
        ),
      ),
    );
  }
  await roboto.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(
      Future.value(
        ByteData.sublistView(
          File('$fonts/materialicons-regular.otf').readAsBytesSync(),
        ),
      ),
    );
  await icons.load();
}

Future<void> _capture(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(screenshotKey),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    File('$_outDir/$name.png').writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}

void main() {
  setUpAll(_loadFonts);

  final shots = <String, (String, Object?, Size)>{
    'home': ('/', null, const Size(390, 1300)),
    'journal': ('/daily-logs', null, const Size(390, 1100)),
    'insights': ('/insights', null, const Size(390, 3900)),
    'log_form': ('/daily-logs/new', null, const Size(390, 1500)),
    'log_edit': ('/daily-logs/11/edit', testLogs().first, const Size(390, 844)),
    'cycles': ('/cycles', null, const Size(390, 844)),
    'cycle_form': ('/cycles/new', null, const Size(390, 844)),
    'learn': ('/learn', null, const Size(390, 1500)),
    'learn_luteal': ('/learn/luteal', null, const Size(390, 1700)),
  };

  for (final shot in shots.entries) {
    testWidgets('screenshot ${shot.key}', skip: _outDir.isEmpty, (
      tester,
    ) async {
      setScreen(tester, shot.value.$3);
      final h = TestHarness();
      await h.pump(tester, shot.value.$1, extra: shot.value.$2);
      await _capture(tester, shot.key);
    });
  }

  testWidgets('screenshot home_empty', skip: _outDir.isEmpty, (tester) async {
    setScreen(tester, const Size(390, 844));
    final h = TestHarness(
      analysis: loadFixture('analysis_empty'),
      cycles: const [],
      logs: const [],
    );
    await h.pump(tester, '/');
    await _capture(tester, 'home_empty');
  });

  testWidgets('screenshot home_viewport', skip: _outDir.isEmpty, (
    tester,
  ) async {
    setScreen(tester, const Size(390, 844));
    await TestHarness().pump(tester, '/');
    await _capture(tester, 'home_viewport');
  });

  for (final route in ['/login', '/register']) {
    testWidgets('screenshot $route', skip: _outDir.isEmpty, (tester) async {
      setScreen(tester, const Size(390, 844));
      await TestHarness(authenticated: false).pump(tester, route);
      await _capture(tester, route.substring(1));
    });
  }

  testWidgets('screenshot profile sheet', skip: _outDir.isEmpty, (
    tester,
  ) async {
    setScreen(tester, const Size(390, 844));
    await TestHarness().pump(tester, '/');
    await tester.tap(find.byType(ProfileButton).first);
    await tester.pumpAndSettle();
    await _capture(tester, 'profile_sheet');
  });
}
