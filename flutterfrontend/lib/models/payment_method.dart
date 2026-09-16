class PaymentMethod {
  final int id;
  final String cardType;
  final String lastFour;
  final String cardholderName;
  final String expiryMonth;
  final String expiryYear;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.cardType,
    required this.lastFour,
    required this.cardholderName,
    required this.expiryMonth,
    required this.expiryYear,
    this.isDefault = false,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? 0,
      cardType: json['card_type'] ?? 'visa',
      lastFour: json['last_four'] ?? '',
      cardholderName: json['cardholder_name'] ?? '',
      expiryMonth: json['expiry_month'] ?? '',
      expiryYear: json['expiry_year'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }

  String get displayName => '•••• •••• •••• $lastFour';
  String get displayExpiry => '$expiryMonth/$expiryYear';
}
