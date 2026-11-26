import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/theme/theme_models.dart';
import '../../core/widgets/glass_components.dart';
import '../../data/prayer/prayer_service.dart';

class HomeScreen extends StatefulWidget {
  final ThemeController themeController;
  final void Function(int tabIndex, {String? adhkarCategory}) onNavigateTab;

  const HomeScreen({
    super.key,
    required this.themeController,
    required this.onNavigateTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PrayerService _prayerService = PrayerService();
  PrayerTimesBundle? _bundle;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPrayers();
  }

  Future<void> _loadPrayers() async {
    setState(() => _loading = true);
    final bundle = await _prayerService.getTodayPrayerTimes();
    if (!mounted) return;
    setState(() {
      _bundle = bundle;
      _loading = false;
    });
  }

  String _formatTime(DateTime dt) {
    final hour24 = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour24 >= 12 ? 'م' : 'ص';
    final hour12 = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
    return '$hour12:$minute $period';
  }

  String _remainingText(DateTime? target) {
    if (target == null) return 'مواقيت اليوم مكتملة';
    final diff = target.difference(DateTime.now());
    if (diff.isNegative) return 'الآن';
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    final seconds = diff.inSeconds.remainder(60);
    return 'متبقي ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _openThemeSheet(AppThemePalette palette) {
    showModalBottomSheet(
      context: context,
      backgroundColor: palette.isDark ? const Color(0xFF152634) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختر ثيم التطبيق (الشكل ٢)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...AppThemeStyle.values.map((style) {
                final itemPalette = AppThemePalette.fromStyle(style);
                final selected = widget.themeController.appThemeStyle == style;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: itemPalette.primaryColor,
                    child: const Icon(
                      Icons.palette_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  title: Text(
                    itemPalette.name,
                    style: TextStyle(color: palette.textPrimary),
                  ),
                  trailing: selected
                      ? Icon(Icons.check_circle, color: palette.primaryColor)
                      : null,
                  onTap: () {
                    widget.themeController.setAppTheme(style);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.themeController.appPalette;
    final isMorning = DateTime.now().hour < 14;

    return AppGradientBackground(
      palette: palette,
      child: RefreshIndicator(
        onRefresh: _loadPrayers,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نبض اليوم',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    Text(
                      _bundle?.cityName ?? 'الرياض',
                      style: TextStyle(
                        fontSize: 13,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _openThemeSheet(palette),
                  icon: Icon(Icons.color_lens_outlined, color: palette.primaryColor),
                  tooltip: 'تغيير ثيم التطبيق',
                ),
              ],
            ),
            const SizedBox(height: 12),
            GlassSurfaceCard(
              palette: palette,
              onTap: () => widget.onNavigateTab(3),
              child: _loading || _bundle == null
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          'الصلاة القادمة: ${PrayerService.prayerArabicName(_bundle!.nextPrayer)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: palette.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _remainingText(_bundle!.nextPrayerTime),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _miniPrayerItem('الفجر', _formatTime(_bundle!.fajr), palette),
                            _miniPrayerItem('الظهر', _formatTime(_bundle!.dhuhr), palette),
                            _miniPrayerItem('العصر', _formatTime(_bundle!.asr), palette),
                            _miniPrayerItem('المغرب', _formatTime(_bundle!.maghrib), palette),
                            _miniPrayerItem('العشاء', _formatTime(_bundle!.isha), palette),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _quickCircleButton(
                  palette: palette,
                  icon: Icons.wb_sunny_outlined,
                  label: isMorning ? 'أذكار الصباح' : 'أذكار المساء',
                  onTap: () => widget.onNavigateTab(
                    2,
                    adhkarCategory: isMorning ? 'أذكار الصباح' : 'أذكار المساء',
                  ),
                ),
                _quickCircleButton(
                  palette: palette,
                  icon: Icons.menu_book_rounded,
                  label: 'الختمة',
                  onTap: () => widget.onNavigateTab(1),
                ),
                _quickCircleButton(
                  palette: palette,
                  icon: Icons.shield_outlined,
                  label: 'حصن المسلم',
                  onTap: () => widget.onNavigateTab(2, adhkarCategory: 'حصن المسلم'),
                ),
                _quickCircleButton(
                  palette: palette,
                  icon: Icons.touch_app_outlined,
                  label: 'السبحة (${widget.themeController.tasbeehCount})',
                  onTap: () => widget.onNavigateTab(2),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GlassSurfaceCard(
              palette: palette,
              onTap: () => widget.onNavigateTab(1),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: palette.accentGold.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.auto_stories, color: palette.accentGold),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'استئناف الختمة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'صفحة ${widget.themeController.khatmahPage} من 604',
                          style: TextStyle(
                            fontSize: 13,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_back_ios_new, size: 16, color: palette.primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniPrayerItem(String name, String time, AppThemePalette palette) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 12, color: palette.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: palette.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _quickCircleButton({
    required AppThemePalette palette,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: palette.glassFill,
              shape: BoxShape.circle,
              border: Border.all(color: palette.glassBorder, width: 1.4),
            ),
            child: Icon(icon, color: palette.primaryColor),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 76,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: palette.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
