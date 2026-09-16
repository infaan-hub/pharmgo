import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/loading_widget.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Track Order'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primaryDarkHover],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #PG-2024-001',
                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Estimated delivery: Today, 3:00 PM',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Order Status', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 24),
            _buildTrackingStep(
              'Order Confirmed',
              'Your order has been confirmed',
              Icons.check_circle,
              AppColors.success,
              true,
            ),
            _buildTrackingLine(true),
            _buildTrackingStep(
              'Processing',
              'Your medicines are being prepared',
              Icons.inventory_2_outlined,
              AppColors.success,
              true,
            ),
            _buildTrackingLine(true),
            _buildTrackingStep(
              'Out for Delivery',
              'Your order is on the way',
              Icons.local_shipping_outlined,
              AppColors.primaryDark,
              false,
            ),
            _buildTrackingLine(false),
            _buildTrackingStep(
              'Delivered',
              'Package delivered to your door',
              Icons.home_outlined,
              AppColors.divider,
              false,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider, width: 0.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.cardSurface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delivery Partner', style: AppTextStyles.titleSmall),
                        Text(
                          'Alex Johnson',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.phone, color: AppColors.primaryDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStep(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isCompleted,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleSmall.copyWith(
                  color: isCompleted ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingLine(bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(left: 19),
      width: 2,
      height: 32,
      color: isCompleted ? AppColors.primaryDark : AppColors.divider,
    );
  }
}
