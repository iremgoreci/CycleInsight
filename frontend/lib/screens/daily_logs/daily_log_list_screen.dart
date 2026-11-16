import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/presentation/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/daily_log.dart';
import '../../state/daily_log_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/level_scale.dart';
import '../../widgets/page_header.dart';
import 'daily_log_labels.dart';
import '../../core/presentation/error_messages.dart';
import '../../l10n/l10n.dart';
import '../../core/errors/api_exception.dart';

/// Journal — every recorded check-in, grouped by month.
class DailyLogListScreen extends ConsumerWidget {
  const DailyLogListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(dailyLogProvider);
    final count = logs.valueOrNull?.length;
    final l10n = context.l10n;

    final header = PageHeader(
      eyebrow: l10n.journalEyebrow,
      title: l10n.journalTitle,
      subtitle: count == null || count == 0 ? null : l10n.journalCount(count),
      actions: [
        FilledButton.icon(
          onPressed: () => context.push('/daily-logs/new'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 38),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: Text(l10n.journalNew),
        ),
      ],
    );

    return RefreshIndicator(
      onRefresh: () => ref.read(dailyLogProvider.notifier).refresh(),
      child: logs.when(
        skipLoadingOnRefresh: true,
        loading: () =>
            _FillRemaining(header: header, child: const AppLoadingState()),
        error: (error, _) => _FillRemaining(
          header: header,
          child: AppErrorState(
            error: error,
            title: l10n.journalUnavailable,
            fallbackMessage: l10n.logLoadFailed,
            onRetry: () => ref.read(dailyLogProvider.notifier).refresh(),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return _FillRemaining(
              header: header,
              child: AppFeedbackState(
                icon: Icons.edit_note_outlined,
                title: l10n.journalEmptyTitle,
                message: l10n.journalEmptyBody,
                actionLabel: l10n.journalEmptyAction,
                onAction: () => context.push('/daily-logs/new'),
              ),
            );
          }

          final groups = _groupByMonth(items);
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
            children: [
              header,
              for (final group in groups) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.xs,
                    AppSpacing.gutter,
                    AppSpacing.sm,
                  ),
                  child: AppSectionHeading(
                    title: Fmt.monthYear(group.month),
                    action: Text(
                      l10n.journalCount(group.logs.length),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.gutter,
                  ),
                  child: Material(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.lgRadius,
                      side: const BorderSide(color: AppColors.outline),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (var i = 0; i < group.logs.length; i++) ...[
                          if (i > 0) const Divider(indent: 76),
                          _JournalEntry(
                            log: group.logs[i],
                            onEdit: () => context.push(
                              '/daily-logs/${group.logs[i].id}/edit',
                              extra: group.logs[i],
                            ),
                            onDelete: () =>
                                _confirmDelete(context, ref, group.logs[i]),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ],
          );
        },
      ),
    );
  }

  static List<_MonthGroup> _groupByMonth(List<DailyLog> logs) {
    final groups = <_MonthGroup>[];
    for (final log in logs) {
      final month = DateTime(log.logDate.year, log.logDate.month);
      if (groups.isEmpty || groups.last.month != month) {
        groups.add(_MonthGroup(month, []));
      }
      groups.last.logs.add(log);
    }
    return groups;
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    DailyLog log,
  ) async {
    final l10n = context.l10n;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.journalDeleteTitle),
        content: Text(l10n.journalDeleteBody(Fmt.date(log.logDate))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(0, 44),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(dailyLogProvider.notifier).deleteDailyLog(log.id);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.journalDeleted)));
      }
    } on ApiException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ErrorText.of(l10n, error, fallback: l10n.logDeleteFailed),
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.logDeleteFailed)));
      }
    }
  }
}

class _MonthGroup {
  _MonthGroup(this.month, this.logs);

  final DateTime month;
  final List<DailyLog> logs;
}

/// Header plus a centered child filling the rest of the viewport, still
/// scrollable so pull-to-refresh works.
class _FillRemaining extends StatelessWidget {
  const _FillRemaining({required this.header, required this.child});

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

class _JournalEntry extends StatelessWidget {
  const _JournalEntry({
    required this.log,
    required this.onEdit,
    required this.onDelete,
  });

  final DailyLog log;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasBleeding = log.bleedingLevel > 0;
    final notes = log.notes?.trim();
    final isToday = Fmt.isToday(log.logDate);
    final l10n = context.l10n;
    final labels = DailyLogLabels(l10n);

    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.xxs,
          AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 44,
              child: Column(
                children: [
                  Text(
                    Fmt.upper(
                      isToday ? l10n.commonToday : Fmt.weekday(log.logDate),
                    ),
                    style: AppTypography.eyebrow.copyWith(
                      fontSize: 10,
                      letterSpacing: 0.8,
                      color: isToday ? AppColors.primary : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${log.logDate.day}',
                    style: AppTypography.statNumber.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Semantics(
                    label: hasBleeding
                        ? l10n.semanticValue(
                            l10n.metricBleeding,
                            labels.bleeding[log.bleedingLevel] ?? '',
                          )
                        : null,
                    child: Container(
                      width: 20,
                      height: 4,
                      decoration: BoxDecoration(
                        color: hasBleeding
                            ? MetricColors.bleeding.withValues(
                                alpha: 0.35 + 0.13 * log.bleedingLevel,
                              )
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _MiniMeasure(
                        label: l10n.metricMood,
                        value: log.moodLevel,
                        text: labels.mood[log.moodLevel],
                        color: MetricColors.mood,
                      ),
                      _MiniMeasure(
                        label: l10n.metricPain,
                        value: log.painLevel,
                        text: labels.pain[log.painLevel],
                        color: MetricColors.pain,
                      ),
                      _MiniMeasure(
                        label: l10n.metricSleep,
                        value: log.sleepQuality,
                        text: labels.sleep[log.sleepQuality],
                        color: MetricColors.sleep,
                      ),
                      _MiniMeasure(
                        label: l10n.metricStress,
                        value: log.stressLevel,
                        text: labels.stress[log.stressLevel],
                        color: MetricColors.stress,
                      ),
                    ],
                  ),
                  if (hasBleeding) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.journalBleeding(
                        labels.bleeding[log.bleedingLevel] ?? '',
                      ),
                      style: textTheme.labelSmall?.copyWith(
                        color: PhaseColors.menstrualInk,
                      ),
                    ),
                  ],
                  if (log.symptoms.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      log.symptoms.map((symptom) => symptom.name).join(' · '),
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (notes != null && notes.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '“$notes”',
                      style: textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            PopupMenuButton<_DailyLogAction>(
              tooltip: l10n.commonMore,
              icon: const Icon(
                Icons.more_vert,
                size: 20,
                color: AppColors.textMuted,
              ),
              onSelected: (action) {
                switch (action) {
                  case _DailyLogAction.edit:
                    onEdit();
                    break;
                  case _DailyLogAction.delete:
                    onDelete();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _DailyLogAction.edit,
                  child: Text(l10n.commonEdit),
                ),
                PopupMenuItem(
                  value: _DailyLogAction.delete,
                  child: Text(
                    l10n.commonDelete,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMeasure extends StatelessWidget {
  const _MiniMeasure({
    required this.label,
    required this.value,
    required this.text,
    required this.color,
  });

  final String label;
  final int value;
  final String? text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.semanticValue(label, text ?? '$value'),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(width: 5),
          LevelMeter(value: value, color: color, barWidth: 3.5, height: 12),
        ],
      ),
    );
  }
}

enum _DailyLogAction { edit, delete }
