import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/routing/app_router.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/product_image.dart';
import '../../widgets/loading_widget.dart';
import '../../providers/order_provider.dart';
import '../../models/order.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Order Details'),
      body: orderAsync.when(
        data: (order) => _buildOrderDetails(context, order),
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, Order order) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order #${order.orderNumber}', style: AppTextStyles.titleLarge),
                    Text(
                      order.statusLabel,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatDateTime(order.createdAt),
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Items', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 12),
          ...order.items.map((item) => _buildOrderItem(item)),
          const SizedBox(height: 20),
          Text('Shipping Address', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider, width: 0.5),
            ),
            child: Text(order.shippingAddress ?? '', style: AppTextStyles.bodyMedium),
          ),
          const SizedBox(height: 20),
          Text('Price Summary', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          _buildSummaryRow('Subtotal', Formatters.formatCurrency(order.subtotal)),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Delivery',
            order.deliveryFee == 0
                ? 'FREE'
                : Formatters.formatCurrency(order.deliveryFee),
            valueColor: order.deliveryFee == 0 ? AppColors.success : null,
          ),
          if (order.discount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Discount',
              '-${Formatters.formatCurrency(order.discount)}',
              valueColor: AppColors.success,
            ),
          ],
          const Divider(color: AppColors.divider),
          _buildSummaryRow(
            'Total',
            Formatters.formatCurrency(order.total),
            isBold: true,
          ),
          const SizedBox(height: 24),
          if (order.status != 'delivered' &&
              order.status != 'cancelled')
            PrimaryButton(
              text: 'Track Order',
              onPressed: () => context.go('/orders/${order.id}/tracking'),
            ),
          if (order.status == 'delivered') ...[
            PrimaryButton(
              text: 'Reorder',
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go(AppRouter.reviews),
              child: Text(
                'Write a Review',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Row(
        children: [
          ProductImage(
            imageUrl: item.medicine.imageUrl,
            width: 48,
            height: 48,
            borderRadius: 10,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.medicine.name, style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                )),
                Text(
                  '${item.selectedDosage} x ${item.quantity}',
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),
          Text(
            Formatters.formatCurrency(item.totalPrice),
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium),
          Text(
            value,
            style: (isBold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium)
                .copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
