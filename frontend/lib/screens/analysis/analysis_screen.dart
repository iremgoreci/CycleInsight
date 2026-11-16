import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/analysis.dart';
import '../../data/models/cycle.dart';
import '../../data/models/symptom_type.dart';
import '../../state/analysis_provider.dart';
import '../../state/cycle_provider.dart';
import '../../state/daily_log_provider.dart';
import '../../state/symptom_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/page_header.dart';
import 'widgets/cycle_sections.dart';
import 'widgets/insight_digest.dart';
import 'widgets/symptom_section.dart';
import 'widgets/wellbeing_sections.dart';
import '../../l10n/l10n.dart';

/// Insights — the personal report built from the `/analysis` response.
///
/// Structure: generated insights first (the "so what"), then numbered
/// sections moving from cycle timing to body and mind.
class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysis = ref.watch(analysisProvider);
    final symptomTypes = ref.watch(symptomTypesProvider);
    final cycles = ref.watch(cycleProvider).valueOrNull;
    final logCount = ref.watch(dailyLogProvider).valueOrNull?.length;

    final l10n = context.l10n;
    final subtitle = [
      if (cycles != null) l10n.insightsCycles(cycles.length),
      if (logCount != null) l10n.insightsLogs(logCount),
    ];
    final header = PageHeader(
      eyebrow: l10n.insightsEyebrow,
      title: l10n.insightsTitle,
      subtitle: subtitle.isEmpty
          ? null
          : l10n.insightsBasedOn(subtitle.join(l10n.insightsAnd)),
    );

    Future<void> refresh() => Future.wait([
      ref.read(analysisProvider.notifier).refresh(),
      ref.read(cycleProvider.notifier).refresh(),
      ref.read(dailyLogProvider.notifier).refresh(),
    ]);

    return RefreshIndicator(
      onRefresh: refresh,
      child: analysis.when(
        skipLoadingOnRefresh: true,
        loading: () => _Fill(
          header: header,
          child: AppLoadingState(label: l10n.insightsBuilding),
        ),
        error: (error, _) => _Fill(
          header: header,
          child: AppErrorState(
            error: error,
            title: l10n.insightsUnavailable,
            fallbackMessage: l10n.insightsLoadFailed,
            onRetry: () => ref.read(analysisProvider.notifier).refresh(),
          ),
        ),
        data: (data) => _Report(
          header: header,
          analysis: data,
          cycles: cycles,
          symptomTypes: symptomTypes,
        ),
      ),
    );
  }
}

class _Report extends StatelessWidget {
  const _Report({
    required this.header,
    required this.analysis,
    required this.cycles,
    required this.symptomTypes,
  });

  final Widget header;
  final Analysis analysis;
  final List<Cycle>? cycles;
  final AsyncValue<List<SymptomType>> symptomTypes;

  @override
  Widget build(BuildContext context) {
    var n = 0;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
      children: [
        header,
        InsightDigest(
          analysis: analysis,
          symptomNames: symptomTypes.whenOrNull(
            data: (types) => {for (final type in types) type.id: type.name},
          ),
        ),
        CycleLengthSection(number: ++n, cycle: analysis.cycle, cycles: cycles),
        PredictionSection(
          number: ++n,
          predictions: analysis.predictions,
          phase: analysis.phase,
        ),
        WellbeingSection(
          number: ++n,
          wellbeing: analysis.wellbeing,
          byPhase: analysis.phase.wellbeingByPhase,
        ),
        SymptomSection(
          number: ++n,
          symptoms: analysis.symptoms,
          symptomTypes: symptomTypes,
        ),
        BleedingSection(number: ++n, bleeding: analysis.bleeding),
        CorrelationSection(number: ++n, correlations: analysis.correlations),
        const _Disclaimer(),
      ],
    );
  }
}

class _Fill extends StatelessWidget {
  const _Fill({required this.header, required this.child});

  final Widget header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: header),
        SliverFillRemaining(hasScrollBody: false, child: child),
      ],
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.textMuted),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              context.l10n.insightsDisclaimer,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
