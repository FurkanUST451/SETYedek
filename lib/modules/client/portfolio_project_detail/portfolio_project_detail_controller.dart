import 'package:get/get.dart';

import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/portfolio_project_model.dart';

enum PortfolioDetailTab { overview, team, process }

class PortfolioProjectDetailController extends GetxController {
  late final PortfolioProjectModel project;

  final Rx<PortfolioDetailTab> activeTab = PortfolioDetailTab.overview.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic> && args['project'] is PortfolioProjectModel) {
      project = args['project'] as PortfolioProjectModel;
    } else if (args is Map<String, dynamic> && args['workId'] is String) {
      project = _findById(args['workId'] as String, args['title'] as String?,
          args['category'] as String?);
    } else {
      project = DummyData.portfolioProjects.first;
    }
  }

  PortfolioProjectModel _findById(String id, String? title, String? category) {
    return DummyData.portfolioProjects.firstWhere(
      (p) => p.id == id,
      orElse: () => PortfolioProjectModel.placeholderFor(
        id: id,
        title: title ?? 'Proje',
        category: category ?? 'Video Çekim',
      ),
    );
  }

  void selectTab(PortfolioDetailTab tab) => activeTab.value = tab;
}
