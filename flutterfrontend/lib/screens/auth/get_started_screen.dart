import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routing/app_router.dart';
import '../../widgets/primary_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_pharmacy,
                  color: AppColors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'PHARMGO',
                style: AppTextStyles.displayLarge.copyWith(
                  letterSpacing: 4,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'HEALTH & CARE',
                style: AppTextStyles.microLabel.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Your trusted partner\nfor all healthcare needs',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              PrimaryButton(
                text: 'Create Account',
                onPressed: () => context.go(AppRouter.signup),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRouter.login),
                    child: Text(
                      'Log In',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
