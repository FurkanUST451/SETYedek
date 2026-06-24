import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/freelancer_model.dart';

class FreelancerRepository {
  FreelancerRepository();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('freelancers');

  Future<void> upsertFreelancer(FreelancerModel freelancer) async {
    await _col.doc(freelancer.userId).set(
          freelancer.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<List<FreelancerModel>> fetchAll() async {
    final snapshot = await _col.get();
    return snapshot.docs
        .map((doc) => FreelancerModel.fromJson(doc.data()))
        .toList();
  }

  Future<FreelancerModel?> fetchByUserId(String userId) async {
    final doc = await _col.doc(userId).get();
    if (!doc.exists || doc.data() == null) return null;
    return FreelancerModel.fromJson(doc.data()!);
  }

  Future<List<FreelancerModel>> filterByCategory(String category) async {
    final snapshot = await _col
        .where('categories', arrayContains: category)
        .get();
    return snapshot.docs
        .map((doc) => FreelancerModel.fromJson(doc.data()))
        .toList();
  }
}
