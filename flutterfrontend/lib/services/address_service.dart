import '../core/network/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/address.dart';

class AddressService {
  final DioClient _dio;

  AddressService({DioClient? dio}) : _dio = dio ?? DioClient();

  Future<List<Address>> getAddresses() async {
    final response = await _dio.get(ApiConstants.addresses);
    final data = response.data;
    final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
    return results.map((e) => Address.fromJson(e)).toList();
  }

  Future<Address> addAddress({
    required String name,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String state,
    required String zipCode,
    String country = 'US',
    bool isDefault = false,
    double? lat,
    double? lng,
  }) async {
    final response = await _dio.post(ApiConstants.addresses, data: {
      'name': name,
      'address_line1': addressLine1,
      'address_line2': addressLine2 ?? '',
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'is_default': isDefault,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    });
    return Address.fromJson(response.data);
  }

  Future<Address> updateAddress({
    required int id,
    String? name,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    bool? isDefault,
    double? lat,
    double? lng,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (addressLine1 != null) data['address_line1'] = addressLine1;
    if (addressLine2 != null) data['address_line2'] = addressLine2;
    if (city != null) data['city'] = city;
    if (state != null) data['state'] = state;
    if (zipCode != null) data['zip_code'] = zipCode;
    if (country != null) data['country'] = country;
    if (isDefault != null) data['is_default'] = isDefault;
    if (lat != null) data['lat'] = lat;
    if (lng != null) data['lng'] = lng;
    final response = await _dio.put('${ApiConstants.addresses}$id/', data: data);
    return Address.fromJson(response.data);
  }

  Future<void> deleteAddress(int id) async {
    await _dio.delete('${ApiConstants.addresses}$id/');
  }
}
