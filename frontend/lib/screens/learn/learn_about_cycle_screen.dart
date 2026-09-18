import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/profile_button.dart';
import 'phase_detail_screen.dart';

/// Structural placeholder for the four cycle phases. No educational or
/// medical content is written here by design — only titles, icons and an
/// empty content area, ready for real copy to be filled in later.
class LearnAboutCycleScreen extends StatelessWidget {
  const LearnAboutCycleScreen({super.key});

  static const _phases = [
    _PhaseInfo(
      title: 'Menstrual Phase',
      icon: Icons.water_drop_outlined,
    ),
    _PhaseInfo(
      title: 'Follicular Phase',
      icon: Icons.eco_outlined,
    ),
    _PhaseInfo(
      title: 'Ovulatory Phase',
      icon: Icons.spa_outlined,
    ),
    _PhaseInfo(
      title: 'Luteal Phase',
      icon: Icons.nightlight_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn about your cycle'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ProfileButton(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Your menstrual cycle has four main phases. Each phase brings '
            'different changes to your body and mind.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final phase in _phases) ...[
            _PhaseCard(phase: phase),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _PhaseInfo {
  const _PhaseInfo({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({required this.phase});

  final _PhaseInfo phase;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: AppRadius.lgRadius,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PhaseDetailScreen(title: phase.title, icon: phase.icon),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.blush,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      phase.icon,
                      color: AppColors.primaryDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      phase.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: AppRadius.mdRadius,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
