import '../dummy/dummy_data.dart';
import '../models/freelancer_model.dart';

/// Freelancer repository — şimdilik dummy data döner.
class FreelancerRepository {
  FreelancerRepository();

  Future<List<FreelancerModel>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return DummyData.freelancers;
  }

  Future<FreelancerModel?> fetchByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return DummyData.freelancers.firstWhere((f) => f.userId == userId);
    } catch (_) {
      return null;
    }
  }

  Future<List<FreelancerModel>> filterByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.freelancers
        .where((f) => f.category == category)
        .toList();
  }
}
