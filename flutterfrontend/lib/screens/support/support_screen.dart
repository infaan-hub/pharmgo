import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  final _faqs = [
    {
      'question': 'How do I upload a prescription?',
      'answer':
          'Go to the Upload Prescription screen, take a photo or select from gallery, and submit. Our team will verify it within 24 hours.',
      'isExpanded': false,
    },
    {
      'question': 'How long does delivery take?',
      'answer':
          'Standard delivery takes 1-2 business days. Express delivery is available for same-day delivery in select areas.',
      'isExpanded': false,
    },
    {
      'question': 'Can I cancel my order?',
      'answer':
          'You can cancel your order before it\'s confirmed. Once confirmed, please contact support for assistance.',
      'isExpanded': false,
    },
    {
      'question': 'How do I return a product?',
      'answer':
          'Unopened medicines can be returned within 7 days. Please contact our support team to initiate a return.',
      'isExpanded': false,
    },
    {
      'question': 'Is my personal information secure?',
      'answer':
          'Yes, we use industry-standard encryption to protect your personal and medical information.',
      'isExpanded': false,
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _messageController.text.isNotEmpty) {
      setState(() => _isSubmitting = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message sent successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
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
            ..._faqs.asMap().entries.map((entry) {
              return _buildFaqItem(entry.key, entry.value);
            }),
            const SizedBox(height: 32),
            Text('Send a Message', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Name',
              hint: 'Your name',
              controller: _nameController,
              prefix: const Icon(Icons.person_outline, size: 20),
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Email',
              hint: 'Your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefix: const Icon(Icons.email_outlined, size: 20),
            ),
            const SizedBox(height: 12),
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

  Widget _buildFaqItem(int index, Map<String, dynamic> faq) {
    final isExpanded = faq['isExpanded'] as bool;
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
          faq['question'] as String,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: AppColors.textSecondary,
        ),
        onExpansionChanged: (expanded) {
          setState(() => _faqs[index]['isExpanded'] = expanded);
        },
        children: [
          Text(
            faq['answer'] as String,
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
