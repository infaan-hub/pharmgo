import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routing/app_router.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/empty_state.dart';
import '../../providers/address_provider.dart';
import '../../models/address.dart';

class AddressListScreen extends ConsumerStatefulWidget {
  const AddressListScreen({super.key});

  @override
  ConsumerState<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends ConsumerState<AddressListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addressListProvider.notifier).loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'My Addresses',
        actions: [
          IconButton(
            onPressed: () => context.go(AppRouter.addressForm),
            icon: const Icon(Icons.add, size: 24),
          ),
        ],
      ),
      body: addressState.addresses.isEmpty && !addressState.isLoading
          ? const EmptyState(
              icon: Icons.location_on_outlined,
              title: 'No addresses saved',
              subtitle: 'Add a new address for delivery',
              buttonText: 'Add Address',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: addressState.addresses.length,
              itemBuilder: (context, index) {
                return _buildAddressCard(addressState.addresses[index]);
              },
            ),
    );
  }

  Widget _buildAddressCard(Address address) {
    final icons = {
      'Home': Icons.home_outlined,
      'Office': Icons.work_outline,
      'Other': Icons.location_on_outlined,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: address.isDefault ? AppColors.primaryDark : AppColors.divider,
          width: address.isDefault ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: address.isDefault
                  ? AppColors.primaryDark.withOpacity(0.1)
                  : AppColors.cardSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icons[address.label] ?? Icons.location_on_outlined,
              color: address.isDefault ? AppColors.primaryDark : AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(address.label, style: AppTextStyles.titleSmall),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address.fullAddress,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${address.fullName} • ${address.phone}',
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18),
            onSelected: (value) {
              if (value == 'edit') {
                context.go(AppRouter.addressForm);
              } else if (value == 'delete') {
                ref.read(addressListProvider.notifier).deleteAddress(address.id);
              } else if (value == 'default') {
                ref.read(addressListProvider.notifier).setDefault(address.id);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              if (!address.isDefault)
                const PopupMenuItem(value: 'default', child: Text('Set as Default')),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
