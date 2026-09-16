import '../core/network/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/cart.dart';

class CartService {
  final DioClient _dio;

  CartService({DioClient? dio}) : _dio = dio ?? DioClient();

  Future<Cart> getCart() async {
    final response = await _dio.get(ApiConstants.cart);
    return Cart.fromJson(response.data);
  }

  Future<void> addToCart({
    required int medicineId,
    int quantity = 1,
  }) async {
    await _dio.post(ApiConstants.cartItems, data: {
      'medicine_id': medicineId,
      'quantity': quantity,
    });
  }

  Future<void> updateCartItem(int itemId, int quantity) async {
    await _dio.put('${ApiConstants.cartItems}$itemId/', data: {
      'quantity': quantity,
    });
  }

  Future<void> removeFromCart(int itemId) async {
    await _dio.delete('${ApiConstants.cartItems}$itemId/');
  }

  Future<void> clearCart() async {
    await _dio.delete('${ApiConstants.cartItems}clear/');
  }
}
