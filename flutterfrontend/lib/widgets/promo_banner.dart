import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class PromoBanner extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonTap;
  final Color? backgroundColor;
  final IconData? icon;

  const PromoBanner({
    super.key,
    this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonTap,
    this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.white, size: 32),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (buttonText != null)
            TextButton(
              onPressed: onButtonTap,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                buttonText!.toUpperCase(),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
