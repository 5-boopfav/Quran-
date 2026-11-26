import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_models.dart';

class ThemeController extends ChangeNotifier {
  static const String _appThemeKey = 'selected_app_theme_v1';
  static const String _mushafThemeKey = 'selected_mushaf_theme_v1';
  static const String _pageTurnSoundKey = 'mushaf_page_turn_sound_v1';
  static const String _khatmahPageKey = 'khatmah_current_page_v1';
  static const String _tasbeehCountKey = 'tasbeeh_total_count_v1';

  AppThemeStyle _appThemeStyle = AppThemeStyle.skyLight;
  MushafPageThemeStyle _mushafThemeStyle = MushafPageThemeStyle.classicCream;
  bool _pageTurnSoundEnabled = true;
  int _khatmahPage = 1;
  int _tasbeehCount = 0;

  AppThemeStyle get appThemeStyle => _appThemeStyle;
  MushafPageThemeStyle get mushafThemeStyle => _mushafThemeStyle;
  bool get pageTurnSoundEnabled => _pageTurnSoundEnabled;
  int get khatmahPage => _khatmahPage;
  int get tasbeehCount => _tasbeehCount;

  AppThemePalette get appPalette => AppThemePalette.fromStyle(_appThemeStyle);
  MushafPagePalette get mushafPalette =>
      MushafPagePalette.fromStyle(_mushafThemeStyle);

  Future<void> loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final appIndex = prefs.getInt(_appThemeKey);
    if (appIndex != null && appIndex >= 0 && appIndex < AppThemeStyle.values.length) {
      _appThemeStyle = AppThemeStyle.values[appIndex];
    }

    final mushafIndex = prefs.getInt(_mushafThemeKey);
    if (mushafIndex != null &&
        mushafIndex >= 0 &&
        mushafIndex < MushafPageThemeStyle.values.length) {
      _mushafThemeStyle = MushafPageThemeStyle.values[mushafIndex];
    }

    _pageTurnSoundEnabled = prefs.getBool(_pageTurnSoundKey) ?? true;
    _khatmahPage = (prefs.getInt(_khatmahPageKey) ?? 1).clamp(1, 604);
    _tasbeehCount = prefs.getInt(_tasbeehCountKey) ?? 0;
    notifyListeners();
  }

  Future<void> setAppTheme(AppThemeStyle style) async {
    _appThemeStyle = style;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_appThemeKey, style.index);
  }

  Future<void> setMushafTheme(MushafPageThemeStyle style) async {
    _mushafThemeStyle = style;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_mushafThemeKey, style.index);
  }

  Future<void> setPageTurnSound(bool enabled) async {
    _pageTurnSoundEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pageTurnSoundKey, enabled);
  }

  Future<void> setKhatmahPage(int page) async {
    final clamped = page.clamp(1, 604);
    if (_khatmahPage == clamped) return;
    _khatmahPage = clamped;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_khatmahPageKey, clamped);
  }

  Future<void> incrementTasbeeh() async {
    _tasbeehCount++;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasbeehCountKey, _tasbeehCount);
  }

  Future<void> resetTasbeeh() async {
    _tasbeehCount = 0;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasbeehCountKey, 0);
  }
}
