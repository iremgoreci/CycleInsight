import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/daily_log.dart';
import '../data/models/symptom_type.dart';
import '../data/services/daily_log_service.dart';
import '../data/services/daily_log_symptom_service.dart';
import '../data/services/symptom_type_service.dart';

final dailyLogProvider =
    AsyncNotifierProvider<DailyLogNotifier, List<DailyLog>>(
      DailyLogNotifier.new,
    );

class DailyLogNotifier extends AsyncNotifier<List<DailyLog>> {
  @override
  Future<List<DailyLog>> build() {
    return _loadDailyLogs();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadDailyLogs);
  }

  Future<DailyLog> createDailyLog({
    required DateTime logDate,
    required int bleedingLevel,
    required int moodLevel,
    required int painLevel,
    required int sleepQuality,
    required int stressLevel,
    String? notes,
  }) async {
    final dailyLog = await ref
        .read(dailyLogServiceProvider)
        .createDailyLog(
          logDate: logDate,
          bleedingLevel: bleedingLevel,
          moodLevel: moodLevel,
          painLevel: painLevel,
          sleepQuality: sleepQuality,
          stressLevel: stressLevel,
          notes: notes,
        );
    await refresh();
    return dailyLog;
  }

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
    await ref
        .read(dailyLogServiceProvider)
        .updateDailyLog(
          dailyLogId: dailyLogId,
          logDate: logDate,
          bleedingLevel: bleedingLevel,
          moodLevel: moodLevel,
          painLevel: painLevel,
          sleepQuality: sleepQuality,
          stressLevel: stressLevel,
          notes: notes,
        );
    await refresh();
  }

  Future<void> deleteDailyLog(int dailyLogId) async {
    await ref.read(dailyLogServiceProvider).deleteDailyLog(dailyLogId);
    await refresh();
  }

  Future<List<DailyLog>> _loadDailyLogs() async {
    final dailyLogsFuture = ref.read(dailyLogServiceProvider).getDailyLogs();
    final relationshipsFuture = ref
        .read(dailyLogSymptomServiceProvider)
        .getDailyLogSymptoms();
    final symptomTypesFuture = ref
        .read(symptomTypeServiceProvider)
        .getSymptomTypes();
    await Future.wait([
      dailyLogsFuture,
      relationshipsFuture,
      symptomTypesFuture,
    ]);

    final dailyLogs = await dailyLogsFuture;
    final relationships = await relationshipsFuture;
    final symptomTypes = await symptomTypesFuture;
    final symptomTypesById = {
      for (final symptomType in symptomTypes) symptomType.id: symptomType,
    };

    return dailyLogs.map((dailyLog) {
      final symptoms = relationships
          .where((relationship) => relationship.dailyLogId == dailyLog.id)
          .map((relationship) => symptomTypesById[relationship.symptomTypeId])
          .whereType<SymptomType>()
          .toList();
      return dailyLog.copyWithSymptoms(symptoms);
    }).toList();
  }
}
