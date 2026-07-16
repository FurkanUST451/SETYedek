import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/work_model.dart';

class WorkRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _works =>
      _db.collection('works');

  Future<void> createWork(WorkModel work) => _works.doc(work.id).set(work.toJson());

  Stream<List<WorkModel>> watchAll() {
    return _works.snapshots().map((snapshot) {
      final list =
          snapshot.docs.map((d) => WorkModel.fromJson(d.data())).toList();
      list.sort((a, b) {
        final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad);
      });
      return list;
    });
  }
}
