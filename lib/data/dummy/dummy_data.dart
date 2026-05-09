import '../models/freelancer_model.dart';
import '../models/user_model.dart';

class DummyData {
  DummyData._();

  static const List<String> categories = [
    'Videographer',
    'Sound Design',
    'Video Edit',
    'AI/CGI',
    'Drone',
    'Photographer',
  ];

  static final List<UserModel> users = [
    UserModel(
      id: 'u1',
      name: 'Aylin Demir',
      email: 'aylin@set.app',
      role: UserRole.freelancer,
      avatarUrl: null,
      createdAt: DateTime(2025, 6, 12),
    ),
    UserModel(
      id: 'u2',
      name: 'Mert Kaya',
      email: 'mert@set.app',
      role: UserRole.freelancer,
      avatarUrl: null,
      createdAt: DateTime(2025, 7, 1),
    ),
    UserModel(
      id: 'u3',
      name: 'Selin Acar',
      email: 'selin@set.app',
      role: UserRole.freelancer,
      avatarUrl: null,
      createdAt: DateTime(2025, 8, 4),
    ),
    UserModel(
      id: 'u4',
      name: 'Burak Yılmaz',
      email: 'burak@set.app',
      role: UserRole.freelancer,
      avatarUrl: null,
      createdAt: DateTime(2025, 9, 18),
    ),
    UserModel(
      id: 'u5',
      name: 'Eda Şen',
      email: 'eda@set.app',
      role: UserRole.freelancer,
      avatarUrl: null,
      createdAt: DateTime(2025, 10, 22),
    ),
    UserModel(
      id: 'u6',
      name: 'Can Aksoy',
      email: 'can@set.app',
      role: UserRole.freelancer,
      avatarUrl: null,
      createdAt: DateTime(2025, 11, 5),
    ),
  ];

  static final List<FreelancerModel> freelancers = [
    FreelancerModel(
      userId: 'u1',
      category: 'Videographer',
      bio: 'Reklam ve müzik videosu odaklı, set'
          ' deneyimi yüksek videograf.',
      experience: 7,
      location: 'İstanbul',
      rating: 4.9,
      portfolio: const [],
    ),
    FreelancerModel(
      userId: 'u2',
      category: 'Sound Design',
      bio: 'Reklam, dizi ve kısa film için ses tasarımı ve mix.',
      experience: 5,
      location: 'Ankara',
      rating: 4.7,
      portfolio: const [],
    ),
    FreelancerModel(
      userId: 'u3',
      category: 'Video Edit',
      bio: 'Sosyal medya ve reklam kurguları, hızlı teslim.',
      experience: 4,
      location: 'İzmir',
      rating: 4.8,
      portfolio: const [],
    ),
    FreelancerModel(
      userId: 'u4',
      category: 'AI/CGI',
      bio: 'CGI ürün görselleri ve AI tabanlı VFX iş akışları.',
      experience: 6,
      location: 'İstanbul',
      rating: 4.6,
      portfolio: const [],
    ),
    FreelancerModel(
      userId: 'u5',
      category: 'Drone',
      bio: 'Lisanslı drone pilotu — sinematik hava çekimleri.',
      experience: 3,
      location: 'Antalya',
      rating: 4.85,
      portfolio: const [],
    ),
    FreelancerModel(
      userId: 'u6',
      category: 'Photographer',
      bio: 'Marka kampanyaları ve editorial fotoğraf.',
      experience: 8,
      location: 'İstanbul',
      rating: 4.95,
      portfolio: const [],
    ),
  ];
}
