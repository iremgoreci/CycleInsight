import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/l10n.dart';

/// Recorded cycle lengths over time: one dot per cycle, joined by a thin
/// line, with a dashed median rule. Tap (or drag) to read any cycle.
///
/// A dot plot is used instead of bars because cycle lengths cluster far
/// from zero; a zero-based bar chart would hide the variation, and a
/// truncated one would exaggerate it.
class CycleLengthChart extends StatefulWidget {
  const CycleLengthChart({
    super.key,
    required this.lengths,
    required this.labels,
    this.median,
    this.height = 170,
  });

  final List<int> lengths;

  /// One label per length (e.g. the cycle's start date).
  final List<String> labels;
  final double? median;
  final double height;

  @override
  State<CycleLengthChart> createState() => _CycleLengthChartState();
}

class _CycleLengthChartState extends State<CycleLengthChart> {
  late int _selected = widget.lengths.length - 1;

  @override
  void didUpdateWidget(CycleLengthChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selected >= widget.lengths.length) {
      _selected = widget.lengths.length - 1;
    }
  }

  void _select(Offset position, double width) {
    final count = widget.lengths.length;
    if (count == 0) {
      return;
    }
    final layout = _ChartLayout(
      width: width,
      height: widget.height,
      count: count,
    );
    final index = layout.indexAt(position.dx);
    if (index != _selected) {
      setState(() => _selected = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lengths = widget.lengths;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    String labelAt(int i) => i < widget.labels.length
        ? widget.labels[i]
        : l10n.chartCycleNumber(i + 1, lengths.length);
    final selectedLabel = labelAt(_selected);
    final summary = [
      for (var i = 0; i < lengths.length; i++)
        l10n.chartDaysPoint(labelAt(i), lengths[i]),
    ].join('; ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${lengths[_selected]}',
              style: AppTypography.statNumber.copyWith(fontSize: 22),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(l10n.unitDays, style: textTheme.bodySmall),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  selectedLabel,
                  style: textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Semantics(
          label: l10n.chartSemantic(summary),
          excludeSemantics: true,
          child: LayoutBuilder(
            builder: (context, constraints) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => _select(d.localPosition, constraints.maxWidth),
              onHorizontalDragUpdate: (d) =>
                  _select(d.localPosition, constraints.maxWidth),
              child: CustomPaint(
                size: Size(constraints.maxWidth, widget.height),
                painter: _CycleLengthPainter(
                  lengths: lengths,
                  median: widget.median,
                  selected: _selected,
                  // Merge with the ambient style so the painter uses the
                  // platform font family.
                  axisStyle: DefaultTextStyle.of(context).style.merge(
                    AppTypography.figure.copyWith(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartLayout {
  _ChartLayout({
    required this.width,
    required this.height,
    required this.count,
  });

  final double width;
  final double height;
  final int count;

  static const left = 28.0;
  static const right = 12.0;
  static const top = 10.0;
  static const bottom = 10.0;

  double get plotWidth => width - left - right;

  double xFor(int index) => count == 1
      ? left + plotWidth / 2
      : left + plotWidth * index / (count - 1);

  int indexAt(double dx) {
    if (count == 1) {
      return 0;
    }
    final t = ((dx - left) / plotWidth).clamp(0.0, 1.0);
    return (t * (count - 1)).round();
  }
}

class _CycleLengthPainter extends CustomPainter {
  _CycleLengthPainter({
    required this.lengths,
    required this.median,
    required this.selected,
    required this.axisStyle,
  });

  final List<int> lengths;
  final double? median;
  final int selected;
  final TextStyle axisStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final layout = _ChartLayout(
      width: size.width,
      height: size.height,
      count: lengths.length,
    );
    final values = [...lengths.map((e) => e.toDouble()), ?median];
    var lo = values.reduce(math.min).floorToDouble() - 2;
    var hi = values.reduce(math.max).ceilToDouble() + 2;
    if (hi - lo < 6) {
      final mid = (hi + lo) / 2;
      lo = mid - 3;
      hi = mid + 3;
    }
    final plotTop = _ChartLayout.top;
    final plotBottom = size.height - _ChartLayout.bottom;
    double yFor(double v) =>
        plotBottom - (v - lo) / (hi - lo) * (plotBottom - plotTop);

    // Recessive grid: three rounded ticks.
    final grid = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (final tick in _ticks(lo, hi)) {
      final y = yFor(tick);
      canvas.drawLine(
        Offset(_ChartLayout.left, y),
        Offset(size.width - _ChartLayout.right, y),
        grid,
      );
      _text(canvas, tick.toStringAsFixed(0), Offset(0, y - 7), axisStyle);
    }

    // Median rule.
    if (median != null) {
      final y = yFor(median!);
      final dash = Paint()
        ..color = AppColors.lavender
        ..strokeWidth = 1.5;
      for (
        var x = _ChartLayout.left;
        x < size.width - _ChartLayout.right;
        x += 7
      ) {
        canvas.drawLine(Offset(x, y), Offset(x + 3.5, y), dash);
      }
    }

    // Selected guide.
    final sx = layout.xFor(selected);
    canvas.drawLine(
      Offset(sx, plotTop),
      Offset(sx, plotBottom),
      Paint()
        ..color = AppColors.outline
        ..strokeWidth = 1,
    );

    // Line + dots.
    final points = [
      for (var i = 0; i < lengths.length; i++)
        Offset(layout.xFor(i), yFor(lengths[i].toDouble())),
    ];
    if (points.length > 1) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final p in points.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeJoin = StrokeJoin.round
          ..color = AppColors.primary.withValues(alpha: 0.55),
      );
    }
    for (var i = 0; i < points.length; i++) {
      final isSelected = i == selected;
      canvas.drawCircle(
        points[i],
        isSelected ? 7 : 5,
        Paint()..color = AppColors.surface,
      );
      canvas.drawCircle(
        points[i],
        isSelected ? 5.5 : 3.8,
        Paint()..color = isSelected ? AppColors.primaryDark : AppColors.primary,
      );
    }
  }

  Iterable<double> _ticks(double lo, double hi) sync* {
    final step = ((hi - lo) / 3).ceilToDouble().clamp(1, 100);
    var t = (lo / step).ceil() * step;
    while (t <= hi) {
      yield t.toDouble();
      t += step;
    }
  }

  void _text(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_CycleLengthPainter old) =>
      old.selected != selected ||
      old.median != median ||
      old.lengths != lengths;
}
