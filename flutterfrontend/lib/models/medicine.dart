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
  final int reviewCount;
  final int category;
  final String? categoryName;
  final bool isActive;
  final bool isFavorite;
  final double? originalPrice;
  final String? uses;
  final String? sideEffects;
  final String? ingredients;
  final String? dosage;

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
    this.reviewCount = 0,
    required this.category,
    this.categoryName,
    this.isActive = true,
    this.isFavorite = false,
    this.originalPrice,
    this.uses,
    this.sideEffects,
    this.ingredients,
    this.dosage,
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
      reviewCount: json['review_count'] ?? 0,
      category: json['category'] is int ? json['category'] : (json['category'] ?? 0),
      categoryName: json['category_name'],
      isActive: json['is_active'] ?? true,
      isFavorite: json['is_favorite'] ?? false,
      originalPrice: json['original_price'] != null ? (json['original_price'] as num).toDouble() : null,
      uses: json['uses'],
      sideEffects: json['side_effects'],
      ingredients: json['ingredients'],
      dosage: json['dosage'],
    );
  }

  String? get imageUrl => image;
  double get rating => ratingAvg;
  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  double get discountPercent => hasDiscount ? ((originalPrice! - price) / originalPrice! * 100) : 0;
  bool get inStock => stockQuantity > 0;
  String get imageUrl => image ?? '';
  String get dosage => dosageOptions.isNotEmpty ? dosageOptions.first.toString() : '';
  bool get isFavorite => false;
  double get rating => ratingAvg;
  int get reviewCount => 0;
  bool get hasDiscount => false;
  double get originalPrice => price * (1 + discountPercent / 100);
  int get discountPercent => 0;
  String get uses => description ?? '';
  String get sideEffects => '';
  String get ingredients => '';
}
