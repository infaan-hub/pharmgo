import '../core/network/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/payment_method.dart';

class PaymentService {
  final DioClient _dio;

  PaymentService({DioClient? dio}) : _dio = dio ?? DioClient();

  Future<List<PaymentMethod>> getPaymentMethods() async {
    final response = await _dio.get(ApiConstants.paymentMethods);
    final data = response.data;
    final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
    return results.map((e) => PaymentMethod.fromJson(e)).toList();
  }

  Future<PaymentMethod> addPaymentMethod({
    required String cardType,
    required String lastFour,
    required String cardholderName,
    required String expiryMonth,
    required String expiryYear,
  }) async {
    final response = await _dio.post(ApiConstants.paymentMethods, data: {
      'card_type': cardType,
      'last_four': lastFour,
      'cardholder_name': cardholderName,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
    });
    return PaymentMethod.fromJson(response.data);
  }

  Future<void> deletePaymentMethod(int id) async {
    await _dio.delete('${ApiConstants.paymentMethods}$id/');
  }
}
