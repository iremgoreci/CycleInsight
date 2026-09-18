import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../data/models/user.dart';
import '../state/auth_provider.dart';

/// Fixed top-right profile/account entry point, reused on every top-level
/// screen (shell tabs, Learn, Cycle history, Daily log form, ...).
///
/// There is no dedicated profile route yet, so this opens a light account
/// sheet on top of the existing auth state instead of introducing new
/// backend/business logic.
class ProfileButton extends ConsumerWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return InkWell(
      onTap: () => _showAccountSheet(context, ref),
      customBorder: const CircleBorder(),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.blush,
          shape: BoxShape.circle,
        ),
        child: Text(
          _initials(user),
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
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
    final initials = '$first$last'.toUpperCase();
    return initials.isEmpty ? '?' : initials;
  }

  static Future<void> _showAccountSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final currentUser = ref.read(authProvider).user;
        final fullName = currentUser == null
            ? ''
            : '${currentUser.firstName} ${currentUser.lastName}';

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xxs,
              AppSpacing.xl,
              AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.blush,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        _initials(currentUser),
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            fullName.trim().isEmpty ? 'Account' : fullName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (currentUser?.email != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              currentUser!.email,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const Divider(),
                const SizedBox(height: AppSpacing.xxs),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.textSecondary,
                  ),
                  title: const Text('Manage cycles'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.push('/cycles');
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: const Text(
                    'Sign out',
                    style: TextStyle(color: AppColors.error),
                  ),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await ref.read(authProvider.notifier).logout();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
