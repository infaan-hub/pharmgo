import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../widgets/quantity_stepper.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/star_rating.dart';
import '../../widgets/product_image.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_state.dart';
import '../../providers/medicine_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/medicine.dart';

class MedicineDetailScreen extends ConsumerStatefulWidget {
  final String medicineId;

  const MedicineDetailScreen({super.key, required this.medicineId});

  @override
  ConsumerState<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends ConsumerState<MedicineDetailScreen> {
  int _quantity = 1;
  String? _selectedDosage;
  bool _isExpandedUses = false;
  bool _isExpandedSideEffects = false;
  bool _isExpandedIngredients = false;

  @override
  Widget build(BuildContext context) {
    final medicineAsync = ref.watch(medicineDetailProvider(int.tryParse(widget.medicineId) ?? 0));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: medicineAsync.when(
        data: (medicine) => _buildDetail(context, medicine),
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorState(
          message: e.toString(),
          buttonText: 'Retry',
          onRetry: () => ref.invalidate(medicineDetailProvider(int.tryParse(widget.medicineId) ?? 0)),
        ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, Medicine medicine) {
    if (_selectedDosage == null && medicine.dosageOptions.isNotEmpty) {
      _selectedDosage = medicine.dosageOptions.first;
    } else if (_selectedDosage == null) {
      _selectedDosage = medicine.dosage;
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ProductImage(
                      imageUrl: medicine.imageUrl,
                      width: double.infinity,
                      height: 280,
                      borderRadius: 0,
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 12,
                      child: _buildCircleButton(
                        Icons.chevron_left,
                        () => context.pop(),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      right: 12,
                      child: _buildCircleButton(
                        medicine.isFavorite ? Icons.favorite : Icons.favorite_border,
                        () {},
                        isFavorite: medicine.isFavorite,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(medicine.name, style: AppTextStyles.displaySmall),
                                const SizedBox(height: 4),
                                Text(
                                  medicine.manufacturer ?? '',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (medicine.requiresPrescription)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Rx Required',
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          StarRating(rating: medicine.rating),
                          const SizedBox(width: 8),
                          Text(
                            '${medicine.rating} (${medicine.reviewCount} reviews)',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            Formatters.formatCurrency(medicine.price),
                            style: AppTextStyles.displaySmall.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (medicine.hasDiscount) ...[
                            const SizedBox(width: 8),
                            Text(
                              Formatters.formatCurrency(medicine.originalPrice),
                              style: AppTextStyles.bodyMedium.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '-${medicine.discountPercent.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: AppColors.success,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (medicine.dosageOptions.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text('Select Dosage', style: AppTextStyles.titleMedium),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: medicine.dosageOptions.map((dosage) {
                            final isSelected = _selectedDosage == dosage;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedDosage = dosage),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryDark
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryDark
                                        : AppColors.divider,
                                  ),
                                ),
                                child: Text(
                                  dosage,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 24),
                      _buildExpandableSection(
                        'Uses',
                        medicine.uses,
                        _isExpandedUses,
                        () => setState(() => _isExpandedUses = !_isExpandedUses),
                      ),
                      const Divider(color: AppColors.divider),
                      _buildExpandableSection(
                        'Side Effects',
                        medicine.sideEffects,
                        _isExpandedSideEffects,
                        () => setState(
                            () => _isExpandedSideEffects = !_isExpandedSideEffects),
                      ),
                      const Divider(color: AppColors.divider),
                      _buildExpandableSection(
                        'Ingredients',
                        medicine.ingredients,
                        _isExpandedIngredients,
                        () => setState(
                            () => _isExpandedIngredients = !_isExpandedIngredients),
                      ),
                      const SizedBox(height: 24),
                      Text('Related Products', style: AppTextStyles.headlineMedium),
                      const SizedBox(height: 12),
                      _buildRelatedProducts(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildBottomBar(medicine),
      ],
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap, {bool isFavorite = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isFavorite ? AppColors.error : AppColors.textPrimary,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title, String content, bool isExpanded, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.titleMedium),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 8),
              Text(
                content,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedProducts() {
    final relatedAsync = ref.watch(relatedMedicinesProvider(int.tryParse(widget.medicineId) ?? 0));
    return relatedAsync.when(
      data: (medicines) {
        if (medicines.isEmpty) return const SizedBox();
        return SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: medicines.length.clamp(0, 6),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final med = medicines[index];
              return GestureDetector(
                onTap: () => context.go('/medicine/${med.id}'),
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 70,
                        decoration: const BoxDecoration(
                          color: AppColors.cardSurface,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.medication_outlined,
                            color: AppColors.textSecondary,
                            size: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              med.name,
                              style: AppTextStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              Formatters.formatCurrency(med.price),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 160, child: LoadingWidget()),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildBottomBar(Medicine medicine) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            QuantityStepper(
              quantity: _quantity,
              onIncrement: _quantity < 10
                  ? () => setState(() => _quantity++)
                  : null,
              onDecrement: _quantity > 1
                  ? () => setState(() => _quantity--)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                text: 'Add to Cart - ${Formatters.formatCurrency(medicine.price * _quantity)}',
                onPressed: () {
                  ref.read(cartProvider.notifier).addToCart(
                        medicineId: medicine.id,
                        quantity: _quantity,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to cart'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
