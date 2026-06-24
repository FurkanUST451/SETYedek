class PortfolioProject {
  const PortfolioProject({
    required this.title,
    required this.jobType,
    required this.description,
    this.videoUrl,
  });

  final String title;
  final String jobType;
  final String description;
  final String? videoUrl;

  factory PortfolioProject.fromJson(Map<String, dynamic> json) =>
      PortfolioProject(
        title: json['title'] as String? ?? '',
        jobType: json['jobType'] as String? ?? '',
        description: json['description'] as String? ?? '',
        videoUrl: json['videoUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'jobType': jobType,
        'description': description,
        'videoUrl': videoUrl,
      };
}

class FreelancerModel {
  const FreelancerModel({
    required this.userId,
    required this.categories,
    required this.bio,
    required this.experience,
    required this.location,
    required this.rating,
    this.birthDate,
    this.projects = const [],
    this.portfolio = const [],
  });

  final String userId;
  final List<String> categories;
  final String bio;
  final int experience;
  final String location;
  final double rating;
  final DateTime? birthDate;
  final List<PortfolioProject> projects;
  final List<String> portfolio;

  factory FreelancerModel.fromJson(Map<String, dynamic> json) {
    return FreelancerModel(
      userId: json['userId'] as String,
      categories: (json['categories'] as List?)?.cast<String>() ?? const [],
      bio: json['bio'] as String? ?? '',
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      location: json['location'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'] as String)
          : null,
      projects: (json['projects'] as List?)
              ?.map((e) =>
                  PortfolioProject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      portfolio: (json['portfolio'] as List?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'categories': categories,
        'bio': bio,
        'experience': experience,
        'location': location,
        'rating': rating,
        'birthDate': birthDate?.toIso8601String(),
        'projects': projects.map((p) => p.toJson()).toList(),
        'portfolio': portfolio,
      };

  FreelancerModel copyWith({
    String? userId,
    List<String>? categories,
    String? bio,
    int? experience,
    String? location,
    double? rating,
    DateTime? birthDate,
    List<PortfolioProject>? projects,
    List<String>? portfolio,
  }) {
    return FreelancerModel(
      userId: userId ?? this.userId,
      categories: categories ?? this.categories,
      bio: bio ?? this.bio,
      experience: experience ?? this.experience,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      birthDate: birthDate ?? this.birthDate,
      projects: projects ?? this.projects,
      portfolio: portfolio ?? this.portfolio,
    );
  }
}
