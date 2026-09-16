import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;

  const AppBarWidget({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBackPressed,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.background,
      elevation: 0,
      centerTitle: centerTitle,
      leading: showBack
          ? IconButton(
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.chevron_left,
                color: AppColors.textPrimary,
                size: 28,
              ),
            )
          : null,
      title: Text(
        title,
        style: AppTextStyles.titleLarge,
      ),
      actions: actions,
    );
  }
}
