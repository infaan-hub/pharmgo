class AppConstants {
  AppConstants._();

  static const String appName = 'PharmGo';
  static const String appTagline = 'HEALTH & CARE';
  static const String appSlogan = 'TRUSTED MEDICINE. DELIVERED WITH CARE.';
  static const String appNameFull = 'PharmGo';
  static const String appNameShort = 'PG';

  static const int splashDuration = 2500;
  static const int otpLength = 6;
  static const int maxPrescriptionFiles = 5;
  static const double defaultDeliveryFee = 4.99;
  static const double freeDeliveryThreshold = 50.0;
  static const int maxRecentSearches = 10;
  static const int productsPerPage = 20;

  static const String currencySymbol = '\$';
  static const String defaultCountryCode = '+1';

  static const List<String> onboardingIcons = [
    '💊',
    '📋',
    '🚚',
    '🔄',
  ];

  static const List<String> onboardingTitles = [
    'Order Medicine',
    'Upload Prescription',
    'Track Delivery',
    'Refill With One Tap',
  ];

  static const List<String> onboardingDescriptions = [
    'Browse thousands of medicines and healthcare products from verified pharmacies near you.',
    'Simply upload your prescription and we\'ll handle the rest with utmost care.',
    'Real-time tracking so you always know when your medicine will arrive.',
    'Never run out of essential medicines with smart refill reminders.',
  ];

  static const List<Map<String, dynamic>> categories = [
    {'name': 'Prescription', 'icon': 'prescription'},
    {'name': 'OTC', 'icon': 'otc'},
    {'name': 'Vitamins', 'icon': 'vitamins'},
    {'name': 'Personal Care', 'icon': 'personal_care'},
    {'name': 'Baby Care', 'icon': 'baby_care'},
    {'name': 'Diabetes', 'icon': 'diabetes'},
    {'name': 'Heart Care', 'icon': 'heart'},
    {'name': 'Ayurveda', 'icon': 'ayurveda'},
  ];
}
