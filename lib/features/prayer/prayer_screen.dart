import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/widgets/glass_components.dart';
import '../../data/prayer/prayer_service.dart';

class PrayerScreen extends StatefulWidget {
  final ThemeController themeController;

  const PrayerScreen({super.key, required this.themeController});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final PrayerService _prayerService = PrayerService();
  PrayerTimesBundle? _bundle;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    final bundle = await _prayerService.getTodayPrayerTimes();
    if (!mounted) return;
    setState(() {
      _bundle = bundle;
      _loading = false;
    });
  }

  Future<void> _useCurrentLocation() async {
    final ok = await _prayerService.requestLocationAndUpdateCity();
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يمكنك اختيار مدينتك يدوياً من القائمة أدناه دون الحاجة للموقع.'),
        ),
      );
    }
    await _refresh();
  }

  String _formatTime(DateTime dt) {
    final hour24 = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour24 >= 12 ? 'م' : 'ص';
    final hour12 = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
    return '$hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.themeController.appPalette;

    return AppGradientBackground(
      palette: palette,
      child: _loading || _bundle == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'مواقيت الصلاة والأذان',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                GlassSurfaceCard(
                  palette: palette,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المدينة الحالية: ${_bundle!.cityName}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: palette.textPrimary,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _useCurrentLocation,
                            icon: Icon(Icons.my_location, size: 18, color: palette.primaryColor),
                            label: Text(
                              'تحديد موقعي',
                              style: TextStyle(color: palette.primaryColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'يُستخدم الموقع الجغرافي فقط لحساب مواقيت الصلاة بدقة، ويمكنك اختيار المدينة يدوياً في أي وقت.',
                        style: TextStyle(fontSize: 12, color: palette.textSecondary),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: PrayerService.cities.map((city) {
                          final selected = _bundle!.cityName == city.name;
                          return ChoiceChip(
                            label: Text(city.name),
                            selected: selected,
                            selectedColor: palette.primaryColor,
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : palette.textPrimary,
                            ),
                            onSelected: (_) async {
                              await _prayerService.saveCity(city);
                              await _refresh();
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                GlassSurfaceCard(
                  palette: palette,
                  child: Column(
                    children: [
                      _prayerRow('الفجر', _formatTime(_bundle!.fajr), palette),
                      _prayerRow('الشروق', _formatTime(_bundle!.sunrise), palette),
                      _prayerRow('الظهر', _formatTime(_bundle!.dhuhr), palette),
                      _prayerRow('العصر', _formatTime(_bundle!.asr), palette),
                      _prayerRow('المغرب', _formatTime(_bundle!.maghrib), palette),
                      _prayerRow('العشاء', _formatTime(_bundle!.isha), palette),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _prayerRow(String label, String time, AppThemePalette palette) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: palette.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
