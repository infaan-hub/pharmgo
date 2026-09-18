import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routing/app_router.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_text_field.dart';
import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _authService.resetPassword(_usernameController.text.trim());
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _emailSent ? _buildSuccessState() : _buildFormState(),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          IconButton(
            onPressed: () => context.go(AppRouter.login),
            icon: const Icon(Icons.chevron_left, size: 28),
          ),
          const SizedBox(height: 16),
          Text('Forgot Password', style: AppTextStyles.displayMedium),
          const SizedBox(height: 8),
          Text(
            "Enter your username and we'll send a verification code to your saved contact.",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.lock_reset,
              color: AppColors.primaryDark,
              size: 48,
            ),
          ),
          const SizedBox(height: 32),
          AppTextField(
            label: 'Email Address',
            hint: 'Enter your username',
            controller: _usernameController,
            prefix: const Icon(Icons.person_outline, size: 20),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              if (!RegExp(r'^[a-z0-9_]{4,20}$').hasMatch(value)) return 'Enter a valid username';
              return null;
            },
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Send Reset Link',
            isLoading: _isLoading,
            onPressed: _sendResetEmail,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        IconButton(
          onPressed: () => context.go(AppRouter.login),
          icon: const Icon(Icons.chevron_left, size: 28),
        ),
        const SizedBox(height: 40),
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: AppColors.white, size: 40),
        ),
        const SizedBox(height: 24),
        Text('Email Sent!', style: AppTextStyles.displaySmall),
        const SizedBox(height: 12),
        Text(
          'We\'ve sent a verification code for\n${_usernameController.text}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          text: 'Enter Verification Code',
          onPressed: () => context.go(AppRouter.otp),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _sendResetEmail,
          child: Text(
            'Resend Email',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
