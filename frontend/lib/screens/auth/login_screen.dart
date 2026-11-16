import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/api_exception.dart';
import '../../core/theme/app_theme.dart';
import '../../state/auth_provider.dart';
import '../../widgets/app_feedback.dart';
import 'auth_layout.dart';
import '../../core/presentation/error_messages.dart';
import '../../l10n/l10n.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _errorMessage = null);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(authProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    } on ApiException catch (error) {
      if (mounted) {
        setState(
          () => _errorMessage = ErrorText.of(
            context.l10n,
            error,
            fallback: context.l10n.loginFailed,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = context.l10n.loginFailed);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthLayout(
      title: l10n.loginTitle,
      lede: l10n.loginLede,
      footer: AuthSwitchLink(
        prompt: l10n.loginNewPrompt,
        action: l10n.loginCreateAccount,
        onPressed: _isSubmitting ? null : () => context.go('/register'),
      ),
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  enabled: !_isSubmitting,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: l10n.fieldEmail),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.validationEmailRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                PasswordField(
                  controller: _passwordController,
                  enabled: !_isSubmitting,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _isSubmitting ? null : _submit(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.validationPasswordRequired;
                    }
                    return null;
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  InlineMessage(message: _errorMessage!),
                ],
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const ButtonSpinner(color: AppColors.primary)
                      : Text(l10n.loginSubmit),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
