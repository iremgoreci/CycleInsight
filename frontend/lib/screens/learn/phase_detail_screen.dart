import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/presentation/cycle_phase_style.dart';
import '../../core/presentation/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/l10n.dart';
import '../../widgets/brand_mark.dart';
import '../../widgets/phase_strip.dart';
import '../../widgets/profile_button.dart';
import 'learn_content.dart';

/// A single Learn chapter — long-form reading layout for one phase.
class PhaseDetailScreen extends StatelessWidget {
  const PhaseDetailScreen({super.key, required this.phase});

  final CyclePhaseKind phase;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final content = LearnContent.of(Localizations.localeOf(context));
    final chapter = content.chapterFor(phase);
    final textTheme = Theme.of(context).textTheme;
    final all = CyclePhaseKind.values;
    final previous = phase.index > 0 ? all[phase.index - 1] : null;
    final next = phase.index < all.length - 1 ? all[phase.index + 1] : null;

    final sections = [
      (l10n.learnWhatIsHappening, chapter.happening),
      (l10n.learnWhatYouMightNotice, chapter.notice),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: ProfileButton(),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            0,
            AppSpacing.gutter,
            AppSpacing.xxxl,
          ),
          children: [
            Row(
              children: [
                Icon(phase.icon, size: 18, color: phase.ink),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    Fmt.upper(l10n.learnPhaseOf(phase.number)),
                    style: AppTypography.eyebrow.copyWith(color: phase.ink),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              header: true,
              child: Text(phase.fullName(l10n), style: textTheme.displaySmall),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              chapter.summary,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PhaseStrip(
              days: LearnContent.exampleDays,
              highlight: phase,
              height: 8,
            ),
            const SizedBox(height: AppSpacing.lg),
            _TimingRow(chapter: chapter),
            const SizedBox(height: AppSpacing.xl),
            for (final (heading, body) in sections) ...[
              Text(heading, style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(body, style: AppTypography.reading),
              const SizedBox(height: AppSpacing.xl),
            ],
            _InAppNote(text: chapter.inCycleInsight),
            if (chapter.careNote != null) ...[
              const SizedBox(height: AppSpacing.md),
              _Note(
                icon: Icons.health_and_safety_outlined,
                text: chapter.careNote!,
                style: textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Expanded(
                  child: previous == null
                      ? const SizedBox.shrink()
                      : _ChapterNav(phase: previous, isNext: false),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: next == null
                      ? const SizedBox.shrink()
                      : _ChapterNav(phase: next, isNext: true),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _Note(icon: Icons.info_outline, text: content.estimateNote),
            const SizedBox(height: AppSpacing.sm),
            _Note(icon: Icons.info_outline, text: content.disclaimer),
          ],
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text, this.style});

  final IconData icon;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: style ?? Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _TimingRow extends StatelessWidget {
  const _TimingRow({required this.chapter});

  final PhaseChapter chapter;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: chapter.phase.color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Fmt.upper(context.l10n.learnWhen), style: AppTypography.eyebrow),
          const SizedBox(height: 4),
          Text(chapter.timing, style: textTheme.titleSmall),
          const SizedBox(height: 2),
          Text(chapter.timingDetail, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _InAppNote extends StatelessWidget {
  const _InAppNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.lavenderTint,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.lavenderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PhaseSpectrumMark(size: 16),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  Fmt.upper(context.l10n.learnInApp),
                  style: AppTypography.eyebrow.copyWith(
                    color: AppColors.lavenderDeep,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            text,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _ChapterNav extends StatelessWidget {
  const _ChapterNav({required this.phase, required this.isNext});

  final CyclePhaseKind phase;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mdRadius,
        side: const BorderSide(color: AppColors.outline),
      ),
      child: InkWell(
        borderRadius: AppRadius.mdRadius,
        onTap: () => context.pushReplacement('/learn/${phase.apiValue}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: isNext
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                isNext ? l10n.learnNext : l10n.learnPrevious,
                style: textTheme.labelSmall,
              ),
              const SizedBox(height: 2),
              Text(
                phase.label(l10n),
                style: textTheme.titleSmall?.copyWith(color: phase.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
