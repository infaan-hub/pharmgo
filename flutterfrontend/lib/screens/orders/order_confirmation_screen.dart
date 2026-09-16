import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routing/app_router.dart';
import '../../widgets/primary_button.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 56,
                ),
              ),
              const SizedBox(height: 32),
              Text('Order Placed!', style: AppTextStyles.displayMedium),
              const SizedBox(height: 12),
              Text(
                'Your order has been placed successfully.\nYou will receive a confirmation shortly.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      size: 18,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Order #PG-2024-001',
                      style: AppTextStyles.titleSmall,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              PrimaryButton(
                text: 'Track Order',
                onPressed: () => context.go(AppRouter.orderTracking),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go(AppRouter.home),
                child: Text(
                  'Continue Shopping',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
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
}
