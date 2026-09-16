import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prescription.dart';
import '../services/prescription_service.dart';

final prescriptionServiceProvider = Provider<PrescriptionService>((ref) => PrescriptionService());

final prescriptionListProvider =
    StateNotifierProvider<PrescriptionListNotifier, PrescriptionListState>((ref) {
  return PrescriptionListNotifier(ref.read(prescriptionServiceProvider));
});

class PrescriptionListState {
  final List<Prescription> prescriptions;
  final bool isLoading;
  final String? error;

  PrescriptionListState({
    this.prescriptions = const [],
    this.isLoading = false,
    this.error,
  });

  PrescriptionListState copyWith({
    List<Prescription>? prescriptions,
    bool? isLoading,
    String? error,
  }) {
    return PrescriptionListState(
      prescriptions: prescriptions ?? this.prescriptions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PrescriptionListNotifier extends StateNotifier<PrescriptionListState> {
  final PrescriptionService _service;

  PrescriptionListNotifier(this._service) : super(PrescriptionListState());

  Future<void> loadPrescriptions() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final prescriptions = await _service.getPrescriptions();
      state = state.copyWith(prescriptions: prescriptions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> uploadPrescription(File file, {String? notes}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final prescription = await _service.uploadPrescription(file: file, notes: notes);
      state = state.copyWith(
        prescriptions: [...state.prescriptions, prescription],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deletePrescription(int id) async {
    try {
      await _service.deletePrescription(id);
      state = state.copyWith(
        prescriptions: state.prescriptions.where((p) => p.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
