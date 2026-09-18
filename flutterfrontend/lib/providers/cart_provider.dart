import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';

final cartServiceProvider = Provider<CartService>((ref) => CartService());

final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  return CartNotifier(ref.read(cartServiceProvider));
});

class CartNotifier extends StateNotifier<Cart> {
  final CartService _service;

  CartNotifier(this._service) : super(Cart(id: 0));

  Future<void> loadCart() async {
    try {
      state = await _service.getCart();
    } catch (_) {}
  }

  Future<void> addToCart({
    required int medicineId,
    int quantity = 1,
    String? dosage,
  }) async {
    try {
      await _service.addToCart(medicineId: medicineId, quantity: quantity);
      await loadCart();
    } catch (_) {}
  }

  Future<void> updateQuantity(int itemId, int quantity) async {
    try {
      await _service.updateCartItem(itemId, quantity);
      await loadCart();
    } catch (_) {}
  }

  Future<void> removeItem(int itemId) async {
    try {
      await _service.removeFromCart(itemId);
      await loadCart();
    } catch (_) {}
  }

  Future<void> clear() async {
    try {
      await _service.clearCart();
      state = Cart(id: 0);
    } catch (_) {}
  }

  Future<void> applyPromoCode(String code) async {
    // Promo code application - placeholder for API integration
    try {
      await loadCart();
    } catch (_) {}
  }

  Future<void> applyPromoCode(String code) async {
    // Stub: promo code logic to be implemented
  }
}
