import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';
import '../../providers/order_provider.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderDetailProvider(widget.orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Track Order'),
      body: orderAsync.when(
        loading: () => const Center(child: LoadingWidget()),
        error: (e, _) => Center(
          child: EmptyState(
            icon: Icons.error_outline,
            title: 'Error loading order',
            subtitle: e.toString(),
            actionText: 'Retry',
            onAction: () => setState(() {}),
          ),
        ),
        data: (order) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderHeader(order),
                const SizedBox(height: 32),
                Text('Order Status', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 24),
                _buildTrackingTimeline(order.status),
                const SizedBox(height: 32),
                _buildDeliveryInfo(order),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderHeader(dynamic order) {
    return Container(
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
            'Order #${order.id}',
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Estimated delivery: ${_getEstimatedDelivery(order.status)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(String status) {
    final steps = [
      {'title': 'Order Placed', 'icon': Icons.shopping_cart, 'status': 'placed'},
      {'title': 'Confirmed', 'icon': Icons.check_circle, 'status': 'confirmed'},
      {'title': 'Verifying', 'icon': Icons.verified, 'status': 'verifying'},
      {'title': 'Out for Delivery', 'icon': Icons.local_shipping, 'status': 'out_for_delivery'},
      {'title': 'Delivered', 'icon': Icons.home, 'status': 'delivered'},
    ];

    final statusOrder = ['placed', 'confirmed', 'verifying', 'out_for_delivery', 'delivered'];
    final currentIndex = statusOrder.indexOf(status);

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;

        return Column(
          children: [
            _buildTrackingStep(
              step['title'] as String,
              step['icon'] as IconData,
              isCompleted,
              isCurrent,
            ),
            if (index < steps.length - 1) _buildTrackingLine(isCompleted),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTrackingStep(
    String title,
    IconData icon,
    bool isCompleted,
    bool isCurrent,
  ) {
    final color = isCompleted ? AppColors.success : AppColors.divider;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(color: AppColors.primaryDark, width: 2)
                : null,
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

  Widget _buildDeliveryInfo(dynamic order) {
    return Container(
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
                  'Assigned after confirmation',
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
    );
  }

  String _getEstimatedDelivery(String status) {
    switch (status) {
      case 'placed':
        return '2-3 business days';
      case 'confirmed':
        return '1-2 business days';
      case 'verifying':
        return '1 business day';
      case 'out_for_delivery':
        return 'Today';
      case 'delivered':
        return 'Delivered';
      default:
        return 'Calculating...';
    }
  }
}
