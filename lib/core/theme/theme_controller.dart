import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_models.dart';

class ThemeController extends ChangeNotifier {
  static const String _appThemeKey = 'app_theme_style_v1';
  static const String _mushafThemeKey = 'mushaf_page_theme_v1';
  static const String _khatmahPageKey = 'khatmah_page_v1';
  static const String _tasbeehCountKey = 'tasbeeh_count_v1';

  AppThemeStyle _appThemeStyle = AppThemeStyle.skyLight;
  MushafPageThemeStyle _mushafThemeStyle = MushafPageThemeStyle.classicCream;
  int _khatmahPage = 1;
  int _tasbeehCount = 0;

  AppThemeStyle get appThemeStyle => _appThemeStyle;
  MushafPageThemeStyle get mushafThemeStyle => _mushafThemeStyle;
  int get khatmahPage => _khatmahPage;
  int get tasbeehCount => _tasbeehCount;

  AppThemePalette get appPalette => AppThemePalette.fromStyle(_appThemeStyle);
  MushafPagePalette get mushafPalette =>
      MushafPagePalette.fromStyle(_mushafThemeStyle);

  Future<void> loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final savedAppTheme = prefs.getString(_appThemeKey);
    if (savedAppTheme != null) {
      for (final item in AppThemeStyle.values) {
        if (item.name == savedAppTheme) {
          _appThemeStyle = item;
          break;
        }
      }
    }

    final savedMushafTheme = prefs.getString(_mushafThemeKey);
    if (savedMushafTheme != null) {
      for (final item in MushafPageThemeStyle.values) {
        if (item.name == savedMushafTheme) {
          _mushafThemeStyle = item;
          break;
        }
      }
    }

    final savedPage = prefs.getInt(_khatmahPageKey);
    if (savedPage != null) {
      _khatmahPage = savedPage.clamp(1, 604);
    }

    _tasbeehCount = prefs.getInt(_tasbeehCountKey) ?? 0;
    notifyListeners();
  }

  Future<void> setAppTheme(AppThemeStyle style) async {
    _appThemeStyle = style;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appThemeKey, style.name);
  }

  Future<void> setMushafTheme(MushafPageThemeStyle style) async {
    _mushafThemeStyle = style;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mushafThemeKey, style.name);
  }

  Future<void> setKhatmahPage(int page) async {
    final clamped = page.clamp(1, 604);
    if (_khatmahPage == clamped) return;
    _khatmahPage = clamped;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_khatmahPageKey, _khatmahPage);
  }

  Future<void> incrementTasbeeh() async {
    _tasbeehCount += 1;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasbeehCountKey, _tasbeehCount);
  }

  Future<void> resetTasbeeh() async {
    _tasbeehCount = 0;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasbeehCountKey, _tasbeehCount);
  }
}
