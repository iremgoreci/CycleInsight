import 'package:flutter/material.dart';

import '../core/presentation/error_messages.dart';
import '../core/presentation/formatters.dart';
import '../core/theme/app_theme.dart';
import '../l10n/l10n.dart';

/// Shared, deliberately quiet feedback states for data-driven screens.
class AppFeedbackState extends StatelessWidget {
  const AppFeedbackState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.tone = AppFeedbackTone.neutral,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final AppFeedbackTone tone;

  @override
  Widget build(BuildContext context) {
    final isError = tone == AppFeedbackTone.error;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isError ? AppColors.errorSoft : AppColors.primaryTint,
                  borderRadius: AppRadius.mdRadius,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isError ? AppColors.error : AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                message,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.lg),
                isError
                    ? OutlinedButton(
                        onPressed: onAction,
                        child: Text(actionLabel!),
                      )
                    : FilledButton(
                        onPressed: onAction,
                        child: Text(actionLabel!),
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

enum AppFeedbackTone { neutral, error }

/// Error state with a retry action. Shows the API's message when present.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.error,
    required this.onRetry,
    this.fallbackMessage,
    this.title,
    this.message,
  });

  final Object error;
  final VoidCallback onRetry;

  /// Shown when [error] carries no recognisable detail.
  final String? fallbackMessage;
  final String? title;

  /// Overrides the message derived from [error].
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppFeedbackState(
      icon: Icons.cloud_off_outlined,
      title: title ?? l10n.errorLoadTitle,
      message: message ?? ErrorText.of(l10n, error, fallback: fallbackMessage),
      actionLabel: l10n.commonTryAgain,
      onAction: onRetry,
      tone: AppFeedbackTone.error,
    );
  }
}

/// Centered loading indicator used while a screen's first data loads.
class AppLoadingState extends StatelessWidget {
  const AppLoadingState({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
          if (label != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(label!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

/// Inline message banner for form errors.
class InlineMessage extends StatelessWidget {
  const InlineMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.errorSoft,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, size: 18, color: AppColors.error),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small spinner sized for use inside a button.
class ButtonSpinner extends StatelessWidget {
  const ButtonSpinner({super.key, this.color = AppColors.onPrimary});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }
}

class AppSectionHeading extends StatelessWidget {
  const AppSectionHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Fmt.upper(title), style: AppTypography.eyebrow),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}
