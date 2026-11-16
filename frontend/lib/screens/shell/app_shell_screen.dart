import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../analysis/analysis_screen.dart';
import '../daily_logs/daily_log_list_screen.dart';
import '../home/home_screen.dart';
import '../../l10n/l10n.dart';

/// Shell for the 3 primary destinations: Today, Journal (daily logs) and
/// Insights. Each destination renders its own header; the shell only owns
/// the navigation bar. Routes are unchanged ('/', '/daily-logs',
/// '/insights').
class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: switch (selectedIndex) {
          0 => const HomeScreen(),
          1 => const DailyLogListScreen(),
          _ => const AnalysisScreen(),
        },
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            context.go(switch (index) {
              0 => '/',
              1 => '/daily-logs',
              _ => '/insights',
            });
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.radio_button_unchecked),
              selectedIcon: const Icon(Icons.adjust),
              label: context.l10n.navToday,
            ),
            NavigationDestination(
              icon: const Icon(Icons.edit_note_outlined),
              selectedIcon: const Icon(Icons.edit_note),
              label: context.l10n.navJournal,
            ),
            NavigationDestination(
              icon: const Icon(Icons.insights_outlined),
              selectedIcon: const Icon(Icons.insights),
              label: context.l10n.navInsights,
            ),
          ],
        ),
      ),
    );
  }
}
