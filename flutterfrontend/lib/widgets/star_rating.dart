import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const StarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16,
    this.activeColor = AppColors.success,
    this.inactiveColor = AppColors.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starValue = index + 1;
        if (starValue <= rating.floor()) {
          return Icon(Icons.star, color: activeColor, size: size);
        } else if (starValue - 0.5 <= rating) {
          return Icon(Icons.star_half, color: activeColor, size: size);
        } else {
          return Icon(Icons.star_border, color: inactiveColor, size: size);
        }
      }),
    );
  }
}
