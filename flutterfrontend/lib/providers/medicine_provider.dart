import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medicine.dart';
import '../models/category.dart';
import '../services/medicine_service.dart';

final medicineServiceProvider = Provider<MedicineService>((ref) => MedicineService());

final medicineListProvider = StateNotifierProvider<MedicineListNotifier, MedicineListState>((ref) {
  return MedicineListNotifier(ref.read(medicineServiceProvider));
});

final categoryListProvider = FutureProvider<List<Category>>((ref) async {
  return ref.read(medicineServiceProvider).getCategories();
});

final medicineDetailProvider = FutureProvider.family<Medicine, dynamic>((ref, id) async {
  final intId = id is String ? int.tryParse(id) ?? 0 : id;
  return ref.read(medicineServiceProvider).getMedicineDetail(intId);
});

final bestSellersProvider = FutureProvider<List<Medicine>>((ref) async {
  final service = ref.read(medicineServiceProvider);
  final data = await service.getMedicines(ordering: '-rating_avg');
  final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
  return results.map((e) => Medicine.fromJson(e)).toList();
});

final trendingProvider = FutureProvider<List<Medicine>>((ref) async {
  final service = ref.read(medicineServiceProvider);
  final data = await service.getMedicines(ordering: '-stock_quantity');
  final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
  return results.map((e) => Medicine.fromJson(e)).toList();
});

final relatedMedicinesProvider = FutureProvider.family<List<Medicine>, dynamic>((ref, medicineId) async {
  final service = ref.read(medicineServiceProvider);
  try {
    final medicine = await ref.read(medicineDetailProvider(medicineId).future);
    final data = await service.getMedicines(categoryId: medicine.category);
    final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
    return results
        .map((e) => Medicine.fromJson(e))
        .where((m) => m.id != medicineId)
        .toList();
  } catch (_) {
    return [];
  }
});

class MedicineListState {
  final List<Medicine> medicines;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;

  MedicineListState({
    this.medicines = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 1,
  });

  MedicineListState copyWith({
    List<Medicine>? medicines,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
  }) {
    return MedicineListState(
      medicines: medicines ?? this.medicines,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class MedicineListNotifier extends StateNotifier<MedicineListState> {
  final MedicineService _service;

  MedicineListNotifier(this._service) : super(MedicineListState());

  Future<void> loadMedicines({
    dynamic categoryId,
    String? search,
    String? ordering,
    String? filter,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(medicines: [], currentPage: 1, hasMore: true);
    }
    if (state.isLoading || !state.hasMore) return;

    final intCatId = categoryId is String ? int.tryParse(categoryId) : categoryId;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _service.getMedicines(
        categoryId: intCatId,
        search: search,
        ordering: ordering,
        page: state.currentPage,
      );
      final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
      final medicines = results.map((e) => Medicine.fromJson(e)).toList();
      state = state.copyWith(
        medicines: [...state.medicines, ...medicines],
        isLoading: false,
        hasMore: medicines.length >= 20,
        currentPage: state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void reset() {
    state = MedicineListState();
  }
}

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Medicine>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.read(medicineServiceProvider).searchMedicines(query);
});
