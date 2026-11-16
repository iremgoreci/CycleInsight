import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/l10n.dart';

/// A numbered report section: "02  Cycle length", a hairline, then content.
/// Gives Insights the structure of a printed personal report rather than a
/// grid of identical cards.
class ReportSection extends StatelessWidget {
  const ReportSection({
    super.key,
    required this.number,
    required this.title,
    required this.child,
    this.caption,
  });

  final int number;
  final String title;
  final String? caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(color: AppColors.outline),
          const SizedBox(height: AppSpacing.md),
          Semantics(
            header: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  number.toString().padLeft(2, '0'),
                  style: AppTypography.figure.copyWith(
                    color: AppColors.lavender,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(title, style: textTheme.titleLarge)),
              ],
            ),
          ),
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Text(caption!, style: textTheme.bodySmall),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

/// White surface for charts and grouped figures.
class ReportPanel extends StatelessWidget {
  const ReportPanel({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.outline),
      ),
      child: child,
    );
  }
}

/// Large figure with label and optional unit/note.
class StatBlock extends StatelessWidget {
  const StatBlock({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.note,
  });

  final String label;

  /// Null renders an em dash with "Not enough data".
  final String? value;
  final String? unit;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasValue = value != null;
    final l10n = context.l10n;
    return Semantics(
      label: l10n.semanticValue(
        label,
        hasValue ? '$value ${unit ?? ''}' : l10n.commonNotEnoughData,
      ),
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelSmall, maxLines: 1),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value ?? '—',
                  style: AppTypography.statNumber.copyWith(
                    color: hasValue
                        ? AppColors.textPrimary
                        : AppColors.textFaint,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasValue && unit != null) ...[
                const SizedBox(width: 3),
                Text(unit!, style: textTheme.bodySmall),
              ],
            ],
          ),
          if (note != null || !hasValue) ...[
            const SizedBox(height: 2),
            Text(
              note ?? l10n.commonNotEnoughData,
              style: textTheme.labelSmall,
              maxLines: 2,
            ),
          ],
        ],
      ),
    );
  }
}

/// Lays out stat blocks in columns separated by hairlines; wraps into rows
/// of two on narrow screens.
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final perRow = constraints.maxWidth < 340 || children.length == 4
            ? 2
            : children.length.clamp(1, 3);
        final rows = <List<Widget>>[];
        for (var i = 0; i < children.length; i += perRow) {
          rows.add(children.sublist(i, (i + perRow).clamp(0, children.length)));
        }
        return Column(
          children: [
            for (var r = 0; r < rows.length; r++) ...[
              if (r > 0) const SizedBox(height: AppSpacing.lg),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < perRow; i++) ...[
                      if (i > 0)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          child: VerticalDivider(width: 1),
                        ),
                      Expanded(
                        child: i < rows[r].length
                            ? rows[r][i]
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Quiet placeholder when a section has nothing to show yet.
class NotEnoughData extends StatelessWidget {
  const NotEnoughData({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.hourglass_empty,
            size: 18,
            color: AppColors.textMuted,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
