import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'profile_button.dart';
import '../core/presentation/formatters.dart';

/// Top-of-page header for the primary tabs: an eyebrow line, a large title
/// and the profile entry point. Scrolls with content rather than pinning,
/// so each tab opens with its own typographic voice.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.subtitle,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final String? eyebrow;
  final String? subtitle;

  /// Replaces the eyebrow line (e.g. the brand wordmark on Today).
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.sm,
        AppSpacing.gutter,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child:
                      leading ??
                      (eyebrow == null
                          ? const SizedBox.shrink()
                          : Text(
                              Fmt.upper(eyebrow!),
                              style: AppTypography.eyebrow,
                              overflow: TextOverflow.ellipsis,
                            )),
                ),
                ...actions,
                const SizedBox(width: AppSpacing.xxs),
                const ProfileButton(),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            header: true,
            child: Text(title, style: textTheme.headlineMedium),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(subtitle!, style: textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
