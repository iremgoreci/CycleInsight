import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/api_exception.dart';
import '../../core/presentation/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cycle.dart';
import '../../state/cycle_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../core/presentation/error_messages.dart';
import '../../l10n/l10n.dart';

/// Timeline of recorded cycles, newest first. Each entry shows the period
/// dates and — for completed cycles — the days until the next recorded
/// start (the same start-to-start rule the analysis uses).
class CycleListScreen extends ConsumerWidget {
  const CycleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycles = ref.watch(cycleProvider);
    final l10n = context.l10n;

    return cycles.when(
      skipLoadingOnRefresh: true,
      loading: () => const AppLoadingState(),
      error: (error, _) => AppErrorState(
        error: error,
        title: l10n.cycleUnavailable,
        fallbackMessage: l10n.cycleLoadFailed,
        onRetry: () => ref.read(cycleProvider.notifier).refresh(),
      ),
      data: (items) => RefreshIndicator(
        onRefresh: () => ref.read(cycleProvider.notifier).refresh(),
        child: items.isEmpty
            ? CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppFeedbackState(
                      icon: Icons.calendar_month_outlined,
                      title: l10n.cycleEmptyTitle,
                      message: l10n.cycleEmptyBody,
                      actionLabel: l10n.cycleEmptyAction,
                      onAction: () => context.push('/cycles/new'),
                    ),
                  ),
                ],
              )
            : _Timeline(
                cycles: [...items]
                  ..sort((a, b) => b.startDate.compareTo(a.startDate)),
                onEdit: (cycle) =>
                    context.push('/cycles/${cycle.id}/edit', extra: cycle),
                onDelete: (cycle) => _confirmDelete(context, ref, cycle),
              ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Cycle cycle,
  ) async {
    final l10n = context.l10n;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.cycleDeleteTitle),
        content: Text(l10n.cycleDeleteBody(Fmt.date(cycle.startDate))),
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
      await ref.read(cycleProvider.notifier).deleteCycle(cycle.id);
    } on ApiException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ErrorText.of(l10n, error, fallback: l10n.cycleDeleteFailed),
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.cycleDeleteFailed)));
      }
    }
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.cycles,
    required this.onEdit,
    required this.onDelete,
  });

  /// Sorted newest first.
  final List<Cycle> cycles;
  final ValueChanged<Cycle> onEdit;
  final ValueChanged<Cycle> onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xxxl,
      ),
      itemCount: cycles.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacing.lg,
              right: AppSpacing.sm,
            ),
            child: Text(
              context.l10n.cycleRecordedIntro(cycles.length),
              style: textTheme.bodyMedium,
            ),
          );
        }
        final i = index - 1;
        final cycle = cycles[i];
        // Newer neighbour = the next cycle's start.
        final nextStart = i > 0 ? cycles[i - 1].startDate : null;
        return _TimelineEntry(
          cycle: cycle,
          cycleLength: nextStart?.difference(cycle.startDate).inDays,
          isLatest: i == 0,
          isLast: i == cycles.length - 1,
          onEdit: () => onEdit(cycle),
          onDelete: () => onDelete(cycle),
        );
      },
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.cycle,
    required this.cycleLength,
    required this.isLatest,
    required this.isLast,
    required this.onEdit,
    required this.onDelete,
  });

  final Cycle cycle;
  final int? cycleLength;
  final bool isLatest;
  final bool isLast;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final end = cycle.endDate;
    final periodDays = end?.difference(cycle.startDate).inDays;
    final range = end == null
        ? Fmt.date(cycle.startDate)
        : '${Fmt.shortDate(cycle.startDate)} – '
              '${end.year != DateTime.now().year ? Fmt.date(end) : Fmt.shortDate(end)}';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isLatest ? PhaseColors.menstrual : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: PhaseColors.menstrual, width: 2),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1.5, color: AppColors.outline),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: InkWell(
              onTap: onEdit,
              borderRadius: AppRadius.mdRadius,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.sm,
                  bottom: AppSpacing.lg,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isLatest)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                Fmt.upper(l10n.cycleLatest),
                                style: AppTypography.eyebrow.copyWith(
                                  color: PhaseColors.menstrualInk,
                                ),
                              ),
                            ),
                          Text(range, style: textTheme.titleMedium),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              _PeriodBar(days: periodDays),
                              const SizedBox(width: AppSpacing.xs),
                              Flexible(
                                child: Text(
                                  periodDays == null
                                      ? l10n.cyclePeriodEndMissing
                                      : l10n.cyclePeriodDays(periodDays + 1),
                                  style: textTheme.labelMedium,
                                ),
                              ),
                            ],
                          ),
                          if (cycleLength != null) ...[
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              l10n.cycleLengthDays(cycleLength!),
                              style: AppTypography.figure.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton<_CycleAction>(
                      tooltip: l10n.commonMore,
                      icon: const Icon(
                        Icons.more_vert,
                        size: 20,
                        color: AppColors.textMuted,
                      ),
                      onSelected: (action) {
                        switch (action) {
                          case _CycleAction.edit:
                            onEdit();
                            break;
                          case _CycleAction.delete:
                            onDelete();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: _CycleAction.edit,
                          child: Text(l10n.commonEdit),
                        ),
                        PopupMenuItem(
                          value: _CycleAction.delete,
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
            ),
          ),
        ],
      ),
    );
  }
}

/// Period length as a row of day ticks (up to 10), or a dashed hint when
/// the end date is unknown.
class _PeriodBar extends StatelessWidget {
  const _PeriodBar({required this.days});

  /// end − start in days (so +1 is the period length), or null.
  final int? days;

  @override
  Widget build(BuildContext context) {
    final count = days == null ? 0 : (days! + 1).clamp(1, 10);
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < (days == null ? 3 : count); i++) ...[
            if (i > 0) const SizedBox(width: 2),
            Container(
              width: 6,
              height: 10,
              decoration: BoxDecoration(
                color: days == null ? AppColors.outline : PhaseColors.menstrual,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _CycleAction { edit, delete }
