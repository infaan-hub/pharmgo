import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_image.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final _wishlist = [
    {
      'id': '1',
      'name': 'Vitamin D3',
      'manufacturer': 'HealthPlus',
      'price': 12.99,
      'dosage': '1000 IU',
    },
    {
      'id': '2',
      'name': 'Omega-3 Fish Oil',
      'manufacturer': 'NatureCare',
      'price': 24.99,
      'dosage': '1000mg',
    },
    {
      'id': '3',
      'name': 'Probiotics',
      'manufacturer': 'GutHealth',
      'price': 19.99,
      'dosage': '50B CFU',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Wishlist'),
      body: _wishlist.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_outline,
              title: 'Wishlist is empty',
              subtitle: 'Save your favorite medicines here',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _wishlist.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildWishlistItem(_wishlist[index]);
              },
            ),
    );
  }

  Widget _buildWishlistItem(Map<String, dynamic> item) {
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
            imageUrl: null,
            width: 64,
            height: 64,
            borderRadius: 12,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'] as String, style: AppTextStyles.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '${item['manufacturer']} • ${item['dosage']}',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  Formatters.formatCurrency(item['price'] as double),
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
              IconButton(
                onPressed: () {
                  setState(() => _wishlist.remove(item));
                },
                icon: const Icon(
                  Icons.favorite,
                  color: AppColors.error,
                  size: 22,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'ADD',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
