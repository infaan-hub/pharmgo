import '../core/network/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/pharmacy.dart';

class PharmacyService {
  final DioClient _dio;

  PharmacyService({DioClient? dio}) : _dio = dio ?? DioClient();

  Future<List<Pharmacy>> getNearbyPharmacies(double lat, double lng) async {
    final response = await _dio.get(ApiConstants.pharmaciesNearby, queryParameters: {
      'latitude': lat,
      'longitude': lng,
    });
    final data = response.data;
    final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
    return results.map((e) => Pharmacy.fromJson(e)).toList();
  }
}
