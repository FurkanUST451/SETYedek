import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/project_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../app/auth_controller.dart';
import '../../../app/user_controller.dart';
import '../client_projects_controller.dart';

class ClientProfileTab extends StatelessWidget {
  const ClientProfileTab({super.key});

  static const _amber = Color(0xFFE8B84B);

  static const _fullMonths = [
    '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>();
    final auth = Get.find<AuthController>();
    final projectsController = Get.find<ClientProjectsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 12, 0),
              child: Row(
                children: [
                  const SizedBox(width: 44),
                  Expanded(
                    child: Text(
                      'Profilim',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.black54),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                child: Obx(() {
                  final u = user.currentUser;
                  final name = u?.name ?? 'Kullanıcı';
                  final initials = name
                      .split(' ')
                      .take(2)
                      .map((e) => e.isNotEmpty ? e[0] : '')
                      .join()
                      .toUpperCase();
                  final joined = u != null
                      ? '${_fullMonths[u.createdAt.month]} ${u.createdAt.year} tarihinde katıldı'
                      : '';

                  return Column(
                    children: [
                      // ── Avatar (left) + name/joined (right) ──────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: _amber,
                                  shape: BoxShape.circle,
                                  image: u?.avatarUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(u!.avatarUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: u?.avatarUrl == null
                                    ? Text(
                                        initials,
                                        style: AppTextStyles.heading2.copyWith(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppTextStyles.heading2.copyWith(
                                      color: Colors.black87,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (joined.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 13,
                                            color: Colors.black38),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            joined,
                                            style:
                                                AppTextStyles.caption.copyWith(
                                              color: Colors.black45,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: Colors.black.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.edit_outlined,
                                  size: 15, color: Colors.black87),
                              const SizedBox(width: 6),
                              Text(
                                'Profili Düzenle',
                                style: AppTextStyles.button.copyWith(
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Projelerim stats ─────────────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Projelerim',
                          style: AppTextStyles.heading3.copyWith(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildStatsRow(projectsController),
                      const SizedBox(height: 24),

                      // ── Hakkımda ──────────────────────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hakkımda',
                          style: AppTextStyles.heading3.copyWith(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'Henüz bir açıklama eklemedin. "Profili Düzenle" ile kendini ve neler aradığını anlat.',
                          style: AppTextStyles.body2.copyWith(
                            color: Colors.black54,
                            fontSize: 13,
                            height: 1.55,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Hesap ─────────────────────────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hesap',
                          style: AppTextStyles.heading3.copyWith(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _SettingsRow(
                              icon: Icons.notifications_none_rounded,
                              label: 'Bildirimler',
                              onTap: () {},
                            ),
                            const _RowDivider(),
                            _SettingsRow(
                              icon: Icons.lock_outline_rounded,
                              label: 'Gizlilik',
                              onTap: () {},
                            ),
                            const _RowDivider(),
                            _SettingsRow(
                              icon: Icons.help_outline_rounded,
                              label: 'Yardım Merkezi',
                              onTap: () {},
                            ),
                            const _RowDivider(),
                            _SettingsRow(
                              icon: Icons.info_outline_rounded,
                              label: 'Hakkımızda',
                              onTap: () {},
                            ),
                            const _RowDivider(),
                            _SettingsRow(
                              icon: Icons.logout_rounded,
                              label: 'Çıkış Yap',
                              danger: true,
                              showChevron: false,
                              onTap: () async {
                                await auth.logout();
                                Get.offAllNamed(AppRoutes.login);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(ClientProjectsController controller) {
    return Obx(() {
      final created = controller.briefs.length;
      final ongoing = controller.projects
          .where((p) => p.status == ProjectStatus.active)
          .length;
      final completed = controller.projects
          .where((p) => p.status == ProjectStatus.completed)
          .length;

      return Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.folder_outlined,
              iconBg: const Color(0xFFE9E4F7),
              iconColor: const Color(0xFF7B61FF),
              value: created,
              label: 'Oluşturulan\nProje',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: Icons.play_circle_outline_rounded,
              iconBg: const Color(0xFFFCEBD9),
              iconColor: const Color(0xFFE8882A),
              value: ongoing,
              label: 'Devam Eden\nProje',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: Icons.check_circle_outline_rounded,
              iconBg: const Color(0xFFE1F3E4),
              iconColor: const Color(0xFF2E7D32),
              value: completed,
              label: 'Tamamlanan\nProje',
            ),
          ),
        ],
      );
    });
  }
}

// ─── Stat card ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            '$value',
            style: AppTextStyles.heading2.copyWith(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: Colors.black45,
              fontSize: 10.5,
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Settings row ────────────────────────────────────────────────────────────

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.onTap,
    this.danger = false,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool danger;
  final bool showChevron;

  static const _iconBg = Color(0xFFF5EBD8);

  @override
  Widget build(BuildContext context) {
    final labelColor = danger ? Colors.red.shade600 : Colors.black87;
    final iconBgColor = danger ? Colors.red.shade50 : _iconBg;
    final iconColor = danger ? Colors.red.shade400 : const Color(0xFF8D6E63);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 19, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body2.copyWith(
                  color: labelColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showChevron)
              const Icon(Icons.chevron_right, color: Colors.black26, size: 18),
          ],
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 52,
      color: Colors.black.withValues(alpha: 0.06),
    );
  }
}
