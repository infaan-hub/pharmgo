import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.message,
    this.buttonText,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onRetry != null) ...[
              const SizedBox(height: 24),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  buttonText!.toUpperCase(),
                  style: AppTextStyles.buttonText.copyWith(fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
