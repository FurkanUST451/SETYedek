import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/brief_model.dart';

class BriefRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _briefs =>
      _db.collection('briefs');

  Future<void> saveBrief(BriefModel brief) async {
    await _briefs.doc(brief.id).set(brief.toJson());
  }

  Future<List<BriefModel>> fetchByOwner(String ownerId) async {
    final snapshot = await _briefs
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((d) => BriefModel.fromJson(d.data()))
        .toList();
  }
}
