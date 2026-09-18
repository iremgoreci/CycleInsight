import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/profile_button.dart';
import '../analysis/analysis_screen.dart';
import '../daily_logs/daily_log_list_screen.dart';
import '../home/home_screen.dart';

/// Shell for the 3 primary destinations: Home, Daily Log, Insights.
///
/// Home is the landing tab (index 0) and always defaults there after
/// login, per the route configuration in `app_router.dart`.
class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key, required this.selectedIndex});

  final int selectedIndex;

  static const _titles = ['Home', 'Daily log', 'Insights'];

  @override
  Widget build(BuildContext context) {
    final isHome = selectedIndex == 0;

    return Scaffold(
      appBar: isHome
          ? null
          : AppBar(
              title: Text(_titles[selectedIndex]),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: ProfileButton(),
                ),
              ],
            ),
      body: switch (selectedIndex) {
        0 => const HomeScreen(),
        1 => const DailyLogListScreen(),
        _ => const AnalysisScreen(),
      },
      floatingActionButton: selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () => context.push('/daily-logs/new'),
              child: const Icon(Icons.add),
            )
          : null,
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
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'Daily log',
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
