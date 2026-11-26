import 'package:flutter/material.dart';

enum AppThemeStyle {
  skyLight,   // السماوي المشرق (الأساسي للشكل 2)
  warmPaper,  // الورقي الدافئ
  glassNight, // الليلي الزجاجي
}

enum MushafPageThemeStyle {
  classicCream, // ورق المصحف الكلاسيكي
  brightWhite,  // ورق ناصع مشرق
  nightMode,    // الوضع الليلي للمصحف
}

class AppThemePalette {
  final String name;
  final bool isDark;
  final Color backgroundStart;
  final Color backgroundEnd;
  final Color primaryColor;
  final Color accentGold;
  final Color glassFill;
  final Color glassBorder;
  final Color textPrimary;
  final Color textSecondary;

  const AppThemePalette({
    required this.name,
    required this.isDark,
    required this.backgroundStart,
    required this.backgroundEnd,
    required this.primaryColor,
    required this.accentGold,
    required this.glassFill,
    required this.glassBorder,
    required this.textPrimary,
    required this.textSecondary,
  });

  static const AppThemePalette skyLight = AppThemePalette(
    name: 'السماوي المشرق',
    isDark: false,
    backgroundStart: Color(0xFFEAF3F6),
    backgroundEnd: Color(0xFFF8FBFD),
    primaryColor: Color(0xFF2B6E7D),
    accentGold: Color(0xFFC8A45D),
    glassFill: Color(0xB8FFFFFF),
    glassBorder: Color(0xE6FFFFFF),
    textPrimary: Color(0xFF1A2B34),
    textSecondary: Color(0xFF5A6E78),
  );

  static const AppThemePalette warmPaper = AppThemePalette(
    name: 'الورقي الدافئ',
    isDark: false,
    backgroundStart: Color(0xFFF5EFE2),
    backgroundEnd: Color(0xFFFCF9F2),
    primaryColor: Color(0xFF4A6B5D),
    accentGold: Color(0xFFB88B3A),
    glassFill: Color(0xC2FFFDF8),
    glassBorder: Color(0xE6FFF8E7),
    textPrimary: Color(0xFF26231E),
    textSecondary: Color(0xFF696154),
  );

  static const AppThemePalette glassNight = AppThemePalette(
    name: 'الليلي الزجاجي',
    isDark: true,
    backgroundStart: Color(0xFF0D1821),
    backgroundEnd: Color(0xFF152634),
    primaryColor: Color(0xFF56A3B6),
    accentGold: Color(0xFFD6B268),
    glassFill: Color(0x26FFFFFF),
    glassBorder: Color(0x38FFFFFF),
    textPrimary: Color(0xFFF2F6F8),
    textSecondary: Color(0xFFA4B7C2),
  );

  static AppThemePalette fromStyle(AppThemeStyle style) {
    switch (style) {
      case AppThemeStyle.skyLight:
        return skyLight;
      case AppThemeStyle.warmPaper:
        return warmPaper;
      case AppThemeStyle.glassNight:
        return glassNight;
    }
  }
}

class MushafPagePalette {
  final String name;
  final bool isDark;
  final Color pageBackground;
  final Color borderGold;
  final Color headerFooterColor;
  final Color quranTextColor;

  const MushafPagePalette({
    required this.name,
    required this.isDark,
    required this.pageBackground,
    required this.borderGold,
    required this.headerFooterColor,
    required this.quranTextColor,
  });

  static const MushafPagePalette classicCream = MushafPagePalette(
    name: 'ورق المصحف الكلاسيكي',
    isDark: false,
    pageBackground: Color(0xFFFAF2DC),
    borderGold: Color(0xFFC49A45),
    headerFooterColor: Color(0xFF6F5B35),
    quranTextColor: Color(0xFF1E1A14),
  );

  static const MushafPagePalette brightWhite = MushafPagePalette(
    name: 'ورق ناصع مشرق',
    isDark: false,
    pageBackground: Color(0xFFFFFFFF),
    borderGold: Color(0xFFB89652),
    headerFooterColor: Color(0xFF52636B),
    quranTextColor: Color(0xFF141C20),
  );

  static const MushafPagePalette nightMode = MushafPagePalette(
    name: 'الوضع الليلي للمصحف',
    isDark: true,
    pageBackground: Color(0xFF141C22),
    borderGold: Color(0xFF9C7E3E),
    headerFooterColor: Color(0xFF9BB0BC),
    quranTextColor: Color(0xFFEDE6D6),
  );

  static MushafPagePalette fromStyle(MushafPageThemeStyle style) {
    switch (style) {
      case MushafPageThemeStyle.classicCream:
        return classicCream;
      case MushafPageThemeStyle.brightWhite:
        return brightWhite;
      case MushafPageThemeStyle.nightMode:
        return nightMode;
    }
  }
}
