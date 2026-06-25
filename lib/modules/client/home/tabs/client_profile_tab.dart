import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../app/auth_controller.dart';
import '../../../app/user_controller.dart';

class ClientProfileTab extends StatefulWidget {
  const ClientProfileTab({super.key});

  @override
  State<ClientProfileTab> createState() => _ClientProfileTabState();
}

class _ClientProfileTabState extends State<ClientProfileTab> {
  bool _twoFactor = true;

  static const _cream = Color(0xFFF5EBD8);
  static const _amber = Color(0xFFE8B84B);
  static const _dark = Color(0xFF1A1200);

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>();
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: _cream,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHero(user)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _buildSection('HESAP', [
                  _SettingsRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Profili Düzenle',
                    sub: 'Ad, bio, konum, dil',
                    onTap: () {},
                  ),
                  _SettingsRow(
                    icon: Icons.email_outlined,
                    label: 'E-posta & Telefon',
                    sub: 'İletişim bilgilerini güncelle',
                    onTap: () {},
                  ),
                  _SettingsRow(
                    icon: Icons.lock_outline_rounded,
                    label: 'Şifre Değiştir',
                    onTap: () {},
                  ),
                  _SettingsRow(
                    icon: Icons.security_outlined,
                    label: 'İki Faktörlü Doğrulama',
                    sub: 'Hesabını güvende tut',
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _twoFactor,
                        onChanged: (v) => setState(() => _twoFactor = v),
                        activeColor: Colors.white,
                        activeTrackColor: _amber,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.black12,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 20),
                _buildSection('ÖDEME', [
                  _SettingsRow(
                    icon: Icons.credit_card_outlined,
                    label: 'Ödeme Yöntemleri',
                    sub: 'Kart, havale',
                    onTap: () {},
                  ),
                  _SettingsRow(
                    icon: Icons.receipt_long_outlined,
                    label: 'Sipariş Geçmişi',
                    sub: 'Tüm fatura ve ödemeler',
                    badge: '3 Yeni',
                    onTap: () {},
                  ),
                  _SettingsRow(
                    icon: Icons.business_outlined,
                    label: 'Fatura Bilgileri',
                    sub: 'Şirket adı, vergi no',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 20),
                _buildSection('TERCİHLER', [
                  _SettingsRow(
                    icon: Icons.notifications_none_rounded,
                    label: 'Bildirimler',
                    sub: 'Push, e-posta tercihleri',
                    onTap: () {},
                  ),
                  _SettingsRow(
                    icon: Icons.language_outlined,
                    label: 'Dil & Bölge',
                    sub: 'Türkçe',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 20),
                _buildSection('DESTEK', [
                  _SettingsRow(
                    icon: Icons.help_outline_rounded,
                    label: 'Yardım Merkezi',
                    onTap: () {},
                  ),
                  _SettingsRow(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Bize Ulaş',
                    onTap: () {},
                  ),
                  _SettingsRow(
                    icon: Icons.description_outlined,
                    label: 'Kullanım Koşulları',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 20),
                _buildSection('OTURUM', [
                  _SettingsRow(
                    icon: Icons.swap_horiz_rounded,
                    label: 'Rolümü Değiştir',
                    onTap: () => Get.offAllNamed(AppRoutes.roleSelection),
                  ),
                  _SettingsRow(
                    icon: Icons.logout_rounded,
                    label: 'Çıkış Yap',
                    danger: true,
                    onTap: () async {
                      await auth.logout();
                      Get.offAllNamed(AppRoutes.login);
                    },
                  ),
                  _SettingsRow(
                    icon: Icons.delete_outline_rounded,
                    label: 'Hesabı Sil',
                    danger: true,
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'SET v1.0.0 · Tüm hakları saklıdır',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.black38,
                      fontSize: 11,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(UserController user) {
    return SizedBox(
      height: 260,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(AppAssets.choosePageBg, fit: BoxFit.cover, cacheWidth: 1080),
          ),
          // Gradient fade to cream
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    _cream.withValues(alpha: 0.55),
                    _cream,
                  ],
                  stops: const [0.25, 0.7, 1.0],
                ),
              ),
            ),
          ),
          // Top SET wordmark
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'SE',
                        style: AppTextStyles.heading2.copyWith(
                          color: Colors.black87,
                          fontSize: 20,
                          letterSpacing: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'T',
                        style: AppTextStyles.heading2.copyWith(
                          color: _amber,
                          fontSize: 20,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          // User info row at bottom
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: Obx(() {
              final u = user.currentUser;
              final name = u?.name ?? 'Misafir';
              final initials = name
                  .split(' ')
                  .take(2)
                  .map((e) => e.isNotEmpty ? e[0] : '')
                  .join()
                  .toUpperCase();
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Avatar
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: _amber,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: AppTextStyles.heading2.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: _amber,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'MÜŞTERİ',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          name,
                          style: AppTextStyles.heading2.copyWith(
                            color: _dark,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          u?.email ?? '',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.black45,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profili Görüntüle
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Profili',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.black45,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          'Görüntüle',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.black45,
                            fontSize: 11,
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: Colors.black26, size: 16),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: Colors.black38,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
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
              for (int i = 0; i < rows.length; i++) ...[
                rows[i],
                if (i < rows.length - 1)
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    indent: 52,
                    endIndent: 0,
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Settings Row ─────────────────────────────────────────────────────────────

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.sub,
    this.onTap,
    this.badge,
    this.trailing,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final String? sub;
  final VoidCallback? onTap;
  final String? badge;
  final Widget? trailing;
  final bool danger;

  static const _amber = Color(0xFFE8B84B);
  static const _iconBg = Color(0xFFF5EBD8);

  @override
  Widget build(BuildContext context) {
    final labelColor = danger ? Colors.red.shade600 : Colors.black87;
    final iconBgColor = danger ? Colors.red.shade50 : _iconBg;
    final iconColor =
        danger ? Colors.red.shade400 : const Color(0xFF8D6E63);

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.body2.copyWith(
                      color: labelColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      sub!,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.black38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge!,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            if (trailing != null)
              trailing!
            else if (onTap != null && !danger)
              const Icon(Icons.chevron_right,
                  color: Colors.black26, size: 18),
          ],
        ),
      ),
    );
  }
}
