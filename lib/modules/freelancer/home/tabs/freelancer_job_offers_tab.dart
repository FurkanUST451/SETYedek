import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/brief_model.dart';
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
                    itemBuilder: (_, i) =>
                        _OfferCard(brief: controller.offers[i]),
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
// Offer card
// ---------------------------------------------------------------------------

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.brief});

  final BriefModel brief;

  String get _displayTitle =>
      brief.title.isNotEmpty ? brief.title : brief.category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
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
                      if (brief.category.isNotEmpty)
                        Text(
                          brief.category,
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

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _OfferDetailSheet(brief: brief),
    );
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
// Offer detail bottom sheet
// ---------------------------------------------------------------------------

class _OfferDetailSheet extends StatelessWidget {
  const _OfferDetailSheet({required this.brief});

  final BriefModel brief;

  String get _displayTitle =>
      brief.title.isNotEmpty ? brief.title : brief.category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      decoration: const BoxDecoration(
        color: Color(0xFFF5EBD8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _displayTitle,
            style: AppTextStyles.heading2.copyWith(
              color: Colors.black87,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            brief.category,
            style: AppTextStyles.caption.copyWith(color: Colors.black45),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 6,
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
              if (brief.answers.deliveryTime != null)
                _InfoChip(
                  icon: Icons.timer_outlined,
                  label: 'Teslim: ${brief.answers.deliveryTime!}',
                ),
            ],
          ),
          if (brief.answers.notes != null &&
              brief.answers.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'BRIEF',
              style: AppTextStyles.caption.copyWith(
                color: Colors.black45,
                letterSpacing: 1.2,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                brief.answers.notes!,
                style: AppTextStyles.body2.copyWith(
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
            ),
          ],
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
