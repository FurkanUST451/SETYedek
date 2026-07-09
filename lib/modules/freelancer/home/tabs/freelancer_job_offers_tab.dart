import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/brief_model.dart';
import '../../../../data/models/project_model.dart';
import '../../../../routes/app_routes.dart';
import '../freelancer_job_offers_controller.dart';

class FreelancerJobOffersTab extends GetView<FreelancerJobOffersController> {
  const FreelancerJobOffersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBD8),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İş Teklifleri',
                    style: AppTextStyles.displayXL.copyWith(
                      color: Colors.black87,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sana gelen proje teklifleri.',
                    style: AppTextStyles.body2.copyWith(color: Colors.black45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE8B84B),
                    ),
                  );
                }
                if (controller.offers.isEmpty) {
                  return const _EmptyState();
                }
                return RefreshIndicator(
                  color: const Color(0xFFE8B84B),
                  onRefresh: controller.loadOffers,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    itemCount: controller.offers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final brief = controller.offers[i];
                      final project =
                          controller.acceptedProjectsByBriefId[brief.id];
                      if (project != null) {
                        return _AcceptedCard(brief: brief, project: project);
                      }
                      return _OfferCard(
                        brief: brief,
                        onReload: controller.loadOffers,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Accepted (simplified) card
// ---------------------------------------------------------------------------

class _AcceptedCard extends StatelessWidget {
  const _AcceptedCard({required this.brief, required this.project});

  final BriefModel brief;
  final ProjectModel project;

  String get _displayTitle =>
      brief.title.isNotEmpty ? brief.title : brief.category;

  String get _displaySubtitle {
    final shootingType = brief.answers.shootingType;
    if (shootingType != null && shootingType.isNotEmpty) {
      return shootingType;
    }
    return brief.category;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.25)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_circle_outline,
                size: 18, color: Color(0xFF2E7D32)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayTitle,
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_displaySubtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _displaySubtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.black38,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${project.budget.toStringAsFixed(0)} ₺',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF2E7D32),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Kabul Edildi',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF2E7D32),
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Offer card
// ---------------------------------------------------------------------------

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.brief, required this.onReload});

  final BriefModel brief;
  final Future<void> Function() onReload;

  String get _displayTitle =>
      brief.title.isNotEmpty ? brief.title : brief.category;

  String get _displaySubtitle {
    final shootingType = brief.answers.shootingType;
    if (shootingType != null && shootingType.isNotEmpty) {
      return shootingType;
    }
    return brief.category;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openDetail,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayTitle,
                        style: AppTextStyles.heading3.copyWith(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 3),
                      if (_displaySubtitle.isNotEmpty)
                        Text(
                          _displaySubtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8B84B).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Yeni',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFB8860B),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (brief.answers.budget != null ||
                brief.answers.dateRange != null) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (brief.answers.budget != null)
                    _InfoChip(
                      icon: Icons.monetization_on_outlined,
                      label: brief.answers.budget!,
                    ),
                  if (brief.answers.dateRange != null)
                    _InfoChip(
                      icon: Icons.calendar_today_outlined,
                      label: brief.answers.dateRange!,
                    ),
                  if (brief.answers.location != null)
                    _InfoChip(
                      icon: Icons.location_on_outlined,
                      label: brief.answers.location!,
                    ),
                ],
              ),
            ],
            if (brief.answers.notes != null &&
                brief.answers.notes!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                brief.answers.notes!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body2.copyWith(
                  color: Colors.black45,
                  height: 1.5,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                'İncele  →',
                style: AppTextStyles.button.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDetail() async {
    final result = await Get.toNamed(
      AppRoutes.freelancerOfferDetail,
      arguments: {'brief': brief},
    );
    if (result == 'rejected') {
      await onReload();
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E8DC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF8D6E63)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.black54,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 34,
              color: Colors.black26,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz teklif yok',
            style: AppTextStyles.heading3.copyWith(color: Colors.black45),
          ),
          const SizedBox(height: 6),
          Text(
            'Müşteriler teklif gönderince burada görünür.',
            style: AppTextStyles.body2.copyWith(color: Colors.black26),
          ),
        ],
      ),
    );
  }
}
