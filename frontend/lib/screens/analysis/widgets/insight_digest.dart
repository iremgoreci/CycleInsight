import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/analysis.dart';
import '../analysis_labels.dart';
import '../../../core/presentation/formatters.dart';
import '../../../l10n/l10n.dart';

/// The backend's generated insights, presented as an editorial digest —
/// the "voice" of the report. Text is localized by [InsightText], which
/// rebuilds each known insight from the same analysis values.
class InsightDigest extends StatelessWidget {
  const InsightDigest({
    super.key,
    required this.analysis,
    required this.symptomNames,
  });

  final Analysis analysis;

  /// Symptom names by id, or null while they are loading.
  final Map<int, String>? symptomNames;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final insights = analysis.insights;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.lavenderTint,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: AppColors.lavenderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Fmt.upper(l10n.digestTitle),
              style: AppTypography.eyebrow.copyWith(
                color: AppColors.lavenderDeep,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (insights.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(l10n.digestEmpty, style: textTheme.bodyMedium),
              )
            else
              for (var i = 0; i < insights.length; i++) ...[
                if (i > 0)
                  const Divider(color: AppColors.lavenderSoft, height: 1),
                _InsightRow(
                  insight: insights[i],
                  text: InsightText.of(
                    l10n,
                    insights[i],
                    analysis,
                    symptomNames: symptomNames,
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.insight, required this.text});

  final Insight insight;
  final ({String title, String message}) text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isNotable =
        insight.priority == 'medium' || insight.priority == 'high';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isNotable ? AppColors.lavender : AppColors.surface,
              borderRadius: AppRadius.smRadius,
            ),
            child: Icon(
              AnalysisLabels.insightIcon(insight.type),
              size: 17,
              color: isNotable ? AppColors.onPrimary : AppColors.lavenderDeep,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text.title, style: textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  text.message,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
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
