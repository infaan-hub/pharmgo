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
    String? name,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? stateValue,
    String? zipCode,
    String? label,
    String? fullName,
    String? phone,
    String? street,
    String? apartment,
    bool isDefault = false,
  }) async {
    try {
      final address = await _service.addAddress(
        name: name ?? fullName ?? '',
        addressLine1: addressLine1 ?? street ?? '',
        addressLine2: addressLine2 ?? apartment,
        city: city ?? '',
        state: stateValue ?? '',
        zipCode: zipCode ?? '',
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
      final updatedAddresses = state.addresses.map((a) {
        return Address(
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
          fullName: a.fullName,
          phone: a.phone,
          street: a.street,
          apartment: a.apartment,
        );
      }).toList();
      state = state.copyWith(addresses: updatedAddresses);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
