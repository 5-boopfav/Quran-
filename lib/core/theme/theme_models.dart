import 'package:flutter/material.dart';

enum AppThemeStyle {
  skyLight,
  warmPaper,
  glassNight,
}

enum MushafPageThemeStyle {
  classicCream,
  brightPaper,
  nightReading,
}

class AppThemePalette {
  final String name;
  final bool isDark;
  final Color backgroundStart;
  final Color backgroundEnd;
  final Color glassFill;
  final Color glassBorder;
  final Color primaryColor;
  final Color accentGold;
  final Color textPrimary;
  final Color textSecondary;

  const AppThemePalette({
    required this.name,
    required this.isDark,
    required this.backgroundStart,
    required this.backgroundEnd,
    required this.glassFill,
    required this.glassBorder,
    required this.primaryColor,
    required this.accentGold,
    required this.textPrimary,
    required this.textSecondary,
  });

  factory AppThemePalette.fromStyle(AppThemeStyle style) {
    switch (style) {
      case AppThemeStyle.skyLight:
        return const AppThemePalette(
          name: 'السماء المشرقة (Sky Light)',
          isDark: false,
          backgroundStart: Color(0xFFEAF4FB),
          backgroundEnd: Color(0xFFD7EBF8),
          glassFill: Color(0xCCFFFFFF),
          glassBorder: Color(0x99FFFFFF),
          primaryColor: Color(0xFF0E7490),
          accentGold: Color(0xFFB45309),
          textPrimary: Color(0xFF0F172A),
          textSecondary: Color(0xFF475569),
        );
      case AppThemeStyle.warmPaper:
        return const AppThemePalette(
          name: 'الورق الدافئ (Warm Paper)',
          isDark: false,
          backgroundStart: Color(0xFFFAF4E8),
          backgroundEnd: Color(0xFFF1E4CE),
          glassFill: Color(0xCCFFFDF9),
          glassBorder: Color(0x99FFFFFF),
          primaryColor: Color(0xFF15803D),
          accentGold: Color(0xFFA16207),
          textPrimary: Color(0xFF1C1917),
          textSecondary: Color(0xFF57534E),
        );
      case AppThemeStyle.glassNight:
        return const AppThemePalette(
          name: 'الليل الزجاجي (Glass Night)',
          isDark: true,
          backgroundStart: Color(0xFF0B1722),
          backgroundEnd: Color(0xFF132636),
          glassFill: Color(0x661E3548),
          glassBorder: Color(0x44FFFFFF),
          primaryColor: Color(0xFF22D3EE),
          accentGold: Color(0xFFFBBF24),
          textPrimary: Color(0xFFF8FAFC),
          textSecondary: Color(0xFFCBD5E1),
        );
    }
  }
}

class MushafPagePalette {
  final String name;
  final Color pageBackground;
  final Color quranTextColor;
  final Color headerFooterColor;
  final Color borderGold;

  const MushafPagePalette({
    required this.name,
    required this.pageBackground,
    required this.quranTextColor,
    required this.headerFooterColor,
    required this.borderGold,
  });

  factory MushafPagePalette.fromStyle(MushafPageThemeStyle style) {
    switch (style) {
      case MushafPageThemeStyle.classicCream:
        return const MushafPagePalette(
          name: 'ورق المصحف الكلاسيكي',
          pageBackground: Color(0xFFFAF3E0),
          quranTextColor: Color(0xFF1E1B18),
          headerFooterColor: Color(0xFF785A28),
          borderGold: Color(0xFFC59B27),
        );
      case MushafPageThemeStyle.brightPaper:
        return const MushafPagePalette(
          name: 'ورق ناصع مريح',
          pageBackground: Color(0xFFFFFFFF),
          quranTextColor: Color(0xFF111827),
          headerFooterColor: Color(0xFF0F766E),
          borderGold: Color(0xFFD97706),
        );
      case MushafPageThemeStyle.nightReading:
        return const MushafPagePalette(
          name: 'قراءة ليلية هادئة',
          pageBackground: Color(0xFF121C24),
          quranTextColor: Color(0xFFF3F4F6),
          headerFooterColor: Color(0xFFEAB308),
          borderGold: Color(0xFF92702A),
        );
    }
  }
}
