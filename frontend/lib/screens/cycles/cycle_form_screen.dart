import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/api_exception.dart';
import '../../core/presentation/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cycle.dart';
import '../../state/cycle_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/profile_button.dart';
import '../../core/presentation/error_messages.dart';
import '../../l10n/l10n.dart';

class CycleFormScreen extends ConsumerStatefulWidget {
  const CycleFormScreen({super.key, this.cycle});

  final Cycle? cycle;

  @override
  ConsumerState<CycleFormScreen> createState() => _CycleFormScreenState();
}

class _CycleFormScreenState extends ConsumerState<CycleFormScreen> {
  late DateTime _startDate;
  DateTime? _endDate;
  var _isSubmitting = false;
  String? _errorMessage;

  bool get _isEditing => widget.cycle != null;

  @override
  void initState() {
    super.initState();
    _startDate = widget.cycle?.startDate ?? DateUtils.dateOnly(DateTime.now());
    _endDate = widget.cycle?.endDate;
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _submit() async {
    setState(() => _errorMessage = null);

    final endDate = _endDate;
    if (endDate != null && endDate.isBefore(_startDate)) {
      setState(() => _errorMessage = context.l10n.errorEndBeforeStart);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      if (_isEditing) {
        await ref
            .read(cycleProvider.notifier)
            .updateCycle(
              cycleId: widget.cycle!.id,
              startDate: _startDate,
              endDate: endDate,
            );
      } else {
        await ref
            .read(cycleProvider.notifier)
            .createCycle(startDate: _startDate, endDate: endDate);
      }

      if (mounted) {
        context.pop();
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(
          () => _errorMessage = ErrorText.of(
            context.l10n,
            error,
            fallback: _isEditing
                ? context.l10n.cycleUpdateFailed
                : context.l10n.cycleCreateFailed,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _errorMessage = _isEditing
              ? context.l10n.cycleUpdateFailed
              : context.l10n.cycleCreateFailed,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final endDate = _endDate;
    final textTheme = Theme.of(context).textTheme;
    final enabled = !_isSubmitting;
    final l10n = context.l10n;
    final periodLength = endDate == null || endDate.isBefore(_startDate)
        ? null
        : endDate.difference(_startDate).inDays + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.cycleEditTitle : l10n.cycleNewTitle),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: ProfileButton(),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.xs,
            AppSpacing.gutter,
            AppSpacing.xxl,
          ),
          children: [
            Text(l10n.cycleFormIntro, style: textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.xl),
            _DateTile(
              eyebrow: l10n.cycleStarted,
              value: Fmt.date(_startDate),
              detail: Fmt.relativeDay(l10n, _startDate),
              enabled: enabled,
              onTap: _pickStartDate,
              filled: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            _DateTile(
              eyebrow: l10n.cycleEnded,
              value: endDate == null
                  ? l10n.cycleNotRecorded
                  : Fmt.date(endDate),
              detail: endDate == null
                  ? l10n.cycleEndHelp
                  : periodLength == null
                  ? null
                  : l10n.cycleBleedingDays(periodLength),
              enabled: enabled,
              onTap: _pickEndDate,
              filled: endDate != null,
            ),
            if (!_isEditing && endDate != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: enabled
                      ? () => setState(() => _endDate = null)
                      : null,
                  child: Text(l10n.cycleClearEnd),
                ),
              ),
            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),
              InlineMessage(message: _errorMessage!),
            ],
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.sm,
              AppSpacing.gutter,
              AppSpacing.sm,
            ),
            child: FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const ButtonSpinner(color: AppColors.primary)
                  : Text(_isEditing ? l10n.commonSaveChanges : l10n.cycleSave),
            ),
          ),
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.eyebrow,
    required this.value,
    required this.enabled,
    required this.onTap,
    required this.filled,
    this.detail,
  });

  final String eyebrow;
  final String value;
  final String? detail;
  final bool enabled;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: context.l10n.semanticValue(eyebrow, value),
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgRadius,
          side: const BorderSide(color: AppColors.outline),
        ),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: AppRadius.lgRadius,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 44,
                  decoration: BoxDecoration(
                    color: filled ? PhaseColors.menstrual : AppColors.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Fmt.upper(eyebrow), style: AppTypography.eyebrow),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: textTheme.titleLarge?.copyWith(
                          color: filled
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                      if (detail != null) ...[
                        const SizedBox(height: 2),
                        Text(detail!, style: textTheme.bodySmall),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.edit_calendar_outlined,
                  size: 20,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
