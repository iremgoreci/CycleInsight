import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/daily_log_symptom.dart';
import '../../data/models/symptom_type.dart';
import '../../state/daily_log_provider.dart';
import '../../state/symptom_provider.dart';
import 'daily_log_labels.dart';
import 'daily_log_list_screen.dart';

class DailyLogFormScreen extends ConsumerStatefulWidget {
  const DailyLogFormScreen({super.key, this.dailyLog});

  final DailyLog? dailyLog;

  @override
  ConsumerState<DailyLogFormScreen> createState() => _DailyLogFormScreenState();
}

class _DailyLogFormScreenState extends ConsumerState<DailyLogFormScreen> {
  static final _displayDateFormat = DateFormat.yMMMd();

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
              ? dailyLogUserFacingMessage(error)
              : 'Daily log saved, but some symptoms could not be saved. '
                    'Please try again.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _errorMessage = _isEditing
              ? 'Unable to update daily log'
              : 'Unable to create daily log',
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit daily log' : 'New daily log'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(_displayDateFormat.format(_logDate)),
              trailing: const Icon(Icons.edit_calendar_outlined),
              enabled: !_isSubmitting,
              onTap: _isSubmitting ? null : _pickDate,
            ),
            const Divider(),
            _LevelSelector(
              title: 'Bleeding',
              values: DailyLogLabels.bleeding,
              selectedValue: _bleedingLevel,
              enabled: !_isSubmitting,
              onChanged: (value) => setState(() => _bleedingLevel = value),
            ),
            _LevelSelector(
              title: 'Mood',
              values: DailyLogLabels.mood,
              selectedValue: _moodLevel,
              enabled: !_isSubmitting,
              onChanged: (value) => setState(() => _moodLevel = value),
            ),
            _LevelSelector(
              title: 'Pain',
              values: DailyLogLabels.pain,
              selectedValue: _painLevel,
              enabled: !_isSubmitting,
              onChanged: (value) => setState(() => _painLevel = value),
            ),
            _LevelSelector(
              title: 'Sleep quality',
              values: DailyLogLabels.sleep,
              selectedValue: _sleepQuality,
              enabled: !_isSubmitting,
              onChanged: (value) => setState(() => _sleepQuality = value),
            ),
            _LevelSelector(
              title: 'Stress',
              values: DailyLogLabels.stress,
              selectedValue: _stressLevel,
              enabled: !_isSubmitting,
              onChanged: (value) => setState(() => _stressLevel = value),
            ),
            const SizedBox(height: 20),
            _buildSymptomsSection(symptomTypes, relationships),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              enabled: !_isSubmitting,
              minLines: 3,
              maxLines: 5,
              maxLength: 1000,
              inputFormatters: [LengthLimitingTextInputFormatter(1000)],
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                alignLabelWithHint: true,
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSubmitting || !symptomsReady ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Save changes' : 'Save daily log'),
            ),
          ],
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Symptoms', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (types.isEmpty)
          const Text('No symptom types are available.')
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: types
                .map(
                  (type) => FilterChip(
                    label: Text(type.name),
                    selected: selectedIds.contains(type.id),
                    onSelected: enabled
                        ? (selected) => onChanged(type.id, selected)
                        : null,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _SymptomsLoading extends StatelessWidget {
  const _SymptomsLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Loading symptoms...'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Symptoms could not be loaded. Please try again.'),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}

class _LevelSelector extends StatelessWidget {
  const _LevelSelector({
    required this.title,
    required this.values,
    required this.selectedValue,
    required this.enabled,
    required this.onChanged,
  });

  final String title;
  final Map<int, String> values;
  final int selectedValue;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values.entries
                .map(
                  (entry) => ChoiceChip(
                    label: Text(entry.value),
                    selected: selectedValue == entry.key,
                    onSelected: enabled ? (_) => onChanged(entry.key) : null,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
