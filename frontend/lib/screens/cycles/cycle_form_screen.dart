import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/cycle.dart';
import '../../state/cycle_provider.dart';

class CycleFormScreen extends ConsumerStatefulWidget {
  const CycleFormScreen({super.key, this.cycle});

  final Cycle? cycle;

  @override
  ConsumerState<CycleFormScreen> createState() => _CycleFormScreenState();
}

class _CycleFormScreenState extends ConsumerState<CycleFormScreen> {
  static final _displayDateFormat = DateFormat.yMMMd();

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
      setState(() => _errorMessage = 'End date cannot be before start date.');
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
        setState(() => _errorMessage = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _errorMessage = _isEditing
              ? 'Unable to update cycle'
              : 'Unable to create cycle',
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

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit cycle' : 'New cycle')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Start date'),
              subtitle: Text(_displayDateFormat.format(_startDate)),
              trailing: const Icon(Icons.edit_calendar_outlined),
              enabled: !_isSubmitting,
              onTap: _isSubmitting ? null : _pickStartDate,
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('End date'),
              subtitle: Text(
                endDate == null
                    ? 'No end date — this cycle is ongoing'
                    : _displayDateFormat.format(endDate),
              ),
              trailing: const Icon(Icons.edit_calendar_outlined),
              enabled: !_isSubmitting,
              onTap: _isSubmitting ? null : _pickEndDate,
            ),
            if (!_isEditing && endDate != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => setState(() => _endDate = null),
                  child: const Text('Mark as ongoing'),
                ),
              ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Save changes' : 'Create cycle'),
            ),
          ],
        ),
      ),
    );
  }
}
