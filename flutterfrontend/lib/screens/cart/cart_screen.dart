import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/breakpoints.dart';
import '../../core/routing/app_router.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/quantity_stepper.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_image.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).loadCart();
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final isDesktop = Breakpoints.isDesktop(context);
    final isTablet = Breakpoints.isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'My Cart (${cart.itemCount})',
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              onPressed: () => _showClearCartDialog(),
              icon: const Icon(Icons.delete_outline, size: 22),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              subtitle: 'Add medicines to get started',
              buttonText: 'Browse Medicines',
            )
          : (isDesktop || isTablet)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ListView.separated(
                        padding: EdgeInsets.all(isDesktop ? 32 : 20),
                        itemCount: cart.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _buildCartItem(cart.items[index]);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 360,
                      child: _buildCartSummary(cart),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: cart.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _buildCartItem(cart.items[index]);
                        },
                      ),
                    ),
                    _buildCartSummary(cart),
                  ],
                ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Row(
        children: [
          ProductImage(
            imageUrl: item.medicine!.imageUrl,
            width: 64,
            height: 64,
            borderRadius: 12,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.medicine!.name,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.selectedDosage ?? '',
                  style: AppTextStyles.labelSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  Formatters.formatCurrency(item.totalPrice),
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(cartProvider.notifier).removeItem(item.medicine!.id);
                },
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              QuantityStepper(
                quantity: item.quantity,
                compact: true,
                onIncrement: item.canIncrement
                    ? () => ref.read(cartProvider.notifier).updateQuantity(
                          item.medicine!.id,
                          item.quantity + 1,
                        )
                    : null,
                onDecrement: item.canDecrement
                    ? () => ref.read(cartProvider.notifier).updateQuantity(
                          item.medicine!.id,
                          item.quantity - 1,
                        )
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(Cart cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.cardSurfaceAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer_outlined, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    style: AppTextStyles.bodySmall,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      hintStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_promoController.text.isNotEmpty) {
                      ref.read(cartProvider.notifier).applyPromoCode(
                            _promoController.text,
                          );
                    }
                  },
                  child: Text(
                    'APPLY',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Proceed to Checkout',
            onPressed: () => context.go(AppRouter.checkout),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
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
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clear();
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
