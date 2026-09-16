class Medicine {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? manufacturer;
  final List<dynamic> dosageOptions;
  final double price;
  final int stockQuantity;
  final bool requiresPrescription;
  final String? image;
  final double ratingAvg;
  final int category;
  final String? categoryName;
  final bool isActive;

  Medicine({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.manufacturer,
    this.dosageOptions = const [],
    required this.price,
    this.stockQuantity = 0,
    this.requiresPrescription = false,
    this.image,
    this.ratingAvg = 0.0,
    required this.category,
    this.categoryName,
    this.isActive = true,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      manufacturer: json['manufacturer'],
      dosageOptions: json['dosage_options'] ?? [],
      price: (json['price'] ?? 0).toDouble(),
      stockQuantity: json['stock_quantity'] ?? 0,
      requiresPrescription: json['requires_prescription'] ?? false,
      image: json['image'],
      ratingAvg: (json['rating_avg'] ?? 0).toDouble(),
      category: json['category'] ?? 0,
      categoryName: json['category_name'],
      isActive: json['is_active'] ?? true,
    );
  }

  bool get inStock => stockQuantity > 0;
}
