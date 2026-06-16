import '../models/freelancer_model.dart';
import '../models/user_model.dart';
import '../models/work_model.dart';

class DummyData {
  DummyData._();

  static const List<String> categories = [
    'Video Çekim',
    'Kurgu',
    'CGI & AI',
    'Fotoğraf',
    'Ses',
    'Drone',
  ];

  static const List<WorkModel> works = [
    WorkModel(
      id: 'w1',
      title: 'Mercedes-Benz "The Chase"',
      studio: 'FRAMEWORKS',
      type: WorkType.video,
      likes: 2400,
      comments: 120,
    ),
    WorkModel(
      id: 'w2',
      title: 'Nightfall Aftermovie',
      studio: 'LENS COLLECTIVE',
      type: WorkType.video,
      likes: 1800,
      comments: 96,
    ),
    WorkModel(
      id: 'w3',
      title: 'VOGUE 2024 Campaign',
      studio: 'ATELIER NOIR',
      type: WorkType.photo,
      likes: 3200,
      comments: 210,
    ),
    WorkModel(
      id: 'w4',
      title: 'Aurora — CGI Short',
      studio: 'PIXEL FORGE',
      type: WorkType.cgi,
      likes: 980,
      comments: 54,
    ),
    WorkModel(
      id: 'w5',
      title: 'Spectra VFX Reel',
      studio: 'NORTH STUDIO',
      type: WorkType.vfx,
      likes: 1500,
      comments: 78,
    ),
    WorkModel(
      id: 'w6',
      title: 'Liminal — AI Generated',
      studio: 'SYNTHWAVE LAB',
      type: WorkType.ai,
      likes: 2100,
      comments: 145,
    ),
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
      category: 'Video Çekim',
      bio: 'Reklam ve müzik videosu odaklı, set'
          ' deneyimi yüksek videograf.',
      experience: 7,
      location: 'İstanbul',
      rating: 4.9,
      portfolio: const [],
    ),
    FreelancerModel(
      userId: 'u2',
      category: 'Ses',
      bio: 'Reklam, dizi ve kısa film için ses tasarımı ve mix.',
      experience: 5,
      location: 'Ankara',
      rating: 4.7,
      portfolio: const [],
    ),
    FreelancerModel(
      userId: 'u3',
      category: 'Kurgu',
      bio: 'Sosyal medya ve reklam kurguları, hızlı teslim.',
      experience: 4,
      location: 'İzmir',
      rating: 4.8,
      portfolio: const [],
    ),
    FreelancerModel(
      userId: 'u4',
      category: 'CGI & AI',
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
      category: 'Fotoğraf',
      bio: 'Marka kampanyaları ve editorial fotoğraf.',
      experience: 8,
      location: 'İstanbul',
      rating: 4.95,
      portfolio: const [],
    ),
  ];
}
