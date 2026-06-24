class BriefAnswers {
  const BriefAnswers({
    this.shootingType,
    this.vibes,
    this.dateRange,
    this.deliveryTime,
    this.budget,
    this.location,
    this.notes,
  });

  final String? shootingType;   // Çekim Türü
  final List<String>? vibes;    // Duygu / Vibe (çoklu seçim)
  final String? dateRange;      // Çekim Aralığı
  final String? deliveryTime;   // Teslim Süresi
  final String? budget;         // Bütçe Aralığı
  final String? location;       // Lokasyon
  final String? notes;          // Serbest metin (BriefShare ekranı)

  Map<String, dynamic> toJson() => {
        'shootingType': shootingType,
        'vibes': vibes,
        'dateRange': dateRange,
        'deliveryTime': deliveryTime,
        'budget': budget,
        'location': location,
        'notes': notes,
      };

  factory BriefAnswers.fromJson(Map<String, dynamic> json) => BriefAnswers(
        shootingType: json['shootingType'] as String?,
        vibes: (json['vibes'] as List<dynamic>?)?.cast<String>(),
        dateRange: json['dateRange'] as String?,
        deliveryTime: json['deliveryTime'] as String?,
        budget: json['budget'] as String?,
        location: json['location'] as String?,
        notes: json['notes'] as String?,
      );
}

class BriefModel {
  const BriefModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.category,
    required this.status,
    required this.answers,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String ownerId;
  final String title;
  final String category;
  final String status; // 'draft' | 'submitted'
  final BriefAnswers answers;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'ownerId': ownerId,
        'title': title,
        'category': category,
        'status': status,
        'answers': answers.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory BriefModel.fromJson(Map<String, dynamic> json) => BriefModel(
        id: json['id'] as String,
        ownerId: json['ownerId'] as String,
        title: json['title'] as String? ?? '',
        category: json['category'] as String? ?? '',
        status: json['status'] as String? ?? 'draft',
        answers: BriefAnswers.fromJson(
          json['answers'] as Map<String, dynamic>? ?? {},
        ),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
