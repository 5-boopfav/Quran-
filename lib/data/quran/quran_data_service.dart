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

  Map<String, dynamic> toJson() => {
        'pageNumber': pageNumber,
        'surahHeader': surahHeader,
        'juzNumber': juzNumber,
        'quranText': quranText,
      };

  factory QuranPageModel.fromJson(Map<String, dynamic> json) => QuranPageModel(
        pageNumber: json['pageNumber'] as int,
        surahHeader: json['surahHeader'] as String,
        juzNumber: json['juzNumber'] as int,
        quranText: json['quranText'] as String,
      );
}

class QuranDataService {
  static const String _cachePrefix = 'quran_page_v1_';

  /// يجلب صفحة المصحف من مصدر موثوق (AlQuran Cloud - نص إملائي/عثماني رسمي)
  /// ويحفظها محلياً لتسريع القراءة اللاحقة دون أي تعديل يدوي للنص القرآني.
  Future<QuranPageModel> fetchPage(int pageNumber) async {
    final safePage = pageNumber.clamp(1, 604);
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cachePrefix$safePage';

    final cachedRaw = prefs.getString(cacheKey);
    if (cachedRaw != null) {
      return QuranPageModel.fromJson(
        jsonDecode(cachedRaw) as Map<String, dynamic>,
      );
    }

    final uri = Uri.parse('https://api.alquran.cloud/v1/page/$safePage/quran-uthmani');
    final response = await http.get(uri).timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw Exception('تعذر جلب صفحة المصحف رقم $safePage');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>;
    final ayahs = (data['ayahs'] as List<dynamic>).cast>();

    if (ayahs.isEmpty) {
      throw Exception('لا توجد آيات في الصفحة رقم $safePage');
    }

    final firstAyah = ayahs.first;
    final surahInfo = firstAyah['surah'] as Map<String, dynamic>;
    final surahName = (surahInfo['name'] as String?) ?? 'القرآن الكريم';
    final juzNumber = (firstAyah['juz'] as int?) ?? 1;

    final buffer = StringBuffer();
    for (final ayah in ayahs) {
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
