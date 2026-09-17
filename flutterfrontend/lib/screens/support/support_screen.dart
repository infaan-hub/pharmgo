import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';
import '../../services/support_service.dart';
import '../../models/faq.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final SupportService _supportService = SupportService();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  List<Faq> _faqs = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadFaqs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final faqs = await _supportService.getFaqs();
      setState(() {
        _faqs = faqs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _submitForm() async {
    if (_subjectController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await _supportService.submitSupportTicket(
        subject: _subjectController.text,
        message: _messageController.text,
      );
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message sent successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        _subjectController.clear();
        _messageController.clear();
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Help & Support'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Us', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _buildContactOptions(),
            const SizedBox(height: 32),
            Text('Frequently Asked Questions', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _buildFaqsSection(),
            const SizedBox(height: 32),
            Text('Send a Message', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Subject',
              hint: 'Subject',
              controller: _subjectController,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Message',
              hint: 'How can we help?',
              controller: _messageController,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Send Message',
              isLoading: _isSubmitting,
              onPressed: _submitForm,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqsSection() {
    if (_isLoading) {
      return const Center(child: LoadingWidget());
    }

    if (_error != null) {
      return Center(
        child: EmptyState(
          icon: Icons.error_outline,
          title: 'Error loading FAQs',
          subtitle: _error!,
          actionText: 'Retry',
          onAction: _loadFaqs,
        ),
      );
    }

    if (_faqs.isEmpty) {
      return const EmptyState(
        icon: Icons.help_outline,
        title: 'No FAQs available',
        subtitle: 'Check back later',
      );
    }

    return Column(
      children: _faqs.asMap().entries.map((entry) {
        return _buildFaqItem(entry.value);
      }).toList(),
    );
  }

  Widget _buildContactOptions() {
    return Row(
      children: [
        Expanded(
          child: _buildContactCard(
            Icons.phone,
            'Call Us',
            '+1 (800) 555-0123',
            () => launchUrl(Uri.parse('tel:+18005550123')),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildContactCard(
            Icons.email,
            'Email',
            'support@pharmgo.com',
            () => launchUrl(Uri.parse('mailto:support@pharmgo.com')),
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.primaryDark,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.white, size: 22),
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.titleSmall),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(Faq faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          faq.question,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        children: [
          Text(
            faq.answer,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
