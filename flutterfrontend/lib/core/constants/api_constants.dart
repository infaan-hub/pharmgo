class ApiConstants {
  ApiConstants._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  // Auth
  static const String register = '/api/auth/register/';
  static const String login = '/api/auth/login/';
  static const String refreshToken = '/api/auth/refresh/';
  static const String logout = '/api/auth/logout/';
  static const String otpRequest = '/api/auth/otp/request/';
  static const String otpVerify = '/api/auth/otp/verify/';
  static const String passwordReset = '/api/auth/password/reset/';
  static const String usernameAvailable = '/api/auth/username-available/';

  // Accounts
  static const String profile = '/api/accounts/me/';
  static const String addresses = '/api/accounts/addresses/';
  static const String paymentMethods = '/api/accounts/payment-methods/';

  // Catalog
  static const String categories = '/api/categories/';
  static const String medicines = '/api/medicines/';

  // Prescriptions
  static const String prescriptions = '/api/prescriptions/';

  // Cart
  static const String cart = '/api/cart/';
  static const String cartItems = '/api/cart/items/';

  // Orders
  static const String orders = '/api/orders/';

  // Pharmacies
  static const String pharmaciesNearby = '/api/pharmacies/nearby/';

  // Notifications
  static const String notifications = '/api/notifications/';
  static const String wishlistItems = '/api/wishlist/items/';

  // Support
  static const String faqs = '/api/support/faqs/';
  static const String supportTickets = '/api/support/tickets/';
}
