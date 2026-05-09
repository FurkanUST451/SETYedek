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
    this.freelancerId,
    required this.status,
    required this.title,
    required this.description,
    required this.budget,
    required this.deadline,
  });

  final String id;
  final String clientId;
  final String? freelancerId;
  final ProjectStatus status;
  final String title;
  final String description;
  final double budget;
  final DateTime deadline;

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      freelancerId: json['freelancerId'] as String?,
      status: ProjectStatus.fromName(json['status'] as String?),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      budget: (json['budget'] as num?)?.toDouble() ?? 0,
      deadline: DateTime.parse(json['deadline'] as String),
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
        'deadline': deadline.toIso8601String(),
      };

  ProjectModel copyWith({
    String? id,
    String? clientId,
    String? freelancerId,
    ProjectStatus? status,
    String? title,
    String? description,
    double? budget,
    DateTime? deadline,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      freelancerId: freelancerId ?? this.freelancerId,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      deadline: deadline ?? this.deadline,
    );
  }
}
