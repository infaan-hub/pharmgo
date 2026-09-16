import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_text_field.dart';
import '../../providers/address_provider.dart';

class AddressFormScreen extends ConsumerStatefulWidget {
  const AddressFormScreen({super.key});

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController(text: 'Home');
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  bool _isDefault = false;
  String _selectedLabel = 'Home';

  @override
  void dispose() {
    _labelController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _apartmentController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      ref.read(addressListProvider.notifier).addAddress(
            label: _selectedLabel,
            fullName: _fullNameController.text.trim(),
            phone: _phoneController.text.trim(),
            street: _streetController.text.trim(),
            apartment: _apartmentController.text.isNotEmpty
                ? _apartmentController.text.trim()
                : null,
            city: _cityController.text.trim(),
            stateValue: _stateController.text.trim(),
            zipCode: _zipController.text.trim(),
            isDefault: _isDefault,
          );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Add Address'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Address Label', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: ['Home', 'Office', 'Other'].map((label) {
                  final isSelected = _selectedLabel == label;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _selectedLabel = label;
                        _labelController.text = label;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryDark
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.divider,
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Full Name',
                hint: 'Enter full name',
                controller: _fullNameController,
                prefix: const Icon(Icons.person_outline, size: 20),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Phone Number',
                hint: 'Enter phone number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefix: const Icon(Icons.phone_outlined, size: 20),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Street Address',
                hint: 'Enter street address',
                controller: _streetController,
                prefix: const Icon(Icons.home_outlined, size: 20),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Apartment / Suite (Optional)',
                hint: 'Apartment, suite, floor, etc.',
                controller: _apartmentController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'City',
                hint: 'Enter city',
                controller: _cityController,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'State',
                      hint: 'State',
                      controller: _stateController,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: 'ZIP Code',
                      hint: 'ZIP',
                      controller: _zipController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: (v) => setState(() => _isDefault = v ?? false),
                    activeColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Text(
                    'Set as default address',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Save Address',
                onPressed: _saveAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
