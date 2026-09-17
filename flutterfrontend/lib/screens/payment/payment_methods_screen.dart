import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';
import '../../services/payment_service.dart';
import '../../models/payment_method.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final PaymentService _paymentService = PaymentService();
  List<PaymentMethod> _methods = [];
  String? _selectedMethodId;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final methods = await _paymentService.getPaymentMethods();
      setState(() {
        _methods = methods;
        _selectedMethodId = methods.where((m) => m.isDefault).firstOrNull?.id.toString();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Payment Methods'),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: LoadingWidget());
    }

    if (_error != null) {
      return Center(
        child: EmptyState(
          icon: Icons.error_outline,
          title: 'Error loading payment methods',
          subtitle: _error!,
          actionText: 'Retry',
          onAction: _loadPaymentMethods,
        ),
      );
    }

    if (_methods.isEmpty) {
      return const EmptyState(
        icon: Icons.credit_card_outlined,
        title: 'No payment methods',
        subtitle: 'Add a card to get started',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPaymentMethods,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _methods.length,
        itemBuilder: (context, index) {
          final method = _methods[index];
          return _buildPaymentCard(method);
        },
      ),
    );
  }

  Widget _buildPaymentCard(PaymentMethod method) {
    final isSelected = _selectedMethodId == method.id.toString();
    return GestureDetector(
      onTap: () => setState(() => _selectedMethodId = method.id.toString()),
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
                  method.cardType.substring(0, 1).toUpperCase(),
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
                    '${method.cardType.toUpperCase()} •••• ${method.lastFour}',
                    style: AppTextStyles.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Expires ${method.expiryMonth.toString().padLeft(2, '0')}/${method.expiryYear.toString().substring(2)}',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: method.id.toString(),
              groupValue: _selectedMethodId,
              onChanged: (v) => setState(() => _selectedMethodId = v),
              activeColor: AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardSheet() {
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final nameController = TextEditingController();

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
            _buildBottomSheetField('Card Number', '1234 5678 9012 3456', cardNumberController),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildBottomSheetField('MM/YY', '12/26', expiryController),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBottomSheetField('CVV', '123', cvvController),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBottomSheetField('Name on Card', 'John Doe', nameController),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Add Card',
              onPressed: () async {
                if (cardNumberController.text.isEmpty ||
                    expiryController.text.isEmpty ||
                    nameController.text.isEmpty) {
                  return;
                }

                try {
                  final expiryParts = expiryController.text.split('/');
                  await _paymentService.addPaymentMethod(
                    cardType: 'visa',
                    lastFour: cardNumberController.text.substring(
                        cardNumberController.text.length - 4),
                    cardholderName: nameController.text,
                    expiryMonth: expiryParts[0],
                    expiryYear: '20${expiryParts[1]}',
                  );
                  Navigator.pop(context);
                  _loadPaymentMethods();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetField(String label, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
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
