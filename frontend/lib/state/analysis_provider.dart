import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/analysis.dart';
import '../data/services/analysis_service.dart';
import 'auth_provider.dart';

final analysisProvider = AsyncNotifierProvider<AnalysisNotifier, Analysis>(
  AnalysisNotifier.new,
);

class AnalysisNotifier extends AsyncNotifier<Analysis> {
  @override
  Future<Analysis> build() {
    // Analysis is user-specific: rebuild when the signed-in user changes so
    // a previous account's results are never shown.
    ref.watch(authProvider.select((session) => session.user?.id));
    return ref.read(analysisServiceProvider).getAnalysis();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(analysisServiceProvider).getAnalysis(),
    );
  }
}
