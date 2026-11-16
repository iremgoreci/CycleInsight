// End-to-end smoke test of the app's data layer against a running backend.
//
// Skipped by default. Run with the API up:
//   flutter test test/live_api_test.dart --dart-define=LIVE_API=true \
//     --dart-define=API_BASE_URL=http://127.0.0.1:8000
//
// It registers throwaway QA accounts (qa-redesign-<timestamp>@example.com),
// then deletes every cycle/log it created. The user rows remain, because the
// API has no delete-user endpoint.
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/errors/api_exception.dart';
import 'package:frontend/data/api/api_client.dart';
import 'package:frontend/data/local/token_storage.dart';
import 'package:frontend/data/services/analysis_service.dart';
import 'package:frontend/data/services/auth_service.dart';
import 'package:frontend/data/services/cycle_service.dart';
import 'package:frontend/data/services/daily_log_service.dart';
import 'package:frontend/data/services/daily_log_symptom_service.dart';
import 'package:frontend/data/services/symptom_type_service.dart';

const _live = bool.fromEnvironment('LIVE_API');

class _MemoryTokens implements TokenStorage {
  String? token;

  @override
  Future<void> clear() async => token = null;

  @override
  Future<String?> readAccessToken() async => token;

  @override
  Future<void> saveAccessToken(String value) async => token = value;
}

class _Session {
  _Session() {
    client = ApiClient(tokenStorage: tokens);
    auth = AuthService(client);
    cycles = CycleService(client);
    logs = DailyLogService(client);
    links = DailyLogSymptomService(client);
    types = SymptomTypeService(client);
    analysis = AnalysisService(client);
  }

  final tokens = _MemoryTokens();
  late final ApiClient client;
  late final AuthService auth;
  late final CycleService cycles;
  late final DailyLogService logs;
  late final DailyLogSymptomService links;
  late final SymptomTypeService types;
  late final AnalysisService analysis;

  Future<void> signUp(String email) async {
    await auth.register(
      firstName: 'QA',
      lastName: 'Redesign',
      email: email,
      password: 'QaRedesign!2026',
      dateOfBirth: DateTime(1998, 5, 1),
    );
    tokens.token = await auth.login(email: email, password: 'QaRedesign!2026');
  }
}

void main() {
  test('auth, CRUD, symptoms, analysis and isolation', skip: !_live, () async {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final a = _Session();
    await a.signUp('qa-redesign-$stamp@example.com');

    final me = await a.auth.getCurrentUser();
    expect(me.email, 'qa-redesign-$stamp@example.com');

    // Wrong password is rejected with a readable message.
    await expectLater(
      a.auth.login(email: me.email, password: 'wrong'),
      throwsA(isA<ApiException>()),
    );

    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);
    final c1 = await a.cycles.createCycle(
      startDate: day.subtract(const Duration(days: 40)),
      endDate: day.subtract(const Duration(days: 36)),
    );
    final c2 = await a.cycles.createCycle(
      startDate: day.subtract(const Duration(days: 11)),
      endDate: day.subtract(const Duration(days: 7)),
    );
    expect(
      (await a.cycles.getCycles()).map((c) => c.id),
      containsAll([c1.id, c2.id]),
    );

    final log = await a.logs.createDailyLog(
      logDate: day,
      bleedingLevel: 0,
      moodLevel: 4,
      painLevel: 1,
      sleepQuality: 3,
      stressLevel: 2,
      notes: 'QA redesign smoke test',
    );
    final types = await a.types.getSymptomTypes();
    expect(types, isNotEmpty);
    final link = await a.links.addSymptom(
      dailyLogId: log.id,
      symptomTypeId: types.first.id,
    );

    await a.logs.updateDailyLog(
      dailyLogId: log.id,
      logDate: day,
      bleedingLevel: 0,
      moodLevel: 5,
      painLevel: 1,
      sleepQuality: 3,
      stressLevel: 2,
      notes: 'QA redesign smoke test (edited)',
    );
    final logs = await a.logs.getDailyLogs();
    expect(logs.single.moodLevel, 5);

    // Duplicate date is rejected (409), which the form maps to a message.
    await expectLater(
      a.logs.createDailyLog(
        logDate: day,
        bleedingLevel: 0,
        moodLevel: 3,
        painLevel: 0,
        sleepQuality: 3,
        stressLevel: 0,
      ),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 409)),
    );

    final analysis = await a.analysis.getAnalysis();
    expect(analysis.phase.cycleDay, 12);
    expect(analysis.cycle.cycleLengths, [29]);
    expect(analysis.predictions.estimatedCycleLength, 29);
    expect(analysis.phase.wellbeingByPhase, isNotEmpty);
    expect(analysis.symptoms[types.first.id]?.phaseDistribution, isNotEmpty);

    // A second account sees none of the first account's records.
    final b = _Session();
    await b.signUp('qa-redesign-$stamp-b@example.com');
    expect(await b.cycles.getCycles(), isEmpty);
    expect(await b.logs.getDailyLogs(), isEmpty);
    expect(await b.links.getDailyLogSymptoms(), isEmpty);
    expect((await b.analysis.getAnalysis()).phase.cycleDay, isNull);
    await expectLater(
      b.logs.deleteDailyLog(log.id),
      throwsA(isA<ApiException>()),
    );

    // Clean up everything account A created.
    await a.links.deleteSymptom(link.id);
    await a.logs.deleteDailyLog(log.id);
    await a.cycles.deleteCycle(c1.id);
    await a.cycles.deleteCycle(c2.id);
    expect(await a.cycles.getCycles(), isEmpty);
    expect(await a.logs.getDailyLogs(), isEmpty);
  });
}
