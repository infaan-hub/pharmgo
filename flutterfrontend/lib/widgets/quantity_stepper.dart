import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final bool compact;

  const QuantityStepper({
    super.key,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = compact ? 28.0 : 32.0;
    final iconSize = compact ? 16.0 : 20.0;
    final textSize = compact ? 14.0 : 16.0;

    return Container(
      height: compact ? 32 : 36,
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: onDecrement != null ? AppColors.primaryDark : AppColors.divider,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.remove,
                color: AppColors.white,
                size: iconSize,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
            child: Text(
              '$quantity',
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: textSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: onIncrement != null ? AppColors.primaryDark : AppColors.divider,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: AppColors.white,
                size: iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
