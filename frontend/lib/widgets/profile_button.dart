import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/presentation/formatters.dart';
import '../core/theme/app_theme.dart';
import '../data/models/user.dart';
import '../state/auth_provider.dart';
import '../l10n/l10n.dart';

/// Profile/account entry point, reused on every top-level screen.
///
/// There is no dedicated profile route, so this opens an account sheet on
/// top of the existing auth state instead of introducing new backend or
/// business logic.
class ProfileButton extends ConsumerWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Semantics(
      button: true,
      label: context.l10n.profileAccount,
      child: InkResponse(
        onTap: () => _showAccountSheet(context, ref),
        radius: 24,
        child: SizedBox.square(
          dimension: 44,
          child: Center(child: _Avatar(initials: _initials(user), size: 34)),
        ),
      ),
    );
  }

  static String _initials(User? user) {
    if (user == null) {
      return '';
    }
    final first = user.firstName.isNotEmpty ? user.firstName[0] : '';
    final last = user.lastName.isNotEmpty ? user.lastName[0] : '';
    final initials = Fmt.upper('$first$last');
    return initials.isEmpty ? '?' : initials;
  }

  static Future<void> _showAccountSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        final currentUser = ref.read(authProvider).user;
        final fullName = currentUser == null
            ? ''
            : '${currentUser.firstName} ${currentUser.lastName}'.trim();
        final textTheme = Theme.of(sheetContext).textTheme;
        final l10n = sheetContext.l10n;

        void go(VoidCallback navigate) {
          Navigator.of(sheetContext).pop();
          navigate();
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              0,
              AppSpacing.gutter,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _Avatar(initials: _initials(currentUser), size: 52),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName.isEmpty ? l10n.profileAccount : fullName,
                            style: textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (currentUser != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              currentUser.email,
                              style: textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              l10n.profileBorn(
                                Fmt.date(currentUser.dateOfBirth),
                              ),
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  Fmt.upper(l10n.profileYourRecords),
                  style: AppTypography.eyebrow,
                ),
                const SizedBox(height: AppSpacing.xs),
                _SheetGroup(
                  children: [
                    _SheetItem(
                      icon: Icons.calendar_month_outlined,
                      title: l10n.profileCycleHistory,
                      subtitle: l10n.profileCycleHistorySubtitle,
                      onTap: () => go(() => context.push('/cycles')),
                    ),
                    _SheetItem(
                      icon: Icons.edit_note_outlined,
                      title: l10n.profileLogHistory,
                      subtitle: l10n.profileLogHistorySubtitle,
                      onTap: () => go(() => context.go('/daily-logs')),
                    ),
                    _SheetItem(
                      icon: Icons.menu_book_outlined,
                      title: l10n.profileLearn,
                      subtitle: l10n.profileLearnSubtitle,
                      onTap: () => go(() => context.push('/learn')),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _SheetGroup(
                  children: [
                    _SheetItem(
                      icon: Icons.logout,
                      title: l10n.profileSignOut,
                      color: AppColors.error,
                      onTap: () async {
                        Navigator.of(sheetContext).pop();
                        await ref.read(authProvider.notifier).logout();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, required this.size});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.lavenderSoft,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: 1.5),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.lavenderDeep,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.36,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _SheetGroup extends StatelessWidget {
  const _SheetGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgRadius,
        side: const BorderSide(color: AppColors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(indent: AppSpacing.xxxl + AppSpacing.xs),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  const _SheetItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.color,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      leading: Icon(icon, color: color ?? AppColors.textSecondary, size: 22),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: color == null
          ? const Icon(Icons.chevron_right, color: AppColors.textFaint)
          : null,
      onTap: onTap,
    );
  }
}
