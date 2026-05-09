class FreelancerModel {
  const FreelancerModel({
    required this.userId,
    required this.category,
    required this.bio,
    required this.experience,
    required this.location,
    required this.rating,
    this.portfolio = const [],
  });

  final String userId;
  final String category;
  final String bio;
  final int experience;
  final String location;
  final double rating;
  final List<String> portfolio;

  factory FreelancerModel.fromJson(Map<String, dynamic> json) {
    return FreelancerModel(
      userId: json['userId'] as String,
      category: json['category'] as String,
      bio: json['bio'] as String? ?? '',
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      location: json['location'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      portfolio: (json['portfolio'] as List?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'category': category,
        'bio': bio,
        'experience': experience,
        'location': location,
        'rating': rating,
        'portfolio': portfolio,
      };

  FreelancerModel copyWith({
    String? userId,
    String? category,
    String? bio,
    int? experience,
    String? location,
    double? rating,
    List<String>? portfolio,
  }) {
    return FreelancerModel(
      userId: userId ?? this.userId,
      category: category ?? this.category,
      bio: bio ?? this.bio,
      experience: experience ?? this.experience,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      portfolio: portfolio ?? this.portfolio,
    );
  }
}
