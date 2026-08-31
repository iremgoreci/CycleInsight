import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/cycle.dart';
import '../../state/cycle_provider.dart';

class CycleListScreen extends ConsumerWidget {
  const CycleListScreen({super.key});

  static final _displayDateFormat = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycles = ref.watch(cycleProvider);

    return cycles.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _CycleLoadError(
        message: _errorMessage(error),
        onRetry: () => ref.read(cycleProvider.notifier).refresh(),
      ),
      data: (items) => RefreshIndicator(
        onRefresh: () => ref.read(cycleProvider.notifier).refresh(),
        child: items.isEmpty
            ? ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  SizedBox(height: 120),
                  Icon(Icons.calendar_month_outlined, size: 56),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'No cycles recorded yet.\nTap + to add your first cycle.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _CycleCard(
                  cycle: items[index],
                  displayDate: _displayDateFormat,
                  onEdit: () => context.push(
                    '/cycles/${items[index].id}/edit',
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
    Cycle cycle,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete cycle?'),
        content: Text(
          'Delete the cycle starting ${_displayDateFormat.format(cycle.startDate)}?',
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
      await ref.read(cycleProvider.notifier).deleteCycle(cycle.id);
    } on ApiException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Unable to delete cycle')));
      }
    }
  }

  String _errorMessage(Object error) {
    return error is ApiException ? error.message : 'Unable to load cycles';
  }
}

class _CycleCard extends StatelessWidget {
  const _CycleCard({
    required this.cycle,
    required this.displayDate,
    required this.onEdit,
    required this.onDelete,
  });

  final Cycle cycle;
  final DateFormat displayDate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final endDate = cycle.endDate;
    final dateRange = endDate == null
        ? 'Started ${displayDate.format(cycle.startDate)}'
        : '${displayDate.format(cycle.startDate)} – ${displayDate.format(endDate)}';

    return Card(
      child: ListTile(
        onTap: onEdit,
        leading: Icon(
          cycle.isOngoing ? Icons.timelapse_outlined : Icons.event_available,
        ),
        title: Text(dateRange),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text(cycle.isOngoing ? 'Ongoing' : 'Completed'),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        trailing: PopupMenuButton<_CycleAction>(
          onSelected: (action) {
            switch (action) {
              case _CycleAction.edit:
                onEdit();
                break;
              case _CycleAction.delete:
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: _CycleAction.edit, child: Text('Edit')),
            PopupMenuItem(value: _CycleAction.delete, child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}

class _CycleLoadError extends StatelessWidget {
  const _CycleLoadError({required this.message, required this.onRetry});

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

enum _CycleAction { edit, delete }
