import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/presentation/cycle_phase_style.dart';
import '../../core/presentation/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/analysis.dart';
import '../../data/models/cycle.dart';
import '../../data/models/daily_log.dart';
import '../../state/analysis_provider.dart';
import '../../state/auth_provider.dart';
import '../../state/cycle_provider.dart';
import '../../state/daily_log_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/brand_mark.dart';
import '../../widgets/confidence_meter.dart';
import '../../widgets/cycle_dial.dart';
import '../../widgets/level_scale.dart';
import '../../widgets/page_header.dart';
import '../daily_logs/daily_log_labels.dart';
import '../learn/learn_content.dart';
import '../../l10n/l10n.dart';

/// Today — the landing screen.
///
/// Answers "where am I in my cycle right now?" first, then what's coming
/// up, today's check-in, and reading for the current phase. All data comes
/// from the existing [analysisProvider], [dailyLogProvider] and
/// [cycleProvider].
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final analysis = ref.watch(analysisProvider);
    final dailyLogs = ref.watch(dailyLogProvider);
    final cycles = ref.watch(cycleProvider);
    final phase = CyclePhaseKind.fromApi(
      analysis.valueOrNull?.phase.currentPhase,
    );
    final l10n = context.l10n;

    return RefreshIndicator(
      onRefresh: () => Future.wait([
        ref.read(analysisProvider.notifier).refresh(),
        ref.read(dailyLogProvider.notifier).refresh(),
        ref.read(cycleProvider.notifier).refresh(),
      ]),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
        children: [
          PageHeader(
            leading: const Align(
              alignment: Alignment.centerLeft,
              child: BrandWordmark(markSize: 20, fontSize: 16),
            ),
            title: user == null
                ? _greeting(l10n)
                : l10n.greetingWithName(_greeting(l10n), user.firstName),
            subtitle: Fmt.weekdayDate(DateTime.now()),
          ),
          analysis.when(
            skipLoadingOnRefresh: true,
            loading: () => SizedBox(
              height: 340,
              child: AppLoadingState(label: l10n.homeReadingCycle),
            ),
            error: (error, _) => SizedBox(
              height: 340,
              child: AppErrorState(
                error: error,
                title: l10n.homeOverviewUnavailable,
                onRetry: () => ref.read(analysisProvider.notifier).refresh(),
              ),
            ),
            data: (data) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CycleHero(
                  analysis: data,
                  periodDays: _latestPeriodDays(cycles.valueOrNull),
                  cyclesLoaded: cycles.hasValue,
                ),
                if (data.predictions.nextPeriodDate != null ||
                    data.predictions.ovulationDate != null) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  _ComingUp(predictions: data.predictions),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          dailyLogs.when(
            skipLoadingOnRefresh: true,
            loading: () => const SizedBox(height: 120),
            error: (_, _) => _Gutter(
              child: _CompactError(
                message: l10n.homeCheckInLoadError,
                onRetry: () => ref.read(dailyLogProvider.notifier).refresh(),
              ),
            ),
            data: (logs) => _Gutter(child: _TodayCheckIn(logs: logs)),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _Gutter(child: _PhaseReading(phase: phase)),
        ],
      ),
    );
  }

  /// Length of the most recent recorded period, using the same rule as the
  /// backend (latest cycle by start date, end − start + 1).
  static int? _latestPeriodDays(List<Cycle>? cycles) {
    if (cycles == null || cycles.isEmpty) {
      return null;
    }
    final latest = cycles.reduce(
      (a, b) => a.startDate.isAfter(b.startDate) ? a : b,
    );
    final end = latest.endDate;
    if (end == null) {
      return null;
    }
    return end.difference(latest.startDate).inDays + 1;
  }

  static String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return l10n.greetingMorning;
    }
    if (hour < 18) {
      return l10n.greetingAfternoon;
    }
    return l10n.greetingEvening;
  }
}

class _Gutter extends StatelessWidget {
  const _Gutter({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
    child: child,
  );
}

class _CycleHero extends StatelessWidget {
  const _CycleHero({
    required this.analysis,
    required this.periodDays,
    required this.cyclesLoaded,
  });

  final Analysis analysis;
  final int? periodDays;
  final bool cyclesLoaded;

  @override
  Widget build(BuildContext context) {
    final phaseInfo = analysis.phase;
    final predictions = analysis.predictions;
    final cycleDay = phaseInfo.cycleDay;
    final length = predictions.estimatedCycleLength;
    final phase = CyclePhaseKind.fromApi(phaseInfo.currentPhase);
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    final dialData = CycleDialData(
      cycleDay: cycleDay,
      cycleLength: length,
      ovulationDay: predictions.ovulationDay,
      periodDays: periodDays,
      windowStartDay: predictions.ovulationWindow?.startDay,
      windowEndDay: predictions.ovulationWindow?.endDay,
    );
    final legendPhases = dialData.hasSegments
        ? CyclePhaseKind.values
              .where((p) => p != CyclePhaseKind.menstrual || periodDays != null)
              .toList()
        : const <CyclePhaseKind>[];

    final semantic = cycleDay == null
        ? l10n.homeDialNoCycle
        : [
            l10n.homeDialDay(cycleDay),
            if (length != null) l10n.homeDialOfAbout(length),
            if (phase != null) phase.fullName(l10n),
          ].join(', ');

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth - 40, 300.0);
        return Column(
          children: [
            CycleDial(
              data: dialData,
              size: size,
              semanticLabel: semantic,
              child: ExcludeSemantics(
                child: _DialCenter(
                  cycleDay: cycleDay,
                  length: length,
                  phase: phase,
                ),
              ),
            ),
            if (legendPhases.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              PhaseLegend(phases: legendPhases, highlight: phase),
            ],
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.gutter + 8,
              ),
              child: _HeroCaption(
                cycleDay: cycleDay,
                length: length,
                periodDays: periodDays,
                cyclesLoaded: cyclesLoaded,
                phase: phase,
                textTheme: textTheme,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DialCenter extends StatelessWidget {
  const _DialCenter({
    required this.cycleDay,
    required this.length,
    required this.phase,
  });

  final int? cycleDay;
  final int? length;
  final CyclePhaseKind? phase;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Fmt.upper(l10n.homeCycleDay), style: AppTypography.eyebrow),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            cycleDay?.toString() ?? '—',
            style: AppTypography.heroNumber.copyWith(
              color: cycleDay == null
                  ? AppColors.textFaint
                  : AppColors.textPrimary,
            ),
          ),
          if (length != null)
            Text(l10n.homeOfAboutDays(length!), style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.sm),
          if (phase != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: phase!.soft,
                borderRadius: AppRadius.smRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(phase!.icon, size: 14, color: phase!.ink),
                  const SizedBox(width: 6),
                  Text(
                    phase!.label(l10n),
                    style: textTheme.labelMedium?.copyWith(
                      color: phase!.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              cycleDay == null
                  ? l10n.homeNoCycleYet
                  : l10n.homePhaseNotEstimated,
              style: textTheme.labelMedium,
            ),
        ],
      ),
    );
  }
}

class _HeroCaption extends StatelessWidget {
  const _HeroCaption({
    required this.cycleDay,
    required this.length,
    required this.periodDays,
    required this.cyclesLoaded,
    required this.phase,
    required this.textTheme,
  });

  final int? cycleDay;
  final int? length;
  final int? periodDays;
  final bool cyclesLoaded;
  final CyclePhaseKind? phase;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (cycleDay == null) {
      return Column(
        children: [
          Text(
            l10n.homeAddFirstPeriodPrompt,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: () => context.push('/cycles/new'),
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.homeAddPeriod),
          ),
        ],
      );
    }

    String message;
    if (length == null) {
      message = l10n.homeNeedSecondPeriod;
    } else if (cycleDay! > length!) {
      message = l10n.homePastEstimate(cycleDay!, cycleDay! - length!);
    } else if (cyclesLoaded &&
        periodDays == null &&
        phase != CyclePhaseKind.menstrual) {
      message = l10n.homeAddEndDate;
    } else {
      return const SizedBox.shrink();
    }

    final showAction = length == null || cycleDay! > length!;
    return Column(
      children: [
        Text(message, style: textTheme.bodySmall, textAlign: TextAlign.center),
        if (showAction)
          TextButton(
            onPressed: () => context.push('/cycles/new'),
            child: Text(l10n.homeRecordPeriod),
          )
        else
          TextButton(
            onPressed: () => context.push('/cycles'),
            child: Text(l10n.homeOpenCycleHistory),
          ),
      ],
    );
  }
}

class _ComingUp extends StatelessWidget {
  const _ComingUp({required this.predictions});

  final CyclePredictions predictions;

  @override
  Widget build(BuildContext context) {
    final nextPeriod = predictions.nextPeriodDate;
    final ovulation = predictions.ovulationDate;
    final window = predictions.ovulationWindow;
    final confidence = predictions.confidence;
    final l10n = context.l10n;

    return _Gutter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionHeading(
            title: l10n.homeComingUp,
            subtitle: l10n.homeComingUpSubtitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Material(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.lgRadius,
              side: const BorderSide(color: AppColors.outline),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                if (nextPeriod != null)
                  _LedgerRow(
                    color: PhaseColors.menstrual,
                    label: l10n.homeNextPeriod,
                    value: Fmt.relativeDay(l10n, nextPeriod),
                    detail: Fmt.shortDate(nextPeriod),
                  ),
                if (nextPeriod != null && ovulation != null)
                  const Divider(indent: AppSpacing.md),
                if (ovulation != null)
                  _LedgerRow(
                    color: PhaseColors.ovulatory,
                    label: l10n.homeOvulation,
                    value: Fmt.relativeDay(l10n, ovulation),
                    detail: Fmt.shortDate(ovulation),
                    note: window == null
                        ? null
                        : l10n.homeOvulationWindow(
                            window.startDay,
                            window.endDay,
                          ),
                  ),
                const Divider(indent: AppSpacing.md),
                InkWell(
                  onTap: () => context.go('/insights'),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AppRadius.lg),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.sm,
                      AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        ConfidenceMeter(tier: confidence.tier),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.confidenceLabel(
                              ConfidenceMeter.tierLabel(l10n, confidence.tier),
                            ),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            l10n.homeSeeInsights,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: AppColors.primary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({
    required this.color,
    required this.label,
    required this.value,
    required this.detail,
    this.note,
  });

  final Color color;
  final String label;
  final String value;
  final String detail;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: note == null ? 40 : 58,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.labelMedium),
                const SizedBox(height: 2),
                Text(value, style: textTheme.titleLarge),
                if (note != null) ...[
                  const SizedBox(height: 2),
                  Text(note!, style: textTheme.bodySmall),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(context.l10n.commonEstimated, style: textTheme.labelSmall),
              const SizedBox(height: 2),
              Text(
                detail,
                style: AppTypography.figure.copyWith(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TodayCheckIn extends StatelessWidget {
  const _TodayCheckIn({required this.logs});

  final List<DailyLog> logs;

  @override
  Widget build(BuildContext context) {
    DailyLog? todaysLog;
    for (final log in logs) {
      if (Fmt.isToday(log.logDate)) {
        todaysLog = log;
        break;
      }
    }
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    if (todaysLog == null) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.primaryTint,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: AppColors.primarySoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Fmt.upper(l10n.homeTodayCheckIn),
              style: AppTypography.eyebrow,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.homeCheckInPrompt, style: textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xxs),
            Text(l10n.homeCheckInPromptBody, style: textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: () => context.push('/daily-logs/new'),
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.homeCheckInButton),
            ),
          ],
        ),
      );
    }

    final log = todaysLog;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionHeading(
          title: l10n.homeTodayCheckIn,
          subtitle: l10n.homeCheckInRecorded,
          action: TextButton.icon(
            onPressed: () =>
                context.push('/daily-logs/${log.id}/edit', extra: log),
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: Text(l10n.commonEdit),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        LogMetricsGrid(log: log),
        if (log.symptoms.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            log.symptoms.map((s) => s.name).join(' · '),
            style: textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

/// Five logged measures as label + meter + value, in a two-column grid.
class LogMetricsGrid extends StatelessWidget {
  const LogMetricsGrid({super.key, required this.log});

  final DailyLog log;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = DailyLogLabels(l10n);
    final items = [
      (
        l10n.metricBleeding,
        log.bleedingLevel,
        labels.bleeding,
        MetricColors.bleeding,
      ),
      (l10n.metricMood, log.moodLevel, labels.mood, MetricColors.mood),
      (l10n.metricPain, log.painLevel, labels.pain, MetricColors.pain),
      (l10n.metricSleep, log.sleepQuality, labels.sleep, MetricColors.sleep),
      (l10n.metricStress, log.stressLevel, labels.stress, MetricColors.stress),
    ];
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          for (final (label, value, levels, color) in items)
            Semantics(
              label: l10n.semanticValue(label, levels[value] ?? '$value'),
              excludeSemantics: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    SizedBox(
                      width: 72,
                      child: Text(label, style: textTheme.labelMedium),
                    ),
                    LevelMeter(value: value, color: color),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        levels[value] ?? '$value',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PhaseReading extends StatelessWidget {
  const _PhaseReading({required this.phase});

  final CyclePhaseKind? phase;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final chapter = phase == null
        ? null
        : LearnContent.of(Localizations.localeOf(context)).chapterFor(phase!);
    final accent = phase?.color ?? AppColors.lavender;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.mdRadius,
        onTap: () => context.push(
          phase == null ? '/learn' : '/learn/${phase!.apiValue}',
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 3,
                height: 72,
                margin: const EdgeInsets.only(top: 2),
                color: accent,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Fmt.upper(
                        chapter == null
                            ? l10n.learnEyebrow
                            : l10n.homeReadAboutPhase,
                      ),
                      style: AppTypography.eyebrow,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      chapter == null ? l10n.learnTitle : phase!.fullName(l10n),
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      chapter?.summary ?? l10n.homeLearnFallback,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Padding(
                padding: EdgeInsets.only(top: 18),
                child: Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: AppColors.textFaint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactError extends StatelessWidget {
  const _CompactError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.cloud_off_outlined, size: 18, color: AppColors.error),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ),
        TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
      ],
    );
  }
}
