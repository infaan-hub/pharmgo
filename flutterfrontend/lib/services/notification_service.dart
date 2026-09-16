import '../core/network/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/notification.dart';

class NotificationService {
  final DioClient _dio;

  NotificationService({DioClient? dio}) : _dio = dio ?? DioClient();

  Future<List<AppNotification>> getNotifications({int page = 1}) async {
    final response = await _dio.get(ApiConstants.notifications, queryParameters: {
      'page': page,
    });
    final data = response.data;
    final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
    return results.map((e) => AppNotification.fromJson(e)).toList();
  }

  Future<void> markAsRead(int id) async {
    await _dio.put('${ApiConstants.notifications}$id/', data: {'is_read': true});
  }
}
