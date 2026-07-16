enum ProjectStatus {
  pending,
  active,
  completed,
  cancelled;

  static ProjectStatus fromName(String? value) {
    return ProjectStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => ProjectStatus.pending,
    );
  }
}

class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.clientId,
    required this.freelancerId,
    required this.status,
    required this.title,
    required this.description,
    required this.budget,
    required this.createdAt,
    this.offerId,
    this.briefId,
    this.chatId,
    this.deadline,
    this.category,
    this.shootingType,
    this.vibes,
    this.dateRange,
    this.deliveryTime,
    this.location,
    this.notes,
  });

  final String id;
  final String clientId;
  final String freelancerId;
  final ProjectStatus status;
  final String title;
  final String description;
  final double budget;
  final DateTime createdAt;
  final String? offerId;
  final String? briefId;
  final String? chatId;
  final DateTime? deadline;

  // Brief'ten miras alınan detay alanları (brief kartıyla eşleşmesi için)
  final String? category;
  final String? shootingType;
  final List<String>? vibes;
  final String? dateRange;
  final String? deliveryTime;
  final String? location;
  final String? notes;

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      freelancerId: json['freelancerId'] as String,
      status: ProjectStatus.fromName(json['status'] as String?),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      budget: (json['budget'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      offerId: json['offerId'] as String?,
      briefId: json['briefId'] as String?,
      chatId: json['chatId'] as String?,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      category: json['category'] as String?,
      shootingType: json['shootingType'] as String?,
      vibes: (json['vibes'] as List<dynamic>?)?.cast<String>(),
      dateRange: json['dateRange'] as String?,
      deliveryTime: json['deliveryTime'] as String?,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clientId': clientId,
        'freelancerId': freelancerId,
        'status': status.name,
        'title': title,
        'description': description,
        'budget': budget,
        'createdAt': createdAt.toIso8601String(),
        'offerId': offerId,
        'briefId': briefId,
        'chatId': chatId,
        'deadline': deadline?.toIso8601String(),
        'category': category,
        'shootingType': shootingType,
        'vibes': vibes,
        'dateRange': dateRange,
        'deliveryTime': deliveryTime,
        'location': location,
        'notes': notes,
      };

  ProjectModel copyWith({
    String? id,
    String? clientId,
    String? freelancerId,
    ProjectStatus? status,
    String? title,
    String? description,
    double? budget,
    DateTime? createdAt,
    String? offerId,
    String? briefId,
    String? chatId,
    DateTime? deadline,
    String? category,
    String? shootingType,
    List<String>? vibes,
    String? dateRange,
    String? deliveryTime,
    String? location,
    String? notes,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      freelancerId: freelancerId ?? this.freelancerId,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      createdAt: createdAt ?? this.createdAt,
      offerId: offerId ?? this.offerId,
      briefId: briefId ?? this.briefId,
      chatId: chatId ?? this.chatId,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
      shootingType: shootingType ?? this.shootingType,
      vibes: vibes ?? this.vibes,
      dateRange: dateRange ?? this.dateRange,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      location: location ?? this.location,
      notes: notes ?? this.notes,
    );
  }
}
