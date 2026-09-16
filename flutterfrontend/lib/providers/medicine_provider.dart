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

final medicineDetailProvider = FutureProvider.family<Medicine, int>((ref, id) async {
  return ref.read(medicineServiceProvider).getMedicineDetail(id);
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
    int? categoryId,
    String? search,
    String? ordering,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(medicines: [], currentPage: 1, hasMore: true);
    }
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _service.getMedicines(
        categoryId: categoryId,
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
