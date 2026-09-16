import '../core/network/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/review.dart';

class ReviewService {
  final DioClient _dio;

  ReviewService({DioClient? dio}) : _dio = dio ?? DioClient();

  Future<List<Review>> getReviews(int medicineId) async {
    final response = await _dio.get('${ApiConstants.medicines}$medicineId/reviews/');
    final data = response.data;
    final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
    return results.map((e) => Review.fromJson(e)).toList();
  }

  Future<Review> addReview({
    required int medicineId,
    required int rating,
    required String comment,
  }) async {
    final response = await _dio.post('${ApiConstants.medicines}$medicineId/reviews/', data: {
      'rating': rating,
      'comment': comment,
    });
    return Review.fromJson(response.data);
  }
}
