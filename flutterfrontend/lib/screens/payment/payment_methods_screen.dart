import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/primary_button.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedMethod = 'visa_4242';
  final _methods = [
    {'id': 'visa_4242', 'brand': 'Visa', 'last4': '4242', 'expiry': '12/26'},
    {'id': 'master_8888', 'brand': 'Mastercard', 'last4': '8888', 'expiry': '06/25'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Payment Methods'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _methods.length,
              itemBuilder: (context, index) {
                final method = _methods[index];
                return _buildPaymentCard(method);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: PrimaryButton(
              text: 'Add New Card',
              backgroundColor: AppColors.white,
              textColor: AppColors.primaryDark,
              onPressed: () => _showAddCardSheet(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, String> method) {
    final isSelected = _selectedMethod == (method['id'] ?? '');
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method['id'] ?? ''),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.divider,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  method['brand']!.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${method['brand']} •••• ${method['last4']}',
                    style: AppTextStyles.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Expires ${method['expiry']}',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: method['id']!,
              groupValue: _selectedMethod,
              onChanged: (v) => setState(() => _selectedMethod = v!),
              activeColor: AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Add New Card', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 24),
            _buildBottomSheetField('Card Number', '1234 5678 9012 3456'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildBottomSheetField('MM/YY', '12/26'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBottomSheetField('CVV', '123'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBottomSheetField('Name on Card', 'John Doe'),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Add Card',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetField(String label, String hint) {
    return TextField(
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTextStyles.labelMedium,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.cardSurfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
        ),
      ),
    );
  }
}
