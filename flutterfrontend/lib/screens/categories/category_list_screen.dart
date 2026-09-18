import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_state.dart';
import '../../providers/medicine_provider.dart';
import '../../models/category.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Categories'),
      body: categoriesAsync.when(
        data: (categories) => _buildCategories(context, categories),
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorState(
          message: e.toString(),
          buttonText: 'Retry',
          onRetry: () => ref.invalidate(categoryListProvider),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, List<Category> categories) {
    final displayCategories = categories.isNotEmpty
        ? categories
        : [
            Category(id: 1, name: 'Prescription', slug: 'prescription', icon: 'prescription'),
            Category(id: 2, name: 'OTC', slug: 'otc', icon: 'otc'),
            Category(id: 3, name: 'Vitamins', slug: 'vitamins', icon: 'vitamins'),
            Category(id: 4, name: 'Personal Care', slug: 'personal-care', icon: 'personal_care'),
            Category(id: 5, name: 'Baby Care', slug: 'baby-care', icon: 'baby_care'),
            Category(id: 6, name: 'Diabetes', slug: 'diabetes', icon: 'diabetes'),
            Category(id: 7, name: 'Heart Care', slug: 'heart-care', icon: 'heart'),
            Category(id: 8, name: 'Ayurveda', slug: 'ayurveda', icon: 'ayurveda'),
          ];

    final icons = [
      Icons.receipt_long,
      Icons.medication,
      Icons.local_fire_department,
      Icons.spa,
      Icons.child_care,
      Icons.bloodtype,
      Icons.favorite,
      Icons.eco,
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: displayCategories.length,
      itemBuilder: (context, index) {
        final category = displayCategories[index];
        final icon = icons[index % icons.length];
        return GestureDetector(
          onTap: () => context.go('/categories/${category.id}/medicines'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider, width: 0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.cardSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primaryDark, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  category.name,
                  style: AppTextStyles.titleSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  '${category.medicineCount} items',
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
