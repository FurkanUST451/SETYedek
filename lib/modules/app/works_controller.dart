import 'dart:async';

import 'package:get/get.dart';

import '../../data/dummy/dummy_data.dart';
import '../../data/models/work_model.dart';
import '../../data/repositories/work_repository.dart';

/// Keşfet akışını besleyen paylaşılan controller.
/// Firestore'a yüklenen gerçek işleri, tanıtım amaçlı dummy işlerin
/// üzerine ekler (en yeni yüklenen en üstte görünür).
class WorksController extends GetxController {
  WorksController({WorkRepository? repository})
      : _repo = repository ?? Get.find<WorkRepository>();

  final WorkRepository _repo;
  final RxList<WorkModel> uploadedWorks = <WorkModel>[].obs;
  StreamSubscription<List<WorkModel>>? _sub;

  List<WorkModel> get works => [...uploadedWorks, ...DummyData.works];

  @override
  void onInit() {
    super.onInit();
    _sub = _repo.watchAll().listen((list) => uploadedWorks.assignAll(list));
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
