import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/api_exception.dart';
import '../../core/presentation/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../state/auth_provider.dart';
import '../../widgets/app_feedback.dart';
import 'auth_layout.dart';
import '../../core/presentation/error_messages.dart';
import '../../l10n/l10n.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _dateOfBirth;
  var _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: context.l10n.fieldDateOfBirth,
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _submit() async {
    setState(() => _errorMessage = null);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final dateOfBirth = _dateOfBirth;
    if (dateOfBirth == null) {
      setState(
        () => _errorMessage = context.l10n.validationDateOfBirthRequired,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(authProvider.notifier)
          .register(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            dateOfBirth: dateOfBirth,
          );
    } on ApiException catch (error) {
      if (mounted) {
        setState(
          () => _errorMessage = ErrorText.of(
            context.l10n,
            error,
            fallback: context.l10n.registerFailed,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = context.l10n.registerFailed);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return AuthLayout(
      title: l10n.registerTitle,
      lede: l10n.registerLede,
      footer: AuthSwitchLink(
        prompt: l10n.registerHaveAccount,
        action: l10n.registerSignIn,
        onPressed: _isSubmitting ? null : () => context.go('/login'),
      ),
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  Fmt.upper(l10n.registerSectionAbout),
                  style: AppTypography.eyebrow,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        enabled: !_isSubmitting,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.givenName],
                        decoration: InputDecoration(
                          labelText: l10n.fieldFirstName,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.validationFirstNameRequired;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        enabled: !_isSubmitting,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.familyName],
                        decoration: InputDecoration(
                          labelText: l10n.fieldLastName,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.validationLastNameRequired;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _DateOfBirthField(
                  value: _dateOfBirth,
                  enabled: !_isSubmitting,
                  onTap: _pickDateOfBirth,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(l10n.registerDobHelp, style: textTheme.bodySmall),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  Fmt.upper(l10n.registerSectionAccount),
                  style: AppTypography.eyebrow,
                ),
                const SizedBox(height: AppSpacing.sm),
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
                  autofillHints: const [AutofillHints.newPassword],
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.validationNewPasswordRequired;
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
                      : Text(l10n.registerSubmit),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Read-only field that opens the date picker, styled like a text input.
class _DateOfBirthField extends StatelessWidget {
  const _DateOfBirthField({
    required this.value,
    required this.enabled,
    required this.onTap,
  });

  final DateTime? value;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: value == null
          ? context.l10n.registerDobNotSet
          : context.l10n.registerDobSemantic(Fmt.date(value!)),
      excludeSemantics: true,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: AppRadius.mdRadius,
        child: InputDecorator(
          isEmpty: value == null,
          decoration: InputDecoration(
            labelText: context.l10n.fieldDateOfBirth,
            enabled: enabled,
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.textMuted,
            ),
          ),
          child: Text(
            value == null ? '' : Fmt.date(value!),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
