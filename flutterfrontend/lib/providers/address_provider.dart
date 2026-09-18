import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/address.dart';
import '../services/address_service.dart';

final addressServiceProvider = Provider<AddressService>((ref) => AddressService());

final addressListProvider =
    StateNotifierProvider<AddressListNotifier, AddressListState>((ref) {
  return AddressListNotifier(ref.read(addressServiceProvider));
});

class AddressListState {
  final List<Address> addresses;
  final bool isLoading;
  final String? error;

  AddressListState({
    this.addresses = const [],
    this.isLoading = false,
    this.error,
  });

  AddressListState copyWith({
    List<Address>? addresses,
    bool? isLoading,
    String? error,
  }) {
    return AddressListState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  Address? get defaultAddress {
    try {
      return addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }
}

class AddressListNotifier extends StateNotifier<AddressListState> {
  final AddressService _service;

  AddressListNotifier(this._service) : super(AddressListState());

  Future<void> loadAddresses() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final addresses = await _service.getAddresses();
      state = state.copyWith(addresses: addresses, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addAddress({
    required String name,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String stateValue,
    required String zipCode,
    bool isDefault = false,
    String label = 'Home',
    String phone = '',
  }) async {
    try {
      final address = await _service.addAddress(
        name: name,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        state: stateValue,
        zipCode: zipCode,
        isDefault: isDefault,
      );
      state = state.copyWith(addresses: [...state.addresses, address]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      await _service.deleteAddress(id);
      state = state.copyWith(
        addresses: state.addresses.where((a) => a.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> setDefault(int id) async {
    try {
      await _service.setDefault(id);
      state = state.copyWith(
        addresses: state.addresses.map((a) => Address(
          id: a.id,
          name: a.name,
          addressLine1: a.addressLine1,
          addressLine2: a.addressLine2,
          city: a.city,
          state: a.state,
          zipCode: a.zipCode,
          country: a.country,
          isDefault: a.id == id,
          lat: a.lat,
          lng: a.lng,
          label: a.label,
          phone: a.phone,
        )).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
