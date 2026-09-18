import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/profile_button.dart';
import 'cycle_list_screen.dart';

/// Standalone screen for managing cycle records (start/end dates).
///
/// Cycle management is no longer a bottom-navigation tab in the new
/// Home-first layout, but the existing CRUD screens and provider are fully
/// reused here unchanged — only this thin Scaffold wrapper is new.
class CyclesHistoryScreen extends StatelessWidget {
  const CyclesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle history'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ProfileButton(),
          ),
        ],
      ),
      body: const CycleListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/cycles/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
