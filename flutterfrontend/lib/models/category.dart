class Category {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final String? image;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.image,
    this.isActive = true,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      icon: json['icon'],
      image: json['image'],
      isActive: json['is_active'] ?? true,
    );
  }
}
