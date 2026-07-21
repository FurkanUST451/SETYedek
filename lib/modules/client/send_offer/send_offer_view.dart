import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'send_offer_controller.dart';

// ─── Palet ────────────────────────────────────────────────────────────────────
const _kCream = Color(0xFFFEFDFB);
const _kGold = Color(0xFFD9A84E);
const _kInk = Color(0xFF35333F);
const _kTaupe = Color(0xFF9B8E7B);
const _kMuted = Color(0xFFB6AD9A);
const _kBlack = Color(0xFF000000); // mono etiket fontu - tam siyah
const _kCardBorder = Color(0x14000000);
const _kDivider = Color(0x0F000000);

TextStyle _serif({
  required double size,
  FontWeight weight = FontWeight.w500,
  required Color color,
  double height = 1.05,
}) =>
    GoogleFonts.cormorantGaramond(
        fontSize: size, fontWeight: weight, color: color, height: height);

TextStyle _mono({
  required double size,
  FontWeight weight = FontWeight.w400,
  required Color color,
  double spacing = 0.5,
  double height = 1.4,
}) =>
    GoogleFonts.spaceMono(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: spacing,
        height: height);

Widget _wordmark(double s) => RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'SE',
          style: GoogleFonts.spaceGrotesk(
              fontSize: 18 * s,
              fontWeight: FontWeight.w700,
              color: _kInk,
              letterSpacing: 2.5),
        ),
        TextSpan(
          text: 'T',
          style: GoogleFonts.spaceGrotesk(
              fontSize: 18 * s,
              fontWeight: FontWeight.w800,
              color: _kGold,
              letterSpacing: 2.5),
        ),
      ]),
    );

class SendOfferView extends GetView<SendOfferController> {
  const SendOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    final double s =
        (MediaQuery.sizeOf(context).width / 390).clamp(0.85, 1.15).toDouble();

    return Scaffold(
      backgroundColor: _kCream,
      body: MediaQuery.withNoTextScaling(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 48 * s,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Get.back<void>(),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: EdgeInsets.all(12 * s),
                          child: Icon(Icons.arrow_back_rounded,
                              size: 22 * s, color: _kInk),
                        ),
                      ),
                    ),
                    _wordmark(s),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(0, 12 * s, 0, 24 * s),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24 * s),
                        child: Text(
                          (controller.category.isNotEmpty
                                  ? controller.category
                                  : 'Video Çekim')
                              .toUpperCase(),
                          style:
                              _mono(size: 8 * s, color: _kBlack, spacing: 1.5),
                        ),
                      ),
                      SizedBox(height: 8 * s),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24 * s),
                        child: Text(
                          controller.isEditMode
                              ? "Brief'ini\ngüncelle."
                              : "Doğru brief'i\noluşturalım.",
                          style: _serif(
                              size: 40 * s,
                              weight: FontWeight.w600,
                              color: _kInk,
                              height: 1.05),
                        ),
                      ),
                      SizedBox(height: 8 * s),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24 * s),
                        child: Text(
                            'Projene en uygun kreatif ekibi eşleştirelim.',
                            style: _mono(
                                size: 9 * s, color: _kBlack, spacing: 0.2)),
                      ),
                      SizedBox(height: 24 * s),

                      _ShootingTypeRow(scale: s, controller: controller),
                      SizedBox(height: 10 * s),

                      _DateRow(scale: s, controller: controller),
                      SizedBox(height: 10 * s),

                      Obx(() => _BriefRow(
                            scale: s,
                            icon: Icons.hourglass_empty_rounded,
                            label: 'Teslim Süresi',
                            value: controller.selectedDelivery.value,
                            onTap: () => _showPicker(
                              context,
                              title: 'Teslim Süresi',
                              options: SendOfferController.deliveryOptions,
                              selected: controller.selectedDelivery.value,
                              onSelect: (v) =>
                                  controller.selectedDelivery.value = v,
                            ),
                          )),
                      SizedBox(height: 10 * s),

                      Obx(() => _BriefRow(
                            scale: s,
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Bütçe Aralığı',
                            value: controller.selectedBudget.value,
                            onTap: () => _showPicker(
                              context,
                              title: 'Bütçe Aralığı',
                              options: SendOfferController.budgetOptions,
                              selected: controller.selectedBudget.value,
                              onSelect: (v) =>
                                  controller.selectedBudget.value = v,
                            ),
                          )),

                      if (controller.showLocation) ...[
                        SizedBox(height: 10 * s),
                        Obx(() => _BriefRow(
                              scale: s,
                              icon: Icons.location_on_outlined,
                              label: 'Lokasyon',
                              value: controller.selectedLocation.value,
                              onTap: () => _showPicker(
                                context,
                                title: 'Lokasyon',
                                options: SendOfferController.locationOptions,
                                selected: controller.selectedLocation.value,
                                onSelect: (v) =>
                                    controller.selectedLocation.value = v,
                              ),
                            )),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24 * s, 10 * s, 24 * s, 14 * s),
                child: Column(
                  children: [
                    Obx(() => GestureDetector(
                          onTap: controller.isSubmitting.value
                              ? null
                              : controller.submit,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: double.infinity,
                            height: 54 * s,
                            color: _kGold,
                            alignment: Alignment.center,
                            child: controller.isSubmitting.value
                                ? SizedBox(
                                    width: 22 * s,
                                    height: 22 * s,
                                    child: const CircularProgressIndicator(
                                        strokeWidth: 2.4, color: Colors.white),
                                  )
                                : Text('DEVAM ET  →',
                                    style: _mono(
                                        size: 11 * s,
                                        weight: FontWeight.w700,
                                        color: Colors.white,
                                        spacing: 1.5)),
                          ),
                        )),
                    SizedBox(height: 14 * s),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 11 * s, color: _kMuted),
                        SizedBox(width: 5 * s),
                        Flexible(
                          child: Text(
                            'Tüm bilgilerin güvenliği SET güvencesiyle korunur.',
                            style: _mono(
                                size: 8 * s, color: _kBlack, spacing: 0.2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showPicker(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String selected,
    required void Function(String) onSelect,
  }) {
    final s =
        (MediaQuery.sizeOf(context).width / 390).clamp(0.85, 1.15).toDouble();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _kCream,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (_) => MediaQuery.withNoTextScaling(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12 * s),
              Container(width: 36 * s, height: 3, color: Colors.black12),
              Padding(
                padding: EdgeInsets.fromLTRB(24 * s, 16 * s, 24 * s, 8 * s),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(title,
                      style: _serif(
                          size: 22 * s,
                          weight: FontWeight.w600,
                          color: _kInk)),
                ),
              ),
              ...options.map((o) => InkWell(
                    onTap: () {
                      onSelect(o);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24 * s, vertical: 14 * s),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: _kDivider)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(o,
                                style: _serif(
                                    size: 16 * s,
                                    weight: o == selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: _kInk)),
                          ),
                          if (o == selected)
                            Icon(Icons.check_rounded,
                                color: _kGold, size: 20 * s),
                        ],
                      ),
                    ),
                  )),
              SizedBox(height: 16 * s),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Çekim Türü — aynı kart içinde aşağı doğru açılır liste ───────────────────
class _ShootingTypeRow extends StatelessWidget {
  const _ShootingTypeRow({required this.scale, required this.controller});

  final double scale;
  final SendOfferController controller;

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Obx(() {
      final expanded = controller.isShootingTypeExpanded.value;
      final selected = controller.selectedShootingType.value;
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border.fromBorderSide(BorderSide(color: _kCardBorder)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: controller.toggleShootingTypeExpanded,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 14 * s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.movie_creation_outlined, size: 18 * s, color: _kTaupe),
                        SizedBox(width: 12 * s),
                        Text('ÇEKİM TÜRÜ',
                            style: _mono(size: 8 * s, color: _kBlack, spacing: 1.2)),
                        const Spacer(),
                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: _kMuted,
                          size: 20 * s,
                        ),
                      ],
                    ),
                    if (selected.isNotEmpty) ...[
                      SizedBox(height: 4 * s),
                      Padding(
                        padding: EdgeInsets.only(left: 30 * s),
                        child: Text(selected,
                            style: _serif(
                                size: 18 * s, weight: FontWeight.w600, color: _kInk)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: !expanded
                  ? const SizedBox.shrink()
                  : Column(
                      children: SendOfferController.shootingTypes.map((o) {
                        final active = o == selected;
                        return InkWell(
                          onTap: () => controller.selectShootingType(o),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(
                                16 * s, 12 * s, 16 * s, 12 * s),
                            decoration:
                                const BoxDecoration(border: Border(top: BorderSide(color: _kDivider))),
                            child: Row(
                              children: [
                                SizedBox(width: 30 * s),
                                Expanded(
                                  child: Text(o,
                                      style: _serif(
                                          size: 15 * s,
                                          weight: active ? FontWeight.w700 : FontWeight.w500,
                                          color: _kInk)),
                                ),
                                if (active)
                                  Icon(Icons.check_rounded, color: _kGold, size: 18 * s),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      );
    });
  }
}

// ─── Çekim tarihi belirli mi? — toggle + takvim ────────────────────────────────
class _DateRow extends StatelessWidget {
  const _DateRow({required this.scale, required this.controller});

  final double scale;
  final SendOfferController controller;

  Future<void> _pickRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDialog<DateTimeRange>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => _DateRangeDialog(
        firstDate: DateTime(now.year, now.month, now.day),
        lastDate: now.add(const Duration(days: 365)),
      ),
    );
    if (picked != null) controller.setPickedDateRange(picked);
  }

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Obx(() {
      final hasFixedDate = controller.hasFixedDate.value;
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border.fromBorderSide(BorderSide(color: _kCardBorder)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 14 * s),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_outlined, size: 18 * s, color: _kTaupe),
                  SizedBox(width: 12 * s),
                  Expanded(
                    child: Text('Çekim tarihi belirli mi?',
                        style: _serif(size: 15 * s, weight: FontWeight.w600, color: _kInk)),
                  ),
                  Transform.scale(
                    scale: 0.8 * s,
                    child: Switch(
                      value: hasFixedDate,
                      onChanged: controller.setHasFixedDate,
                      activeThumbColor: Colors.white,
                      activeTrackColor: _kGold,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.black12,
                    ),
                  ),
                ],
              ),
            ),
            if (hasFixedDate)
              InkWell(
                onTap: () => _pickRange(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(16 * s, 0, 16 * s, 14 * s),
                  child: Row(
                    children: [
                      SizedBox(width: 30 * s),
                      Expanded(
                        child: Text(
                          controller.dateRangeLabel.value.isEmpty
                              ? 'Tarih aralığı seç'
                              : controller.dateRangeLabel.value,
                          style: _serif(
                            size: 16 * s,
                            weight: FontWeight.w600,
                            color: controller.dateRangeLabel.value.isEmpty ? _kMuted : _kInk,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: _kMuted, size: 18 * s),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

// ─── Brief satırı (keskin kart) ───────────────────────────────────────────────
class _BriefRow extends StatelessWidget {
  const _BriefRow({
    required this.scale,
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
  });

  final double scale;
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 14 * s),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border.fromBorderSide(BorderSide(color: _kCardBorder)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18 * s, color: _kTaupe),
                SizedBox(width: 12 * s),
                Text(label.toUpperCase(),
                    style: _mono(size: 8 * s, color: _kBlack, spacing: 1.2)),
                const Spacer(),
                Icon(Icons.chevron_right, color: _kMuted, size: 18 * s),
              ],
            ),
            if (value != null && value!.isNotEmpty) ...[
              SizedBox(height: 4 * s),
              Padding(
                padding: EdgeInsets.only(left: 30 * s),
                child: Text(value!,
                    style: _serif(
                        size: 18 * s,
                        weight: FontWeight.w600,
                        color: _kInk)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Tarih aralığı seç — küçük, kendi tasarımımıza uygun takvim modalı ────────
const List<String> _kMonthNames = [
  'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
  'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
];
const List<String> _kWeekdayLetters = ['P', 'S', 'Ç', 'P', 'C', 'C', 'P'];

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class _DateRangeDialog extends StatefulWidget {
  const _DateRangeDialog({required this.firstDate, required this.lastDate});

  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_DateRangeDialog> createState() => _DateRangeDialogState();
}

class _DateRangeDialogState extends State<_DateRangeDialog> {
  late DateTime _visibleMonth =
      DateTime(widget.firstDate.year, widget.firstDate.month);
  DateTime? _start;
  DateTime? _end;

  bool get _canGoPrev {
    final prev = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    return !prev.isBefore(
        DateTime(widget.firstDate.year, widget.firstDate.month));
  }

  bool get _canGoNext {
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    return !next.isAfter(
        DateTime(widget.lastDate.year, widget.lastDate.month));
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth =
          DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  void _onDayTap(DateTime day) {
    setState(() {
      if (_start == null || _end != null) {
        _start = day;
        _end = null;
      } else if (day.isBefore(_start!)) {
        _start = day;
      } else {
        _end = day;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s =
        (MediaQuery.sizeOf(context).width / 390).clamp(0.85, 1.15).toDouble();

    final daysInMonth =
        DateUtils.getDaysInMonth(_visibleMonth.year, _visibleMonth.month);
    final firstWeekday =
        DateTime(_visibleMonth.year, _visibleMonth.month, 1).weekday; // 1=Pzt
    final leadingBlanks = firstWeekday - 1;
    final totalCells = leadingBlanks + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 30 * s),
      child: Container(
        padding: EdgeInsets.fromLTRB(20 * s, 18 * s, 20 * s, 20 * s),
        decoration: const BoxDecoration(
          color: _kCream,
          border: Border.fromBorderSide(BorderSide(color: _kCardBorder)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Tarih aralığı seç',
                      style: _serif(
                          size: 19 * s,
                          weight: FontWeight.w600,
                          color: _kInk)),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Icon(Icons.close_rounded,
                      size: 20 * s, color: _kMuted),
                ),
              ],
            ),
            SizedBox(height: 4 * s),
            Text(
              _start == null
                  ? 'Bir başlangıç tarihi seç'
                  : _end == null
                      ? '${_start!.day} ${_kMonthNames[_start!.month - 1]} → bitiş tarihi seç'
                      : '${_start!.day} ${_kMonthNames[_start!.month - 1]} – ${_end!.day} ${_kMonthNames[_end!.month - 1]}',
              style: _mono(size: 8.5 * s, color: _kMuted, spacing: 0.3),
            ),
            SizedBox(height: 14 * s),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _canGoPrev ? () => _changeMonth(-1) : null,
                  behavior: HitTestBehavior.opaque,
                  child: Icon(Icons.chevron_left_rounded,
                      size: 22 * s,
                      color: _canGoPrev ? _kInk : _kCardBorder),
                ),
                Text(
                  '${_kMonthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                  style: _mono(
                      size: 10 * s,
                      weight: FontWeight.w700,
                      color: _kInk,
                      spacing: 1),
                ),
                GestureDetector(
                  onTap: _canGoNext ? () => _changeMonth(1) : null,
                  behavior: HitTestBehavior.opaque,
                  child: Icon(Icons.chevron_right_rounded,
                      size: 22 * s,
                      color: _canGoNext ? _kInk : _kCardBorder),
                ),
              ],
            ),
            SizedBox(height: 10 * s),
            Row(
              children: _kWeekdayLetters
                  .map((d) => Expanded(
                        child: Center(
                          child: Text(d,
                              style: _mono(
                                  size: 8 * s, color: _kMuted, spacing: 0.5)),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 4 * s),
            for (var row = 0; row < rowCount; row++)
              Row(
                children: [
                  for (var col = 0; col < 7; col++)
                    Expanded(
                      child: Builder(builder: (_) {
                        final cellIndex = row * 7 + col;
                        final dayNum = cellIndex - leadingBlanks + 1;
                        if (dayNum < 1 || dayNum > daysInMonth) {
                          return SizedBox(height: 36 * s);
                        }
                        final day = DateTime(
                            _visibleMonth.year, _visibleMonth.month, dayNum);
                        final disabled = day.isBefore(widget.firstDate) ||
                            day.isAfter(widget.lastDate);
                        final isStart =
                            _start != null && _isSameDay(day, _start!);
                        final isEnd = _end != null && _isSameDay(day, _end!);
                        final inRange = _start != null &&
                            _end != null &&
                            day.isAfter(_start!) &&
                            day.isBefore(_end!);

                        return GestureDetector(
                          onTap: disabled ? null : () => _onDayTap(day),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 36 * s,
                            margin: EdgeInsets.symmetric(vertical: 1.5 * s),
                            color: inRange
                                ? _kGold.withValues(alpha: 0.15)
                                : Colors.transparent,
                            alignment: Alignment.center,
                            child: Container(
                              width: 28 * s,
                              height: 28 * s,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (isStart || isEnd)
                                    ? _kGold
                                    : Colors.transparent,
                              ),
                              child: Text(
                                '$dayNum',
                                style: _mono(
                                  size: 10.5 * s,
                                  weight: (isStart || isEnd)
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: disabled
                                      ? _kCardBorder
                                      : (isStart || isEnd)
                                          ? Colors.white
                                          : _kInk,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                ],
              ),
            SizedBox(height: 14 * s),
            GestureDetector(
              onTap: (_start != null && _end != null)
                  ? () => Navigator.pop(
                      context, DateTimeRange(start: _start!, end: _end!))
                  : null,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                height: 46 * s,
                alignment: Alignment.center,
                color: (_start != null && _end != null)
                    ? _kGold
                    : _kMuted.withValues(alpha: 0.35),
                child: Text('UYGULA',
                    style: _mono(
                        size: 10.5 * s,
                        weight: FontWeight.w700,
                        color: Colors.white,
                        spacing: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
