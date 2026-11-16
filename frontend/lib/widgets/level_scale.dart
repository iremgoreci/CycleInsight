import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';

/// Segmented level input used by the daily check-in.
///
/// Each step is a tappable segment showing its numeric value; steps below
/// the selection are tinted so the control also reads as a meter. The
/// current label is spelled out above the scale so color is never the only
/// signal.
class LevelScale extends StatelessWidget {
  const LevelScale({
    super.key,
    required this.title,
    required this.icon,
    required this.labels,
    required this.value,
    required this.color,
    required this.onChanged,
    this.enabled = true,
  });

  final String title;
  final IconData icon;

  /// Level value -> label, e.g. {0: 'None', 1: 'Light', ...}.
  final Map<int, String> labels;
  final int value;
  final Color color;
  final ValueChanged<int> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final keys = labels.keys.toList()..sort();
    final selectedIndex = keys.indexOf(value);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: Text(title, style: textTheme.titleSmall)),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                layoutBuilder: (current, previous) => Stack(
                  alignment: Alignment.centerRight,
                  children: [...previous, ?current],
                ),
                child: Text(
                  labels[value] ?? '$value',
                  key: ValueKey(value),
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            for (var i = 0; i < keys.length; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: _Segment(
                  value: keys[i],
                  semanticLabel: '$title: ${labels[keys[i]]}',
                  state: i == selectedIndex
                      ? _SegmentState.selected
                      : i < selectedIndex
                      ? _SegmentState.below
                      : _SegmentState.above,
                  color: color,
                  isFirst: i == 0,
                  isLast: i == keys.length - 1,
                  onTap: enabled
                      ? () {
                          if (keys[i] != value) {
                            HapticFeedback.selectionClick();
                            onChanged(keys[i]);
                          }
                        }
                      : null,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                labels[keys.first] ?? '',
                style: textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                labels[keys.last] ?? '',
                style: textTheme.labelSmall,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum _SegmentState { below, selected, above }

class _Segment extends StatelessWidget {
  const _Segment({
    required this.value,
    required this.semanticLabel,
    required this.state,
    required this.color,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  final int value;
  final String semanticLabel;
  final _SegmentState state;
  final Color color;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const outer = Radius.circular(AppRadius.md);
    const inner = Radius.circular(AppRadius.xs);
    final radius = BorderRadius.horizontal(
      left: isFirst ? outer : inner,
      right: isLast ? outer : inner,
    );

    final background = switch (state) {
      _SegmentState.selected => color,
      _SegmentState.below => color.withValues(alpha: 0.22),
      _SegmentState.above => AppColors.surface,
    };
    final foreground = switch (state) {
      _SegmentState.selected => AppColors.onPrimary,
      _SegmentState.below => AppColors.textPrimary,
      _SegmentState.above => AppColors.textMuted,
    };

    return Semantics(
      button: true,
      selected: state == _SegmentState.selected,
      enabled: onTap != null,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: background,
              borderRadius: radius,
              border: state == _SegmentState.above
                  ? Border.all(color: AppColors.outline)
                  : null,
            ),
            child: Text(
              '$value',
              style: AppTypography.figure.copyWith(
                fontSize: 14,
                color: foreground,
                fontWeight: state == _SegmentState.selected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact read-only meter: [max] small bars, filled up to [value].
class LevelMeter extends StatelessWidget {
  const LevelMeter({
    super.key,
    required this.value,
    required this.color,
    this.max = 5,
    this.barWidth = 4,
    this.height = 14,
  });

  final int value;
  final int max;
  final Color color;
  final double barWidth;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 1; i <= max; i++) ...[
            if (i > 1) const SizedBox(width: 2),
            Container(
              width: barWidth,
              height: height * (0.45 + 0.55 * i / max),
              decoration: BoxDecoration(
                color: i <= value ? color : AppColors.outline,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
