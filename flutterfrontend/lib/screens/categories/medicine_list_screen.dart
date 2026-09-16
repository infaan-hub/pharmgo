import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/medicine_card.dart';
import '../../widgets/filter_chip_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_state.dart';
import '../../widgets/empty_state.dart';
import '../../providers/medicine_provider.dart';
import '../../models/medicine.dart';

class MedicineListScreen extends ConsumerStatefulWidget {
  final String categoryId;

  const MedicineListScreen({super.key, required this.categoryId});

  @override
  ConsumerState<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends ConsumerState<MedicineListScreen> {
  String _selectedFilter = 'All';
  final _filters = ['All', 'Prescription', 'OTC', 'Best Seller'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicineListProvider.notifier).loadMedicines(
            categoryId: widget.categoryId,
            refresh: true,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicineState = ref.watch(medicineListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Medicines'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return FilterChipWidget(
                    label: _filters[index],
                    isSelected: _selectedFilter == _filters[index],
                    onTap: () {
                      setState(() => _selectedFilter = _filters[index]);
                      final filter = _filters[index] == 'All'
                          ? null
                          : _filters[index].toLowerCase();
                      ref.read(medicineListProvider.notifier).loadMedicines(
                            categoryId: widget.categoryId,
                            filter: filter,
                            refresh: true,
                          );
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: _buildContent(medicineState),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(MedicineListState state) {
    if (state.medicines.isEmpty && state.isLoading) {
      return const LoadingWidget();
    }

    if (state.medicines.isEmpty && state.error != null) {
      return ErrorState(
        message: state.error!,
        buttonText: 'Retry',
        onRetry: () => ref.read(medicineListProvider.notifier).loadMedicines(
              categoryId: widget.categoryId,
              refresh: true,
            ),
      );
    }

    if (state.medicines.isEmpty) {
      return const EmptyState(
        icon: Icons.medication_outlined,
        title: 'No medicines found',
        subtitle: 'Try adjusting your filters',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: state.medicines.length + (state.hasMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == state.medicines.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: AppColors.primaryDark,
              ),
            ),
          );
        }
        return MedicineCard(
          medicine: state.medicines[index],
          onTap: () => context.go('/medicine/${state.medicines[index].id}'),
          onAddToCart: () {},
        );
      },
    );
  }
}
