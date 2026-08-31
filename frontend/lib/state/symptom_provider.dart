import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/daily_log_symptom.dart';
import '../data/models/symptom_type.dart';
import '../data/services/daily_log_symptom_service.dart';
import '../data/services/symptom_type_service.dart';

final symptomTypesProvider = FutureProvider<List<SymptomType>>((ref) {
  return ref.read(symptomTypeServiceProvider).getSymptomTypes();
});

final dailyLogSymptomsProvider =
    AsyncNotifierProvider<DailyLogSymptomsNotifier, List<DailyLogSymptom>>(
      DailyLogSymptomsNotifier.new,
    );

class DailyLogSymptomsNotifier extends AsyncNotifier<List<DailyLogSymptom>> {
  @override
  Future<List<DailyLogSymptom>> build() {
    return ref.read(dailyLogSymptomServiceProvider).getDailyLogSymptoms();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(dailyLogSymptomServiceProvider).getDailyLogSymptoms(),
    );
  }

  Future<void> syncForDailyLog({
    required int dailyLogId,
    required Set<int> selectedSymptomTypeIds,
  }) async {
    final relationships =
        state.valueOrNull ??
        await ref.read(dailyLogSymptomServiceProvider).getDailyLogSymptoms();
    final existing = relationships
        .where((relationship) => relationship.dailyLogId == dailyLogId)
        .toList();
    final existingTypeIds = existing
        .map((relationship) => relationship.symptomTypeId)
        .toSet();
    final typesToAdd = selectedSymptomTypeIds.difference(existingTypeIds);
    final relationshipsToDelete = existing
        .where(
          (relationship) =>
              !selectedSymptomTypeIds.contains(relationship.symptomTypeId),
        )
        .toList();

    try {
      for (final symptomTypeId in typesToAdd) {
        await ref
            .read(dailyLogSymptomServiceProvider)
            .addSymptom(dailyLogId: dailyLogId, symptomTypeId: symptomTypeId);
      }
      for (final relationship in relationshipsToDelete) {
        await ref
            .read(dailyLogSymptomServiceProvider)
            .deleteSymptom(relationship.id);
      }
    } finally {
      await refresh();
    }
  }
}
