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
import '../../providers/cart_provider.dart';
import '../../providers/address_provider.dart';
import '../../models/cart.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addressListProvider.notifier).loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final addressState = ref.watch(addressListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Checkout'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            ...cart.items.map((item) => _buildOrderItem(item)),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Shipping Address',
              icon: Icons.location_on_outlined,
              onTap: () => context.go(AppRouter.addresses),
              child: addressState.defaultAddress != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addressState.defaultAddress!.displayLabel,
                          style: AppTextStyles.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          addressState.defaultAddress!.fullAddress,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    )
                  : Text(
                      'Add a shipping address',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Payment Method',
              icon: Icons.credit_card_outlined,
              onTap: () => context.go(AppRouter.paymentMethods),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'VISA',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '•••• •••• •••• 4242',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Price Details', style: AppTextStyles.titleMedium),
            const SizedBox(height: 12),
            _buildSummaryRow('Subtotal', Formatters.formatCurrency(cart.subtotal)),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Delivery',
              cart.deliveryFee == 0
                  ? 'FREE'
                  : Formatters.formatCurrency(cart.deliveryFee),
              valueColor: cart.deliveryFee == 0 ? AppColors.success : null,
            ),
            if (cart.discount > 0) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                'Discount',
                '-${Formatters.formatCurrency(cart.discount)}',
                valueColor: AppColors.success,
              ),
            ],
            const Divider(color: AppColors.divider),
            _buildSummaryRow(
              'Total',
              Formatters.formatCurrency(cart.total),
              isBold: true,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Place Order - ${Formatters.formatCurrency(cart.total)}',
              onPressed: () => context.go(AppRouter.orderConfirmation),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'SECURE CHECKOUT',
                  style: AppTextStyles.microLabel.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Row(
        children: [
          ProductImage(
            imageUrl: item.medicine!.imageUrl,
            width: 56,
            height: 56,
            borderRadius: 10,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.medicine!.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.selectedDosage ?? '',
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.formatCurrency(item.totalPrice),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Qty: ${item.quantity}',
                style: AppTextStyles.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryDark, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  child,
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
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
          Text(
            label,
            style: isBold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium,
          ),
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
