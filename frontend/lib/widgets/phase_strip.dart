import 'package:flutter/material.dart';

import '../core/presentation/cycle_phase_style.dart';
import '../core/theme/app_theme.dart';
import '../l10n/l10n.dart';

/// Proportional horizontal strip of the four phases. Used by Learn to show
/// how the phases sit within an example cycle.
class PhaseStrip extends StatelessWidget {
  const PhaseStrip({
    super.key,
    required this.days,
    this.highlight,
    this.onTap,
    this.height = 12,
    this.showLabels = true,
  });

  final Map<CyclePhaseKind, int> days;
  final CyclePhaseKind? highlight;
  final ValueChanged<CyclePhaseKind>? onTap;
  final double height;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final phases = CyclePhaseKind.values.where((p) => (days[p] ?? 0) > 0);
    final labelStyle = Theme.of(context).textTheme.labelSmall;
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final phase in phases)
          Expanded(
            flex: days[phase]!,
            child: Semantics(
              button: onTap != null,
              label: phase.fullName(l10n),
              selected: phase == highlight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap == null ? null : () => onTap!(phase),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height + 6,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: phase == highlight ? height + 6 : height,
                            decoration: BoxDecoration(
                              color: highlight == null || phase == highlight
                                  ? phase.color
                                  : phase.color.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      if (showLabels) ...[
                        const SizedBox(height: 6),
                        ExcludeSemantics(
                          child: Text(
                            // Very short segments get an initial only.
                            days[phase]! < 4
                                ? phase.label(l10n)[0]
                                : phase.label(l10n),
                            style: labelStyle?.copyWith(
                              color: phase == highlight
                                  ? phase.ink
                                  : AppColors.textMuted,
                              fontWeight: phase == highlight
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
