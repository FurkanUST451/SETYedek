enum OfferStatus {
  pending,
  accepted,
  rejected;

  static OfferStatus fromName(String? value) {
    return OfferStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => OfferStatus.pending,
    );
  }
}

class OfferModel {
  const OfferModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.projectId,
    required this.amount,
    required this.message,
    required this.status,
  });

  final String id;
  final String senderId;
  final String receiverId;
  final String projectId;
  final double amount;
  final String message;
  final OfferStatus status;

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      projectId: json['projectId'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      message: json['message'] as String? ?? '',
      status: OfferStatus.fromName(json['status'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'receiverId': receiverId,
        'projectId': projectId,
        'amount': amount,
        'message': message,
        'status': status.name,
      };

  OfferModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? projectId,
    double? amount,
    String? message,
    OfferStatus? status,
  }) {
    return OfferModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      projectId: projectId ?? this.projectId,
      amount: amount ?? this.amount,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
