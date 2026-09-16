import '../core/network/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/faq.dart';

class SupportService {
  final DioClient _dio;

  SupportService({DioClient? dio}) : _dio = dio ?? DioClient();

  Future<List<Faq>> getFaqs() async {
    final response = await _dio.get(ApiConstants.faqs);
    final data = response.data;
    final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
    return results.map((e) => Faq.fromJson(e)).toList();
  }

  Future<void> submitSupportTicket({
    required String subject,
    required String message,
  }) async {
    await _dio.post(ApiConstants.supportTickets, data: {
      'subject': subject,
      'message': message,
    });
  }
}
