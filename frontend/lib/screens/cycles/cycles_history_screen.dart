import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/profile_button.dart';
import 'cycle_list_screen.dart';
import '../../l10n/l10n.dart';

/// Standalone screen for managing cycle records (period start/end dates).
///
/// Cycle management is not a bottom-navigation tab; the existing CRUD
/// screens and provider are reused here.
class CyclesHistoryScreen extends StatelessWidget {
  const CyclesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.cycleHistoryTitle),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/cycles/new'),
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.l10n.cycleAddPeriod),
          ),
          const Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: ProfileButton(),
          ),
        ],
      ),
      body: const SafeArea(top: false, child: CycleListScreen()),
    );
  }
}
