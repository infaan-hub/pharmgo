import '../core/network/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/order.dart';

class OrderService {
  final DioClient _dio;

  OrderService({DioClient? dio}) : _dio = dio ?? DioClient();

  Future<Order> createOrder({
    required int addressId,
    required int paymentMethodId,
  }) async {
    final response = await _dio.post(ApiConstants.orders, data: {
      'address_id': addressId,
      'payment_method_id': paymentMethodId,
    });
    return Order.fromJson(response.data);
  }

  Future<List<Order>> getOrders({int page = 1}) async {
    final response = await _dio.get(ApiConstants.orders, queryParameters: {
      'page': page,
    });
    final data = response.data;
    final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
    return results.map((e) => Order.fromJson(e)).toList();
  }

  Future<Order> getOrderDetail(int orderId) async {
    final response = await _dio.get('${ApiConstants.orders}$orderId/');
    return Order.fromJson(response.data);
  }

  Future<void> reorder(int orderId) async {
    await _dio.post('${ApiConstants.orders}$orderId/reorder/');
  }
}
