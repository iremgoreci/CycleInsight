import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/presentation/cycle_phase_style.dart';
import '../../core/presentation/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/l10n.dart';
import '../../state/analysis_provider.dart';
import '../../widgets/phase_strip.dart';
import '../../widgets/profile_button.dart';
import 'learn_content.dart';

/// Learn: an editorial table of contents for the four cycle phases.
class LearnAboutCycleScreen extends ConsumerWidget {
  const LearnAboutCycleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPhase = CyclePhaseKind.fromApi(
      ref.watch(analysisProvider).valueOrNull?.phase.currentPhase,
    );
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final content = LearnContent.of(Localizations.localeOf(context));

    void openPhase(CyclePhaseKind phase) =>
        context.push('/learn/${phase.apiValue}');

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
            Text(Fmt.upper(l10n.learnEyebrow), style: AppTypography.eyebrow),
            const SizedBox(height: AppSpacing.xs),
            Semantics(
              header: true,
              child: Text(l10n.learnTitle, style: textTheme.headlineMedium),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(content.intro, style: AppTypography.reading),
            const SizedBox(height: AppSpacing.sm),
            Text(content.variability, style: AppTypography.reading),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.lgRadius,
                border: Border.all(color: AppColors.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.learnExampleCycle,
                          style: textTheme.titleSmall,
                        ),
                      ),
                      if (currentPhase != null)
                        _NowTag(
                          phase: currentPhase,
                          text: l10n.learnYouAre(currentPhase.label(l10n)),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PhaseStrip(
                    days: LearnContent.exampleDays,
                    highlight: currentPhase,
                    onTap: openPhase,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _DayScale(),
                  const SizedBox(height: AppSpacing.xs),
                  Text(l10n.learnTapHint, style: textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            for (final chapter in content.chapters) ...[
              _ChapterRow(
                chapter: chapter,
                isCurrent: chapter.phase == currentPhase,
                onTap: () => openPhase(chapter.phase),
              ),
              const Divider(),
            ],
            const SizedBox(height: AppSpacing.xl),
            _Note(icon: Icons.info_outline, text: content.estimateNote),
            const SizedBox(height: AppSpacing.sm),
            _Note(
              icon: Icons.health_and_safety_outlined,
              text: content.disclaimer,
            ),
            const SizedBox(height: AppSpacing.xl),
            const LearnSources(),
          ],
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}

/// The sources the Learn content was checked against. URLs are selectable
/// so they can be copied (the app has no link-opening dependency).
class LearnSources extends StatelessWidget {
  const LearnSources({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Fmt.upper(context.l10n.learnSources),
          style: AppTypography.eyebrow,
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final source in LearnContent.sources)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${source.title}\n',
                    style: textTheme.labelMedium,
                  ),
                  TextSpan(text: source.url, style: textTheme.bodySmall),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DayScale extends StatelessWidget {
  const _DayScale();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Row(
        children: [
          Text(context.l10n.learnDayOne, style: AppTypography.figure),
          const Spacer(),
          Text('~14', style: AppTypography.figure),
          const Spacer(),
          Text('28', style: AppTypography.figure),
        ],
      ),
    );
  }
}

class _ChapterRow extends StatelessWidget {
  const _ChapterRow({
    required this.chapter,
    required this.isCurrent,
    required this.onTap,
  });

  final PhaseChapter chapter;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final phase = chapter.phase;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 44,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phase.number.toString().padLeft(2, '0'),
                    style: AppTypography.statNumber.copyWith(
                      color: phase.ink,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(width: 18, height: 3, color: phase.color),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xxs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(phase.fullName(l10n), style: textTheme.titleMedium),
                      if (isCurrent) _NowTag(phase: phase, text: l10n.learnNow),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(chapter.timing, style: textTheme.labelMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(chapter.summary, style: textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(
                Icons.arrow_forward,
                size: 18,
                color: AppColors.textFaint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NowTag extends StatelessWidget {
  const _NowTag({required this.phase, required this.text});

  final CyclePhaseKind phase;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: phase.soft,
        borderRadius: AppRadius.xsRadius,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: phase.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
