import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/routing/app_router.dart';

class NavRail extends StatelessWidget {
  final int selectedIndex;

  const NavRail({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: AppColors.white,
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'PG',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 32),
          _NavRailItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            isSelected: selectedIndex == 0,
            onTap: () => context.go(AppRouter.home),
          ),
          _NavRailItem(
            icon: Icons.store_outlined,
            activeIcon: Icons.store,
            label: 'Shop',
            isSelected: selectedIndex == 1,
            onTap: () => context.go(AppRouter.categories),
          ),
          _NavRailItem(
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long,
            label: 'Orders',
            isSelected: selectedIndex == 2,
            onTap: () => context.go(AppRouter.orderHistory),
          ),
          _NavRailItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profile',
            isSelected: selectedIndex == 3,
            onTap: () => context.go(AppRouter.profile),
          ),
          const Spacer(),
          _NavRailItem(
            icon: Icons.notifications_outlined,
            activeIcon: Icons.notifications,
            label: 'Alerts',
            isSelected: false,
            onTap: () => context.go(AppRouter.notifications),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _NavRailItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavRailItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryDark.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
