import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/get_started_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/auth/reset_password_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/categories/category_list_screen.dart';
import '../../screens/categories/medicine_list_screen.dart';
import '../../screens/medicine_detail/medicine_detail_screen.dart';
import '../../screens/prescription/prescription_upload_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/checkout/checkout_screen.dart';
import '../../screens/address/address_list_screen.dart';
import '../../screens/address/address_form_screen.dart';
import '../../screens/payment/payment_methods_screen.dart';
import '../../screens/orders/order_confirmation_screen.dart';
import '../../screens/orders/order_tracking_screen.dart';
import '../../screens/orders/order_history_screen.dart';
import '../../screens/orders/order_details_screen.dart';
import '../../screens/pharmacy/pharmacy_locator_screen.dart';
import '../../screens/reviews/reviews_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/wishlist/wishlist_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/support/support_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String getStarted = '/get-started';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String search = '/search';
  static const String categories = '/categories';
  static const String medicineList = '/categories/:categoryId/medicines';
  static const String medicineDetail = '/medicine/:id';
  static const String prescription = '/prescription';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String addresses = '/addresses';
  static const String addressForm = '/addresses/form';
  static const String paymentMethods = '/payment-methods';
  static const String orderConfirmation = '/orders/confirmation';
  static const String orderTracking = '/orders/:orderId/tracking';
  static const String orderHistory = '/orders';
  static const String orderDetails = '/orders/:orderId';
  static const String pharmacyLocator = '/pharmacy';
  static const String reviews = '/reviews';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String wishlist = '/wishlist';
  static const String settings = '/settings';
  static const String support = '/support';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: onboarding, builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: getStarted, builder: (context, state) => const GetStartedScreen()),
      GoRoute(path: signup, builder: (context, state) => const SignupScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: forgotPassword, builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: otp, builder: (context, state) => const OtpScreen()),
      GoRoute(path: resetPassword, builder: (context, state) => const ResetPasswordScreen()),
      GoRoute(path: home, builder: (context, state) => const HomeScreen()),
      GoRoute(path: search, builder: (context, state) => const SearchScreen()),
      GoRoute(path: categories, builder: (context, state) => const CategoryListScreen()),
      GoRoute(path: '/categories/:categoryId/medicines', builder: (context, state) {
        final categoryId = state.pathParameters['categoryId'] ?? '';
        return MedicineListScreen(categoryId: categoryId);
      }),
      GoRoute(path: '/medicine/:id', builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return MedicineDetailScreen(medicineId: id);
      }),
      GoRoute(path: prescription, builder: (context, state) => const PrescriptionUploadScreen()),
      GoRoute(path: cart, builder: (context, state) => const CartScreen()),
      GoRoute(path: checkout, builder: (context, state) => const CheckoutScreen()),
      GoRoute(path: addresses, builder: (context, state) => const AddressListScreen()),
      GoRoute(path: addressForm, builder: (context, state) => const AddressFormScreen()),
      GoRoute(path: paymentMethods, builder: (context, state) => const PaymentMethodsScreen()),
      GoRoute(path: orderConfirmation, builder: (context, state) => const OrderConfirmationScreen()),
      GoRoute(path: '/orders/:orderId/tracking', builder: (context, state) {
        final orderId = state.pathParameters['orderId'] ?? '';
        return OrderTrackingScreen(orderId: orderId);
      }),
      GoRoute(path: orderHistory, builder: (context, state) => const OrderHistoryScreen()),
      GoRoute(path: '/orders/:orderId', builder: (context, state) {
        final orderId = state.pathParameters['orderId'] ?? '';
        return OrderDetailsScreen(orderId: orderId);
      }),
      GoRoute(path: pharmacyLocator, builder: (context, state) => const PharmacyLocatorScreen()),
      GoRoute(path: reviews, builder: (context, state) => const ReviewsScreen()),
      GoRoute(path: notifications, builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: profile, builder: (context, state) => const ProfileScreen()),
      GoRoute(path: editProfile, builder: (context, state) => const EditProfileScreen()),
      GoRoute(path: wishlist, builder: (context, state) => const WishlistScreen()),
      GoRoute(path: settings, builder: (context, state) => const SettingsScreen()),
      GoRoute(path: support, builder: (context, state) => const SupportScreen()),
    ],
  );
}
