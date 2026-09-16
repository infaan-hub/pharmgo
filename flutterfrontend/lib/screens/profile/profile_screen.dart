import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routing/app_router.dart';
import '../../widgets/app_bar_widget.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildProfileHeader(authState),
              const SizedBox(height: 32),
              _buildMenuSection([
                _MenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () => context.go(AppRouter.editProfile),
                ),
                _MenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'My Addresses',
                  onTap: () => context.go(AppRouter.addresses),
                ),
                _MenuItem(
                  icon: Icons.credit_card_outlined,
                  title: 'Payment Methods',
                  onTap: () => context.go(AppRouter.paymentMethods),
                ),
                _MenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'My Orders',
                  onTap: () => context.go(AppRouter.orderHistory),
                ),
                _MenuItem(
                  icon: Icons.favorite_outline,
                  title: 'Wishlist',
                  onTap: () => context.go(AppRouter.wishlist),
                ),
                _MenuItem(
                  icon: Icons.receipt_outlined,
                  title: 'Prescriptions',
                  onTap: () => context.go(AppRouter.prescription),
                ),
              ]),
              const SizedBox(height: 16),
              _buildMenuSection([
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () => context.go(AppRouter.notifications),
                ),
                _MenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => context.go(AppRouter.settings),
                ),
                _MenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () => context.go(AppRouter.support),
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  title: 'About PharmGo',
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    ref.read(authStateProvider.notifier).logout();
                    context.go(AppRouter.login);
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: Text(
                    'Log Out',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.error.withOpacity(0.05),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AuthState authState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                authState.user?.initials ?? 'U',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            authState.user?.fullName ?? 'User',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            authState.user?.email ?? '',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: AppColors.textPrimary, size: 22),
                title: Text(item.title, style: AppTextStyles.bodyMedium),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onTap: item.onTap,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
              ),
              if (!isLast)
                const Divider(height: 1, indent: 56, color: AppColors.divider),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
