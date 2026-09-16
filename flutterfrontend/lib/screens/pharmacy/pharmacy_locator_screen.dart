import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/loading_widget.dart';

class PharmacyLocatorScreen extends StatefulWidget {
  const PharmacyLocatorScreen({super.key});

  @override
  State<PharmacyLocatorScreen> createState() => _PharmacyLocatorScreenState();
}

class _PharmacyLocatorScreenState extends State<PharmacyLocatorScreen> {
  final _searchController = TextEditingController();
  final _pharmacies = [
    {
      'name': 'PharmGo Central Pharmacy',
      'address': '123 Health Street, Medical District',
      'distance': '0.5 km',
      'rating': 4.8,
      'isOpen': true,
    },
    {
      'name': 'City Health Pharmacy',
      'address': '456 Wellness Ave, Downtown',
      'distance': '1.2 km',
      'rating': 4.6,
      'isOpen': true,
    },
    {
      'name': 'MedPlus Pharmacy',
      'address': '789 Care Boulevard, Westside',
      'distance': '2.1 km',
      'rating': 4.4,
      'isOpen': false,
    },
    {
      'name': 'HealthFirst Drugs',
      'address': '321 Pharmacy Lane, East End',
      'distance': '2.8 km',
      'rating': 4.7,
      'isOpen': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Nearby Pharmacies'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: TextField(
              controller: _searchController,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search pharmacies...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _pharmacies.length,
              itemBuilder: (context, index) {
                return _buildPharmacyCard(_pharmacies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyCard(Map<String, dynamic> pharmacy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_pharmacy,
              color: AppColors.primaryDark,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pharmacy['name'] as String,
                        style: AppTextStyles.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (pharmacy['isOpen'] as bool)
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (pharmacy['isOpen'] as bool) ? 'Open' : 'Closed',
                        style: TextStyle(
                          color: (pharmacy['isOpen'] as bool)
                              ? AppColors.success
                              : AppColors.error,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  pharmacy['address'] as String,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFFF4B41B)),
                    const SizedBox(width: 4),
                    Text(
                      '${pharmacy['rating']}',
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pharmacy['distance'] as String,
                      style: AppTextStyles.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
