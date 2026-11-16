import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/brand_mark.dart';
import '../../l10n/l10n.dart';

/// Shared layout for sign-in and registration: brand lockup, headline,
/// and a centered, width-constrained, keyboard-safe form column.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.title,
    required this.lede,
    required this.children,
    this.footer,
  });

  final String title;
  final String lede;
  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.gutter + 4,
                  vertical: AppSpacing.lg,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: BrandWordmark(),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        Semantics(
                          header: true,
                          child: Text(title, style: textTheme.displaySmall),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          lede,
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        ...children,
                        const Spacer(),
                        if (footer != null) ...[
                          const SizedBox(height: AppSpacing.xl),
                          footer!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Password field with a visibility toggle. Validation is supplied by the
/// caller so existing rules are unchanged.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.validator,
    required this.autofillHints,
    this.label,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final bool enabled;
  final FormFieldValidator<String> validator;
  final Iterable<String> autofillHints;

  /// Defaults to the localized "Password" label.
  final String? label;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  var _obscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _obscured,
      enableSuggestions: false,
      autocorrect: false,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: widget.label ?? context.l10n.fieldPassword,
        suffixIcon: IconButton(
          tooltip: _obscured
              ? context.l10n.passwordShow
              : context.l10n.passwordHide,
          icon: Icon(
            _obscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 20,
            color: AppColors.textMuted,
          ),
          onPressed: () => setState(() => _obscured = !_obscured),
        ),
      ),
      validator: widget.validator,
    );
  }
}

/// "Question? Action" footer link row.
class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({
    super.key,
    required this.prompt,
    required this.action,
    required this.onPressed,
  });

  final String prompt;
  final String action;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(prompt, style: Theme.of(context).textTheme.bodyMedium),
        TextButton(onPressed: onPressed, child: Text(action)),
      ],
    );
  }
}
