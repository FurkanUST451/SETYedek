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
    required this.chatId,
    required this.briefId,
    required this.briefTitle,
    required this.senderId,
    required this.receiverId,
    required this.amount,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String chatId;
  final String briefId;
  final String briefTitle;
  final String senderId;
  final String receiverId;
  final double amount;
  final String message;
  final OfferStatus status;
  final DateTime createdAt;

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      chatId: json['chatId'] as String? ?? '',
      briefId: json['briefId'] as String? ?? '',
      briefTitle: json['briefTitle'] as String? ?? '',
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      message: json['message'] as String? ?? '',
      status: OfferStatus.fromName(json['status'] as String?),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': chatId,
        'briefId': briefId,
        'briefTitle': briefTitle,
        'senderId': senderId,
        'receiverId': receiverId,
        'amount': amount,
        'message': message,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  OfferModel copyWith({
    String? id,
    String? chatId,
    String? briefId,
    String? briefTitle,
    String? senderId,
    String? receiverId,
    double? amount,
    String? message,
    OfferStatus? status,
    DateTime? createdAt,
  }) {
    return OfferModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      briefId: briefId ?? this.briefId,
      briefTitle: briefTitle ?? this.briefTitle,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      amount: amount ?? this.amount,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
