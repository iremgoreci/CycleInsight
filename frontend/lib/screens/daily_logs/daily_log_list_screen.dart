import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/daily_log.dart';
import '../../state/daily_log_provider.dart';
import 'daily_log_labels.dart';

class DailyLogListScreen extends ConsumerWidget {
  const DailyLogListScreen({super.key});

  static final _displayDateFormat = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(dailyLogProvider);

    return logs.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _DailyLogLoadError(
        message: _userFacingMessage(error),
        onRetry: () => ref.read(dailyLogProvider.notifier).refresh(),
      ),
      data: (items) => RefreshIndicator(
        onRefresh: () => ref.read(dailyLogProvider.notifier).refresh(),
        child: items.isEmpty
            ? ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  SizedBox(height: 120),
                  Icon(Icons.edit_note_outlined, size: 56),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'No daily logs yet.\nTap + to record how you feel today.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _DailyLogCard(
                  log: items[index],
                  onEdit: () => context.push(
                    '/daily-logs/${items[index].id}/edit',
                    extra: items[index],
                  ),
                  onDelete: () => _confirmDelete(context, ref, items[index]),
                ),
              ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    DailyLog log,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete daily log?'),
        content: Text(
          'Delete the log for ${_displayDateFormat.format(log.logDate)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(dailyLogProvider.notifier).deleteDailyLog(log.id);
    } on ApiException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_userFacingMessage(error))));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to delete daily log')),
        );
      }
    }
  }
}

class _DailyLogCard extends StatelessWidget {
  const _DailyLogCard({
    required this.log,
    required this.onEdit,
    required this.onDelete,
  });

  final DailyLog log;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().format(log.logDate);
    final summary = [
      'Mood: ${DailyLogLabels.mood[log.moodLevel]}',
      'Pain: ${DailyLogLabels.pain[log.painLevel]}',
      'Sleep: ${DailyLogLabels.sleep[log.sleepQuality]}',
    ].join(' • ');

    return Card(
      child: ListTile(
        onTap: onEdit,
        leading: const Icon(Icons.calendar_today_outlined),
        title: Text(date),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(summary),
            if (log.symptoms.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Symptoms: ${log.symptoms.map((symptom) => symptom.name).join(', ')}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (log.notes != null && log.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(log.notes!, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
        isThreeLine:
            log.symptoms.isNotEmpty ||
            (log.notes != null && log.notes!.isNotEmpty),
        trailing: PopupMenuButton<_DailyLogAction>(
          onSelected: (action) {
            switch (action) {
              case _DailyLogAction.edit:
                onEdit();
                break;
              case _DailyLogAction.delete:
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: _DailyLogAction.edit, child: Text('Edit')),
            PopupMenuItem(value: _DailyLogAction.delete, child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}

class _DailyLogLoadError extends StatelessWidget {
  const _DailyLogLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

String dailyLogUserFacingMessage(Object error) {
  if (error is! ApiException) {
    return 'Unable to load daily logs';
  }
  return _userFacingMessage(error);
}

String _userFacingMessage(Object error) {
  if (error is! ApiException) {
    return 'Something went wrong. Please try again.';
  }

  switch (error.statusCode) {
    case 404:
      return 'This daily log is no longer available.';
    case 409:
      return 'A daily log already exists for this date.';
    case 500:
      return 'The server could not complete this request. Please try again.';
    default:
      return error.message;
  }
}

enum _DailyLogAction { edit, delete }
