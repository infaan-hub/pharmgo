import '../core/network/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/medicine.dart';
import '../models/category.dart';

class MedicineService {
  final DioClient _dio;

  MedicineService({DioClient? dio}) : _dio = dio ?? DioClient();

  Future<Map<String, dynamic>> getMedicines({
    String? search,
    int? categoryId,
    String? ordering,
    int page = 1,
  }) async {
    final query = <String, dynamic>{
      'page': page,
    };
    if (search != null) query['search'] = search;
    if (categoryId != null) query['category'] = categoryId;
    if (ordering != null) query['ordering'] = ordering;
    final response = await _dio.get(ApiConstants.medicines, queryParameters: query);
    return response.data;
  }

  Future<Medicine> getMedicineDetail(int id) async {
    final response = await _dio.get('${ApiConstants.medicines}$id/');
    return Medicine.fromJson(response.data);
  }

  Future<List<Category>> getCategories() async {
    final response = await _dio.get(ApiConstants.categories);
    final data = response.data;
    final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
    return results.map((e) => Category.fromJson(e)).toList();
  }

  Future<List<Medicine>> searchMedicines(String query) async {
    final response = await _dio.get(ApiConstants.medicines, queryParameters: {'search': query});
    final data = response.data;
    final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
    return results.map((e) => Medicine.fromJson(e)).toList();
  }
}
