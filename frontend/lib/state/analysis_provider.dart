import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/analysis.dart';
import '../data/services/analysis_service.dart';

final analysisProvider = AsyncNotifierProvider<AnalysisNotifier, Analysis>(
  AnalysisNotifier.new,
);

class AnalysisNotifier extends AsyncNotifier<Analysis> {
  @override
  Future<Analysis> build() {
    return ref.read(analysisServiceProvider).getAnalysis();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(analysisServiceProvider).getAnalysis(),
    );
  }
}
