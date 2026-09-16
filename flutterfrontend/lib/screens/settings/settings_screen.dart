import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _buildSwitchTile(
              'Push Notifications',
              'Receive push notifications for orders',
              _notificationsEnabled,
              (v) => setState(() => _notificationsEnabled = v),
            ),
            _buildSwitchTile(
              'Email Notifications',
              'Receive email updates about your orders',
              _emailNotifications,
              (v) => setState(() => _emailNotifications = v),
            ),
            _buildSwitchTile(
              'SMS Notifications',
              'Receive text message updates',
              _smsNotifications,
              (v) => setState(() => _smsNotifications = v),
            ),
            const SizedBox(height: 24),
            Text('Appearance', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _buildSwitchTile(
              'Dark Mode',
              'Switch between light and dark themes',
              _darkMode,
              (v) => setState(() => _darkMode = v),
            ),
            const SizedBox(height: 24),
            Text('Language', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _buildLanguageOption('English', true),
            _buildLanguageOption('Spanish', false),
            _buildLanguageOption('French', false),
            const SizedBox(height: 24),
            Text('Account', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _buildActionTile(
              Icons.lock_outline,
              'Change Password',
              () {},
            ),
            _buildActionTile(
              Icons.delete_outline,
              'Delete Account',
              () {},
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.white,
            activeTrackColor: AppColors.primaryDark,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryDark.withOpacity(0.1) : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryDark : AppColors.divider,
          width: isSelected ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            language,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (isSelected)
            const Icon(Icons.check, color: AppColors.primaryDark, size: 20),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColors.error : AppColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDestructive ? AppColors.error : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
