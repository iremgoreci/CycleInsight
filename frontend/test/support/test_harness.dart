import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/data/models/analysis.dart';
import 'package:frontend/data/models/cycle.dart';
import 'package:frontend/data/models/daily_log.dart';
import 'package:frontend/data/models/daily_log_symptom.dart';
import 'package:frontend/data/models/symptom_type.dart';
import 'package:frontend/data/models/user.dart';
import 'package:frontend/state/analysis_provider.dart';
import 'package:frontend/state/auth_provider.dart';
import 'package:frontend/state/auth_session.dart';
import 'package:frontend/state/cycle_provider.dart';
import 'package:frontend/state/daily_log_provider.dart';
import 'package:frontend/state/symptom_provider.dart';

// Fixtures are produced by the backend's own `analyzetestUser_data`
// (see test/fixtures/README.md), so these tests exercise real response
// shapes rather than hand-written JSON.
Analysis loadFixture(String name) => Analysis.fromJson(
  jsonDecode(File('test/fixtures/$name.json').readAsStringSync())
      as Map<String, dynamic>,
);

/// Key of the boundary wrapping the app, for screenshot capture.
const screenshotKey = ValueKey('app-boundary');

final testUser = User(
  id: 1,
  firstName: 'İrem',
  lastName: 'Test',
  email: 'qa@example.com',
  dateOfBirth: DateTime(2000, 1, 1),
);

const testSymptomTypes = [
  SymptomType(id: 1, name: 'Karın krampları'),
  SymptomType(id: 2, name: 'Göğüs hassasiyeti'),
  SymptomType(id: 3, name: 'Şişkinlik'),
  SymptomType(id: 5, name: 'Baş ağrısı'),
];

DateTime daysAgo(int days) =>
    DateUtils.dateOnly(DateTime.now()).subtract(Duration(days: days));

List<DailyLog> testLogs() => [
  DailyLog(
    id: 11,
    logDate: daysAgo(0),
    bleedingLevel: 0,
    moodLevel: 4,
    painLevel: 1,
    sleepQuality: 3,
    stressLevel: 2,
    notes: 'Long walk in the afternoon, felt good overall.',
    symptoms: [testSymptomTypes[2], testSymptomTypes[3]],
  ),
  DailyLog(
    id: 10,
    logDate: daysAgo(12),
    bleedingLevel: 4,
    moodLevel: 2,
    painLevel: 4,
    sleepQuality: 2,
    stressLevel: 3,
    symptoms: [testSymptomTypes[0]],
  ),
  DailyLog(
    id: 9,
    logDate: daysAgo(40),
    bleedingLevel: 0,
    moodLevel: 5,
    painLevel: 0,
    sleepQuality: 5,
    stressLevel: 0,
  ),
];

List<Cycle> testCycles() => [
  for (final (i, ago) in [12, 41, 69, 99].indexed)
    Cycle(
      id: i + 1,
      userId: 1,
      startDate: daysAgo(ago),
      endDate: i == 3 ? null : daysAgo(ago - 4),
    ),
];

class FakeAuth extends AuthNotifier {
  FakeAuth(this.initial);

  final AuthSession initial;
  final loginCalls = <(String, String)>[];

  @override
  AuthSession build() => initial;

  @override
  Future<void> login({required String email, required String password}) async {
    loginCalls.add((email, password));
    state = AuthSession.authenticated(testUser);
  }

  @override
  Future<void> logout() async {
    state = const AuthSession.unauthenticated();
  }
}

class FakeAnalysis extends AnalysisNotifier {
  FakeAnalysis(this.value);

  final Analysis value;

  @override
  Future<Analysis> build() async => value;

  @override
  Future<void> refresh() async => state = AsyncData(value);
}

class FakeCycles extends CycleNotifier {
  FakeCycles(this.value);

  final List<Cycle> value;
  final created = <(DateTime, DateTime?)>[];

  @override
  Future<List<Cycle>> build() async => value;

  @override
  Future<void> refresh() async => state = AsyncData(value);

  @override
  Future<void> createCycle({
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    created.add((startDate, endDate));
  }
}

class FakeLogs extends DailyLogNotifier {
  FakeLogs(this.value);

  final List<DailyLog> value;
  final created = <Map<String, Object?>>[];
  final updated = <Map<String, Object?>>[];

  @override
  Future<List<DailyLog>> build() async => value;

  @override
  Future<void> refresh() async => state = AsyncData(value);

  @override
  Future<DailyLog> createDailyLog({
    required DateTime logDate,
    required int bleedingLevel,
    required int moodLevel,
    required int painLevel,
    required int sleepQuality,
    required int stressLevel,
    String? notes,
  }) async {
    created.add({
      'bleeding': bleedingLevel,
      'mood': moodLevel,
      'pain': painLevel,
      'sleep': sleepQuality,
      'stress': stressLevel,
      'notes': notes,
    });
    return DailyLog(
      id: 99,
      logDate: logDate,
      bleedingLevel: bleedingLevel,
      moodLevel: moodLevel,
      painLevel: painLevel,
      sleepQuality: sleepQuality,
      stressLevel: stressLevel,
      notes: notes,
    );
  }

  @override
  Future<void> updateDailyLog({
    required int dailyLogId,
    required DateTime logDate,
    required int bleedingLevel,
    required int moodLevel,
    required int painLevel,
    required int sleepQuality,
    required int stressLevel,
    String? notes,
  }) async {
    updated.add({'id': dailyLogId, 'mood': moodLevel, 'notes': notes});
  }
}

class FakeLinks extends DailyLogSymptomsNotifier {
  final synced = <(int, Set<int>)>[];

  @override
  Future<List<DailyLogSymptom>> build() async => const [
    DailyLogSymptom(id: 1, dailyLogId: 11, symptomTypeId: 3),
    DailyLogSymptom(id: 2, dailyLogId: 11, symptomTypeId: 5),
  ];

  @override
  Future<void> syncForDailyLog({
    required int dailyLogId,
    required Set<int> selectedSymptomTypeIds,
  }) async {
    synced.add((dailyLogId, {...selectedSymptomTypeIds}));
  }
}

class TestHarness {
  TestHarness({
    Analysis? analysis,
    List<Cycle>? cycles,
    List<DailyLog>? logs,
    bool authenticated = true,
  }) : auth = FakeAuth(
         authenticated
             ? AuthSession.authenticated(testUser)
             : const AuthSession.unauthenticated(),
       ),
       cycles = FakeCycles(cycles ?? testCycles()),
       logs = FakeLogs(logs ?? testLogs()),
       analysis = FakeAnalysis(analysis ?? loadFixture('analysis_rich'));

  final FakeAuth auth;
  final FakeCycles cycles;
  final FakeLogs logs;
  final FakeAnalysis analysis;
  final links = FakeLinks();

  late final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith(() => auth),
      analysisProvider.overrideWith(() => analysis),
      cycleProvider.overrideWith(() => cycles),
      dailyLogProvider.overrideWith(() => logs),
      dailyLogSymptomsProvider.overrideWith(() => links),
      symptomTypesProvider.overrideWith((ref) async => testSymptomTypes),
    ],
  );

  Future<void> pump(
    WidgetTester tester,
    String location, {
    Object? extra,
  }) async {
    await tester.pumpWidget(
      RepaintBoundary(
        key: screenshotKey,
        child: UncontrolledProviderScope(
          container: container,
          child: const CycleInsightApp(),
        ),
      ),
    );
    await tester.pump();
    container.read(goRouterProvider).go(location, extra: extra);
    await tester.pumpAndSettle();
  }
}

void setScreen(WidgetTester tester, Size logical, {double textScale = 1}) {
  tester.view.physicalSize = logical * 3;
  tester.view.devicePixelRatio = 3;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}
