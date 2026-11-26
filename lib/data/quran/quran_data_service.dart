import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuranPageModel {
  final int pageNumber;
  final String surahHeader;
  final int juzNumber;
  final String quranText;

  const QuranPageModel({
    required this.pageNumber,
    required this.surahHeader,
    required this.juzNumber,
    required this.quranText,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'surahHeader': surahHeader,
      'juzNumber': juzNumber,
      'quranText': quranText,
    };
  }
}

class QuranDataService {
  static const String _cachePrefix = 'quran_page_v1_';

  Future<QuranPageModel> fetchPage(int pageNumber) async {
    final safePage = pageNumber.clamp(1, 604);
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cachePrefix$safePage';

    final cachedRaw = prefs.getString(cacheKey);
    if (cachedRaw != null) {
      final cachedObj = jsonDecode(cachedRaw);
      if (cachedObj is Map) {
        return QuranPageModel(
          pageNumber: (cachedObj['pageNumber'] as int?) ?? safePage,
          surahHeader: (cachedObj['surahHeader'] as String?) ?? 'القرآن الكريم',
          juzNumber: (cachedObj['juzNumber'] as int?) ?? 1,
          quranText: (cachedObj['quranText'] as String?) ?? '',
        );
      }
    }

    final uri =
        Uri.parse('https://api.alquran.cloud/v1/page/$safePage/quran-uthmani');
    final response = await http.get(uri).timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw Exception('تعذر جلب صفحة المصحف رقم $safePage');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw Exception('استجابة غير متوقعة من مصدر القرآن');
    }

    final data = decoded['data'];
    if (data is! Map) {
      throw Exception('بيانات الصفحة غير مكتملة');
    }

    final rawAyahs = data['ayahs'];
    if (rawAyahs is! List || rawAyahs.isEmpty) {
      throw Exception('لا توجد آيات في الصفحة رقم $safePage');
    }

    final validAyahs = [];
    for (final item in rawAyahs) {
      if (item is Map) {
        validAyahs.add(item);
      }
    }

    if (validAyahs.isEmpty) {
      throw Exception('تعذر قراءة آيات الصفحة رقم $safePage');
    }

    final firstAyah = validAyahs.first as Map;
    final surahRaw = firstAyah['surah'];
    final surahName = surahRaw is Map
        ? ((surahRaw['name'] as String?) ?? 'القرآن الكريم')
        : 'القرآن الكريم';
    final juzNumber = (firstAyah['juz'] as int?) ?? 1;

    final buffer = StringBuffer();
    for (final item in validAyahs) {
      final ayah = item as Map;
      final text = (ayah['text'] as String?) ?? '';
      final numberInSurah = ayah['numberInSurah'];
      buffer.write('$text ﴿$numberInSurah﴾ ');
    }

    final model = QuranPageModel(
      pageNumber: safePage,
      surahHeader: surahName,
      juzNumber: juzNumber,
      quranText: buffer.toString().trim(),
    );

    await prefs.setString(cacheKey, jsonEncode(model.toJson()));
    return model;
  }
}
