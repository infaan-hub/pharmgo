class Pharmacy {
  final int id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String hours;
  final String? contactPhone;
  final String? contactEmail;
  final double? distanceKm;
  final double? rating;

  Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    this.hours = '',
    this.contactPhone,
    this.contactEmail,
    this.distanceKm,
    this.rating,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      hours: json['hours'] ?? '',
      contactPhone: json['contact_phone'],
      contactEmail: json['contact_email'],
      distanceKm: json['distance_km']?.toDouble(),
      rating: json['rating']?.toDouble(),
    );
  }

  String get distanceText => distanceKm != null
      ? '${distanceKm!.toStringAsFixed(1)} km away'
      : '';
}
