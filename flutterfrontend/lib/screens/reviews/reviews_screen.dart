import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/star_rating.dart';
import '../../widgets/empty_state.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _reviewController = TextEditingController();
  final _reviews = [
    {
      'name': 'Sarah M.',
      'rating': 5,
      'comment': 'Great medicine, fast delivery! Highly recommended.',
      'date': '2 days ago',
    },
    {
      'name': 'John D.',
      'rating': 4,
      'comment': 'Good quality and reasonable prices. Will order again.',
      'date': '1 week ago',
    },
    {
      'name': 'Emily R.',
      'rating': 5,
      'comment': 'Excellent service. The pharmacist was very helpful.',
      'date': '2 weeks ago',
    },
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Reviews'),
      body: Column(
        children: [
          _buildRatingSummary(),
          Expanded(
            child: _reviews.isEmpty
                ? const EmptyState(
                    icon: Icons.reviews,
                    title: 'No reviews yet',
                    subtitle: 'Be the first to review',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _reviews.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildReviewCard(_reviews[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.white,
      child: Row(
        children: [
          Column(
            children: [
              const Text(
                '4.8',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const StarRating(rating: 4.8, size: 18),
              const SizedBox(height: 4),
              Text(
                '${_reviews.length} reviews',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final star = 5 - index;
                final width = star == 5
                    ? 1.0
                    : star == 4
                        ? 0.8
                        : star == 3
                            ? 0.5
                            : star == 2
                                ? 0.2
                                : 0.1;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: AppTextStyles.labelSmall,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: width,
                          backgroundColor: AppColors.divider,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.success,
                          ),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.cardSurface,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (review['name'] as String)[0],
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review['name'] as String, style: AppTextStyles.titleSmall),
                    StarRating(
                      rating: (review['rating'] as int).toDouble(),
                      size: 14,
                    ),
                  ],
                ),
              ),
              Text(review['date'] as String, style: AppTextStyles.labelSmall),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'] as String,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
