import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/cycle.dart';
import '../data/services/cycle_service.dart';

final cycleProvider = AsyncNotifierProvider<CycleNotifier, List<Cycle>>(
  CycleNotifier.new,
);

class CycleNotifier extends AsyncNotifier<List<Cycle>> {
  @override
  Future<List<Cycle>> build() {
    return ref.read(cycleServiceProvider).getCycles();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(cycleServiceProvider).getCycles(),
    );
  }

  Future<void> createCycle({
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    await ref
        .read(cycleServiceProvider)
        .createCycle(startDate: startDate, endDate: endDate);
    await refresh();
  }

  Future<void> updateCycle({
    required int cycleId,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    await ref
        .read(cycleServiceProvider)
        .updateCycle(cycleId: cycleId, startDate: startDate, endDate: endDate);
    await refresh();
  }

  Future<void> deleteCycle(int cycleId) async {
    await ref.read(cycleServiceProvider).deleteCycle(cycleId);
    await refresh();
  }
}
