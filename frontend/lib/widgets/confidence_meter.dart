import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../l10n/l10n.dart';

/// Three-step meter for the API's prediction confidence tier.
class ConfidenceMeter extends StatelessWidget {
  const ConfidenceMeter({super.key, required this.tier});

  final String tier;

  /// Localized name of an API confidence tier (`high`/`medium`/`low`).
  static String tierLabel(AppLocalizations l10n, String tier) => switch (tier) {
    'high' => l10n.confidenceHigh,
    'medium' => l10n.confidenceMedium,
    _ => l10n.confidenceLow,
  };

  @override
  Widget build(BuildContext context) {
    final level = switch (tier) {
      'high' => 3,
      'medium' => 2,
      _ => 1,
    };
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 3; i++) ...[
            if (i > 1) const SizedBox(width: 3),
            Container(
              width: 12,
              height: 6,
              decoration: BoxDecoration(
                color: i <= level ? AppColors.primary : AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
