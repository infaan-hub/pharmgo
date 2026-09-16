import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isExpanded;
  final double? width;
  final double? height;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.width,
    this.height,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: isExpanded ? double.infinity : width,
      height: height ?? 52,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryDark,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? AppColors.primaryDark).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        textColor ?? AppColors.white,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: textColor ?? AppColors.white, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text.toUpperCase(),
                        style: (textColor != null
                                ? AppTextStyles.buttonText.copyWith(color: textColor)
                                : AppTextStyles.buttonText)
                            .copyWith(letterSpacing: 1.2),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );

    return button;
  }
}
