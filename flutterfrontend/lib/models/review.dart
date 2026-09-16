class Review {
  final int id;
  final int user;
  final String userEmail;
  final int medicine;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.user,
    required this.userEmail,
    required this.medicine,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      user: json['user'] ?? 0,
      userEmail: json['user_email'] ?? '',
      medicine: json['medicine'] ?? 0,
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
