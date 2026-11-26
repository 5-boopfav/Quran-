class DhikrItem {
  final String id;
  final String category;
  final String text;
  final int repeatCount;
  final String? referenceNote;

  const DhikrItem({
    required this.id,
    required this.category,
    required this.text,
    required this.repeatCount,
    this.referenceNote,
  });
}

class AdhkarRepository {
  static const List<String> categories = [
    'أذكار الصباح',
    'أذكار المساء',
    'أذكار بعد الصلاة',
    'حصن المسلم',
  ];

  static const List<DhikrItem> items = [
    DhikrItem(
      id: 'm_1',
      category: 'أذكار الصباح',
      text: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
      repeatCount: 1,
      referenceNote: 'أذكار الصباح',
    ),
    DhikrItem(
      id: 'm_2',
      category: 'أذكار الصباح',
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ.',
      repeatCount: 100,
      referenceNote: 'أذكار الصباح',
    ),
    DhikrItem(
      id: 'e_1',
      category: 'أذكار المساء',
      text: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
      repeatCount: 1,
      referenceNote: 'أذكار المساء',
    ),
    DhikrItem(
      id: 'e_2',
      category: 'أذكار المساء',
      text: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.',
      repeatCount: 3,
      referenceNote: 'أذكار المساء',
    ),
    DhikrItem(
      id: 'p_1',
      category: 'أذكار بعد الصلاة',
      text: 'أَسْتَغْفِرُ اللَّهَ (ثلاثاً). اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ.',
      repeatCount: 1,
      referenceNote: 'دبر الصلوات المكتوبة',
    ),
    DhikrItem(
      id: 'p_2',
      category: 'أذكار بعد الصلاة',
      text: 'سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَاللَّهُ أَكْبَرُ.',
      repeatCount: 33,
      referenceNote: 'دبر كل صلاة',
    ),
    DhikrItem(
      id: 'h_1',
      category: 'حصن المسلم',
      text: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، يُحْيِي وَيُمِيتُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
      repeatCount: 10,
      referenceNote: 'حصن المسلم - فضل الذكر',
    ),
    DhikrItem(
      id: 'h_2',
      category: 'حصن المسلم',
      text: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا.',
      repeatCount: 1,
      referenceNote: 'حصن المسلم - أدعية مأثورة',
    ),
  ];

  static List<DhikrItem> byCategory(String category) {
    return items.where((item) => item.category == category).toList();
  }
}
