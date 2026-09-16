class Address {
  final int id;
  final String name;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;
  final double? lat;
  final double? lng;

  Address({
    required this.id,
    required this.name,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.zipCode,
    this.country = 'US',
    this.isDefault = false,
    this.lat,
    this.lng,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zip_code'] ?? '',
      country: json['country'] ?? 'US',
      isDefault: json['is_default'] ?? false,
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
    );
  }

  String get fullAddress {
    final parts = [addressLine1];
    if (addressLine2.isNotEmpty) parts.add(addressLine2);
    parts.add('$city, $state $zipCode');
    return parts.join(', ');
  }
}
