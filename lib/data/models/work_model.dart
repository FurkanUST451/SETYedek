enum WorkType {
  video,
  photo,
  cgi,
  vfx,
  ai;

  String get label {
    switch (this) {
      case WorkType.video:
        return 'Video';
      case WorkType.photo:
        return 'Foto';
      case WorkType.cgi:
        return 'CGI';
      case WorkType.vfx:
        return 'VFX';
      case WorkType.ai:
        return 'AI';
    }
  }

  static WorkType fromName(String? value) {
    return WorkType.values.firstWhere(
      (t) => t.name == value,
      orElse: () => WorkType.video,
    );
  }
}

class WorkModel {
  const WorkModel({
    required this.id,
    required this.title,
    required this.studio,
    required this.type,
    this.likes = 0,
    this.comments = 0,
    this.coverImage,
  });

  final String id;
  final String title;
  final String studio;
  final WorkType type;
  final int likes;
  final int comments;
  final String? coverImage;
}
