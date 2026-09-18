import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/errors/api_exception.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/analysis.dart';
import '../../data/models/daily_log.dart';
import '../../state/analysis_provider.dart';
import '../../state/auth_provider.dart';
import '../../state/daily_log_provider.dart';
import '../../widgets/profile_button.dart';
import '../daily_logs/daily_log_form_screen.dart';

/// Home / Cycle Overview — the app's landing screen.
///
/// Answers "where am I in my cycle right now?" first, then surfaces
/// upcoming predictions, today's log status, and an entry point to the
/// cycle education section. All data comes from the existing
/// [analysisProvider] and [dailyLogProvider] — nothing here is invented.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static final _dateFormat = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final analysis = ref.watch(analysisProvider);
    final dailyLogs = ref.watch(dailyLogProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Future.wait([
          ref.read(analysisProvider.notifier).refresh(),
          ref.read(dailyLogProvider.notifier).refresh(),
        ]),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.xxl,
          ),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_greeting()},',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        user?.firstName ?? '',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const ProfileButton(),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Take a moment for yourself today.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            analysis.when(
              loading: () => const _CycleSectionLoading(),
              error: (error, _) => _CycleSectionError(
                message: error is ApiException
                    ? error.message
                    : 'Unable to load your cycle overview.',
                onRetry: () => ref.read(analysisProvider.notifier).refresh(),
              ),
              data: (data) => _CycleOverview(analysis: data),
            ),
            const SizedBox(height: AppSpacing.lg),
            dailyLogs.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (logs) => _TodaysLogCard(logs: logs),
            ),
            const SizedBox(height: AppSpacing.sm),
            _LearnEntryCard(onTap: () => context.push('/learn')),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }
    if (hour < 18) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }
}

class _CycleOverview extends StatelessWidget {
  const _CycleOverview({required this.analysis});

  final Analysis analysis;

  @override
  Widget build(BuildContext context) {
    final phase = analysis.phase;
    final predictions = analysis.predictions;
    final hasCycleData =
        phase.cycleDay != null && phase.currentPhase != null;
    final fraction = (phase.cycleDay != null &&
            predictions.estimatedCycleLength != null &&
            predictions.estimatedCycleLength! > 0)
        ? (phase.cycleDay! / predictions.estimatedCycleLength!)
            .clamp(0.0, 1.0)
            .toDouble()
        : null;

    return Column(
      children: [
        Center(
          child: _CycleRing(
            fraction: fraction,
            cycleDay: phase.cycleDay,
            phaseLabel: _phaseLabel(phase.currentPhase),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          hasCycleData
              ? "You're in the ${_phaseLabel(phase.currentPhase)!.toLowerCase()} phase."
              : 'Add a cycle to see where you are today.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: _UpcomingChip(
                icon: Icons.calendar_month_outlined,
                label: 'Next period',
                value: _relativeLabel(predictions.nextPeriodDate),
                subtitle: predictions.nextPeriodDate == null
                    ? null
                    : '${HomeScreen._dateFormat.format(predictions.nextPeriodDate!)} (est.)',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _UpcomingChip(
                icon: Icons.eco_outlined,
                label: 'Ovulation',
                value: _relativeLabel(predictions.ovulationDate),
                subtitle: predictions.ovulationDate == null
                    ? null
                    : '${HomeScreen._dateFormat.format(predictions.ovulationDate!)} (est.)',
                caption: predictions.ovulationWindow == null
                    ? null
                    : 'Cycle days ${predictions.ovulationWindow!.startDay}'
                        '–${predictions.ovulationWindow!.endDay}',
              ),
            ),
          ],
        ),
      ],
    );
  }

  String? _phaseLabel(String? phase) {
    if (phase == null) {
      return null;
    }
    return switch (phase) {
      'menstrual' => 'Menstrual',
      'follicular' => 'Follicular',
      'ovulatory' => 'Ovulatory',
      'luteal' => 'Luteal',
      _ => phase,
    };
  }

  String _relativeLabel(DateTime? date) {
    if (date == null) {
      return 'Not enough data';
    }
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    final diff = target.difference(today).inDays;
    if (diff == 0) {
      return 'Today';
    }
    if (diff == 1) {
      return 'Tomorrow';
    }
    if (diff > 1) {
      return 'in $diff days';
    }
    return '${diff.abs()} days ago';
  }
}

class _CycleRing extends StatelessWidget {
  const _CycleRing({
    required this.fraction,
    required this.cycleDay,
    required this.phaseLabel,
  });

  final double? fraction;
  final int? cycleDay;
  final String? phaseLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 9,
              strokeCap: StrokeCap.round,
              color: AppColors.blush,
              backgroundColor: AppColors.blush,
            ),
          ),
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: fraction ?? 0,
              strokeWidth: 9,
              strokeCap: StrokeCap.round,
              color: AppColors.primary,
              backgroundColor: Colors.transparent,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Cycle Day', style: AppTypography.eyebrow),
              const SizedBox(height: 2),
              Text(
                cycleDay?.toString() ?? '–',
                style: AppTypography.heroNumber,
              ),
              const SizedBox(height: 4),
              Text(
                phaseLabel ?? 'Not enough data yet',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpcomingChip extends StatelessWidget {
  const _UpcomingChip({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.caption,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.blush,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primaryDark),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
          if (caption != null) ...[
            const SizedBox(height: 2),
            Text(caption!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _TodaysLogCard extends StatelessWidget {
  const _TodaysLogCard({required this.logs});

  final List<DailyLog> logs;

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    DailyLog? todaysLog;
    for (final log in logs) {
      if (DateUtils.dateOnly(log.logDate) == today) {
        todaysLog = log;
        break;
      }
    }
    final isRecorded = todaysLog != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.surfaceAlt,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit_note_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's log",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    isRecorded ? 'Recorded' : 'Not recorded yet',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => DailyLogFormScreen(dailyLog: todaysLog),
                ),
              ),
              child: Text(isRecorded ? 'Edit' : 'Add log'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LearnEntryCard extends StatelessWidget {
  const _LearnEntryCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: AppRadius.lgRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceAlt,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learn about your cycle',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Explore the 4 phases',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _CycleSectionLoading extends StatelessWidget {
  const _CycleSectionLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 220,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _CycleSectionError extends StatelessWidget {
  const _CycleSectionError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 40, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.sm),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
