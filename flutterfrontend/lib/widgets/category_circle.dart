import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class CategoryCircle extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  const CategoryCircle({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: AppColors.cardSurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryDark,
              size: size * 0.45,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: size + 16,
            child: Text(
              name,
              style: AppTextStyles.labelMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
