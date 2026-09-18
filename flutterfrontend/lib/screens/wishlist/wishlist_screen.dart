import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_image.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(wishlistProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Wishlist'),
      body: items.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text('Could not load saved items', style: AppTextStyles.bodyMedium)),
        data: (medicines) => medicines.isEmpty
            ? const EmptyState(icon: Icons.favorite_outline, title: 'Wishlist is empty', subtitle: 'Save your favorite medicines here')
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: medicines.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final medicine = medicines[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                    child: Row(children: [
                      ProductImage(imageUrl: medicine.image, width: 64, height: 64, borderRadius: 12),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(medicine.name, style: AppTextStyles.titleSmall),
                        Text('${medicine.manufacturer ?? ''} • ${medicine.dosage}', style: AppTextStyles.bodySmall),
                        Text(Formatters.formatCurrency(medicine.price), style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary)),
                      ])),
                      IconButton(
                        tooltip: 'Add to cart',
                        onPressed: () => ref.read(cartProvider.notifier).addToCart(medicineId: medicine.id),
                        icon: const Icon(Icons.add_shopping_cart_outlined, color: AppColors.primary),
                      ),
                    ]),
                  );
                },
              ),
      ),
    );
  }
}
