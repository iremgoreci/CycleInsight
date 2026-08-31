import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/auth_provider.dart';
import '../analysis/analysis_screen.dart';
import '../cycles/cycle_list_screen.dart';
import '../daily_logs/daily_log_list_screen.dart';

class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          switch (selectedIndex) {
            0 => 'Cycles',
            1 => 'Daily logs',
            _ => 'Insights',
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: switch (selectedIndex) {
        0 => const CycleListScreen(),
        1 => const DailyLogListScreen(),
        _ => const AnalysisScreen(),
      },
      floatingActionButton: selectedIndex == 2
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(
                selectedIndex == 0 ? '/cycles/new' : '/daily-logs/new',
              ),
              icon: const Icon(Icons.add),
              label: Text(
                selectedIndex == 0 ? 'Add cycle' : 'Add daily log',
              ),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          context.go(
            switch (index) {
              0 => '/',
              1 => '/daily-logs',
              _ => '/insights',
            },
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Cycles',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'Daily logs',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Insights',
          ),
        ],
      ),
    );
  }
}
