import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/api_exception.dart';
import '../../core/presentation/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/daily_log_symptom.dart';
import '../../data/models/symptom_type.dart';
import '../../state/daily_log_provider.dart';
import '../../state/symptom_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/level_scale.dart';
import '../../widgets/profile_button.dart';
import 'daily_log_labels.dart';
import '../../core/presentation/error_messages.dart';
import '../../l10n/l10n.dart';

class DailyLogFormScreen extends ConsumerStatefulWidget {
  const DailyLogFormScreen({super.key, this.dailyLog});

  final DailyLog? dailyLog;

  @override
  ConsumerState<DailyLogFormScreen> createState() => _DailyLogFormScreenState();
}

class _DailyLogFormScreenState extends ConsumerState<DailyLogFormScreen> {
  late DateTime _logDate;
  late int _bleedingLevel;
  late int _moodLevel;
  late int _painLevel;
  late int _sleepQuality;
  late int _stressLevel;
  late final TextEditingController _notesController;
  final Set<int> _selectedSymptomTypeIds = {};
  DailyLog? _createdDailyLog;
  var _hasLoadedInitialSymptoms = false;
  var _isSubmitting = false;
  String? _errorMessage;

  bool get _isEditing => widget.dailyLog != null || _createdDailyLog != null;
  bool get _isOriginalEdit => widget.dailyLog != null;
  DailyLog get _currentDailyLog => widget.dailyLog ?? _createdDailyLog!;

  @override
  void initState() {
    super.initState();
    final log = widget.dailyLog;
    _logDate = log?.logDate ?? DateUtils.dateOnly(DateTime.now());
    _bleedingLevel = log?.bleedingLevel ?? 0;
    _moodLevel = log?.moodLevel ?? 3;
    _painLevel = log?.painLevel ?? 0;
    _sleepQuality = log?.sleepQuality ?? 3;
    _stressLevel = log?.stressLevel ?? 0;
    _notesController = TextEditingController(text: log?.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _logDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _logDate = picked);
    }
  }

  Future<void> _submit() async {
    setState(() => _errorMessage = null);
    final notes = _notesController.text.trim();
    final requestNotes = _isEditing
        ? notes
        : notes.isEmpty
        ? null
        : notes;

    setState(() => _isSubmitting = true);
    try {
      if (_isEditing) {
        await ref
            .read(dailyLogProvider.notifier)
            .updateDailyLog(
              dailyLogId: _currentDailyLog.id,
              logDate: _logDate,
              bleedingLevel: _bleedingLevel,
              moodLevel: _moodLevel,
              painLevel: _painLevel,
              sleepQuality: _sleepQuality,
              stressLevel: _stressLevel,
              notes: requestNotes,
            );
      } else {
        final dailyLog = await ref
            .read(dailyLogProvider.notifier)
            .createDailyLog(
              logDate: _logDate,
              bleedingLevel: _bleedingLevel,
              moodLevel: _moodLevel,
              painLevel: _painLevel,
              sleepQuality: _sleepQuality,
              stressLevel: _stressLevel,
              notes: requestNotes,
            );
        if (mounted) {
          setState(() => _createdDailyLog = dailyLog);
        }
      }

      await ref
          .read(dailyLogSymptomsProvider.notifier)
          .syncForDailyLog(
            dailyLogId: _currentDailyLog.id,
            selectedSymptomTypeIds: _selectedSymptomTypeIds,
          );
      await ref.read(dailyLogProvider.notifier).refresh();

      if (mounted) {
        context.pop();
      }
    } on ApiException catch (error) {
      await ref.read(dailyLogProvider.notifier).refresh();
      if (mounted) {
        setState(
          () => _errorMessage = _createdDailyLog == null
              ? ErrorText.of(
                  context.l10n,
                  error,
                  fallback: _isEditing
                      ? context.l10n.logUpdateFailed
                      : context.l10n.logCreateFailed,
                )
              : context.l10n.logSavedButSymptomsFailed,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _errorMessage = _isEditing
              ? context.l10n.logUpdateFailed
              : context.l10n.logCreateFailed,
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
    final symptomTypes = ref.watch(symptomTypesProvider);
    final relationships = ref.watch(dailyLogSymptomsProvider);
    final symptomsReady =
        symptomTypes.hasValue &&
        (!_isOriginalEdit ||
            (relationships.hasValue && _hasLoadedInitialSymptoms));
    final enabled = !_isSubmitting;
    final l10n = context.l10n;
    final labels = DailyLogLabels(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.logEditTitle : l10n.logNewTitle),
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.xs,
            AppSpacing.gutter,
            AppSpacing.xxl,
          ),
          children: [
            _DateHeader(date: _logDate, enabled: enabled, onChange: _pickDate),
            const SizedBox(height: AppSpacing.xl),
            _FormSection(
              title: l10n.logSectionBody,
              children: [
                LevelScale(
                  title: l10n.metricBleeding,
                  icon: Icons.water_drop_outlined,
                  labels: labels.bleeding,
                  value: _bleedingLevel,
                  color: MetricColors.bleeding,
                  enabled: enabled,
                  onChanged: (value) => setState(() => _bleedingLevel = value),
                ),
                LevelScale(
                  title: l10n.metricPain,
                  icon: Icons.bolt_outlined,
                  labels: labels.pain,
                  value: _painLevel,
                  color: MetricColors.pain,
                  enabled: enabled,
                  onChanged: (value) => setState(() => _painLevel = value),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _FormSection(
              title: l10n.logSectionMind,
              children: [
                LevelScale(
                  title: l10n.metricMood,
                  icon: Icons.sentiment_satisfied_outlined,
                  labels: labels.mood,
                  value: _moodLevel,
                  color: MetricColors.mood,
                  enabled: enabled,
                  onChanged: (value) => setState(() => _moodLevel = value),
                ),
                LevelScale(
                  title: l10n.metricSleepQuality,
                  icon: Icons.bedtime_outlined,
                  labels: labels.sleep,
                  value: _sleepQuality,
                  color: MetricColors.sleep,
                  enabled: enabled,
                  onChanged: (value) => setState(() => _sleepQuality = value),
                ),
                LevelScale(
                  title: l10n.metricStress,
                  icon: Icons.waves_outlined,
                  labels: labels.stress,
                  value: _stressLevel,
                  color: MetricColors.stress,
                  enabled: enabled,
                  onChanged: (value) => setState(() => _stressLevel = value),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppSectionHeading(
              title: l10n.logSymptoms,
              subtitle: l10n.logSymptomsSubtitle,
              action: _selectedSymptomTypeIds.isEmpty
                  ? null
                  : Text(
                      l10n.logSymptomsSelected(_selectedSymptomTypeIds.length),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildSymptomsSection(symptomTypes, relationships),
            const SizedBox(height: AppSpacing.xl),
            AppSectionHeading(title: l10n.logNotes),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _notesController,
              enabled: enabled,
              minLines: 3,
              maxLines: 6,
              maxLength: 1000,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [LengthLimitingTextInputFormatter(1000)],
              decoration: InputDecoration(
                hintText: l10n.logNotesHint,
                alignLabelWithHint: true,
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              InlineMessage(message: _errorMessage!),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _SaveBar(
        label: _isEditing ? l10n.commonSaveChanges : l10n.logSave,
        isSubmitting: _isSubmitting,
        onPressed: _isSubmitting || !symptomsReady ? null : _submit,
      ),
    );
  }

  Widget _buildSymptomsSection(
    AsyncValue<List<SymptomType>> symptomTypes,
    AsyncValue<List<DailyLogSymptom>> relationships,
  ) {
    return symptomTypes.when(
      loading: () => const _SymptomsLoading(),
      error: (_, _) =>
          _SymptomsError(onRetry: () => ref.invalidate(symptomTypesProvider)),
      data: (types) {
        if (_isOriginalEdit && !relationships.hasValue) {
          return relationships.when(
            loading: () => const _SymptomsLoading(),
            error: (_, _) => _SymptomsError(
              onRetry: () =>
                  ref.read(dailyLogSymptomsProvider.notifier).refresh(),
            ),
            data: (_) => const SizedBox.shrink(),
          );
        }

        if (_isOriginalEdit && !_hasLoadedInitialSymptoms) {
          final existingIds =
              relationships.valueOrNull
                  ?.where(
                    (relationship) =>
                        relationship.dailyLogId == widget.dailyLog!.id,
                  )
                  .map((relationship) => relationship.symptomTypeId)
                  .toSet() ??
              <int>{};
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedSymptomTypeIds.addAll(existingIds);
                _hasLoadedInitialSymptoms = true;
              });
            }
          });
          return const _SymptomsLoading();
        }

        return _SymptomsSelector(
          types: types,
          selectedIds: _selectedSymptomTypeIds,
          enabled: !_isSubmitting,
          onChanged: (symptomTypeId, selected) {
            setState(() {
              if (selected) {
                _selectedSymptomTypeIds.add(symptomTypeId);
              } else {
                _selectedSymptomTypeIds.remove(symptomTypeId);
              }
            });
          },
        );
      },
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({
    required this.date,
    required this.enabled,
    required this.onChange,
  });

  final DateTime date;
  final bool enabled;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final relative = Fmt.daysFromToday(date);
    final eyebrow = switch (relative) {
      0 => Fmt.upper(context.l10n.commonToday),
      -1 => Fmt.upper(context.l10n.commonYesterday),
      _ => Fmt.upper(Fmt.weekday(date)),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: AppTypography.eyebrow.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(Fmt.date(date), style: textTheme.headlineSmall),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: enabled ? onChange : null,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 40),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          ),
          icon: const Icon(Icons.calendar_today_outlined, size: 16),
          label: Text(context.l10n.commonChange),
        ),
      ],
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionHeading(title: title),
        const SizedBox(height: AppSpacing.sm),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: children[i],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.label,
    required this.isSubmitting,
    required this.onPressed,
  });

  final String label;
  final bool isSubmitting;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
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
            onPressed: onPressed,
            child: isSubmitting
                ? const ButtonSpinner(color: AppColors.primary)
                : Text(label),
          ),
        ),
      ),
    );
  }
}

class _SymptomsSelector extends StatelessWidget {
  const _SymptomsSelector({
    required this.types,
    required this.selectedIds,
    required this.enabled,
    required this.onChanged,
  });

  final List<SymptomType> types;
  final Set<int> selectedIds;
  final bool enabled;
  final void Function(int symptomTypeId, bool selected) onChanged;

  @override
  Widget build(BuildContext context) {
    if (types.isEmpty) {
      return Text(
        context.l10n.logNoSymptomTypes,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final type in types)
          _SymptomToggle(
            label: type.name,
            selected: selectedIds.contains(type.id),
            onTap: enabled
                ? () {
                    HapticFeedback.selectionClick();
                    onChanged(type.id, !selectedIds.contains(type.id));
                  }
                : null,
          ),
      ],
    );
  }
}

class _SymptomToggle extends StatelessWidget {
  const _SymptomToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      toggled: selected,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? AppColors.primarySoft : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.smRadius,
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.outline,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.smRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 10,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? Icons.check : Icons.add,
                  size: 16,
                  color: selected ? AppColors.primaryDark : AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: textTheme.labelMedium?.copyWith(
                      color: selected
                          ? AppColors.primaryDark
                          : AppColors.textPrimary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SymptomsLoading extends StatelessWidget {
  const _SymptomsLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            context.l10n.logSymptomsLoading,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _SymptomsError extends StatelessWidget {
  const _SymptomsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.cloud_off_outlined, size: 18, color: AppColors.error),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            context.l10n.logSymptomsError,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        TextButton(
          onPressed: onRetry,
          child: Text(context.l10n.commonTryAgain),
        ),
      ],
    );
  }
}
