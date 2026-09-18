import '../core/constants/api_constants.dart';
import '../core/network/dio_client.dart';
import '../models/medicine.dart';

class WishlistService {
  final DioClient _dio;
  WishlistService({DioClient? dio}) : _dio = dio ?? DioClient();

  Future<List<Medicine>> getItems() async {
    final response = await _dio.get(ApiConstants.wishlistItems);
    final data = response.data;
    final List items = data is List ? data : (data['results'] ?? []);
    return items.map((item) => Medicine.fromJson(item['medicine'])).toList();
  }
  Future<void> add(int medicineId) => _dio.post(ApiConstants.wishlistItems, data: {'medicine_id': medicineId});
  Future<void> remove(int id) => _dio.delete('${ApiConstants.wishlistItems}$id/');
}
