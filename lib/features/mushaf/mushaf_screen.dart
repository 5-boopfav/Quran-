import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/theme/theme_models.dart';
import '../../core/widgets/glass_components.dart';
import '../../data/quran/quran_data_service.dart';

class MushafScreen extends StatefulWidget {
  final ThemeController themeController;

  const MushafScreen({super.key, required this.themeController});

  @override
  State<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends State<MushafScreen> {
  final QuranDataService _quranService = QuranDataService();
  late final PageController _pageController;
  final Map<int, QuranPageModel> _loadedPages = {};
  final Set<int> _loadingPages = {};
  final Map<int, String> _errorPages = {};

  @override
  void initState() {
    super.initState();
    final startPage = widget.themeController.khatmahPage.clamp(1, 604);
    _pageController = PageController(initialPage: startPage - 1);
    _fetchPageIfNeeded(startPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchPageIfNeeded(int pageNumber) async {
    if (_loadedPages.containsKey(pageNumber) || _loadingPages.contains(pageNumber)) {
      return;
    }
    setState(() {
      _loadingPages.add(pageNumber);
      _errorPages.remove(pageNumber);
    });

    try {
      final pageModel = await _quranService.fetchPage(pageNumber);
      if (!mounted) return;
      setState(() {
        _loadedPages[pageNumber] = pageModel;
        _loadingPages.remove(pageNumber);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingPages.remove(pageNumber);
        _errorPages[pageNumber] = 'تعذر تحميل الصفحة $pageNumber. تأكد من الاتصال بالشبكة.';
      });
    }
  }

  void _openMushafThemeDialog(AppThemePalette appPalette) {
    showModalBottomSheet(
      context: context,
      backgroundColor: appPalette.isDark ? const Color(0xFF152634) : Colors.white,
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
                'ثيم صفحة المصحف',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: appPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...MushafPageThemeStyle.values.map((style) {
                final mPalette = MushafPagePalette.fromStyle(style);
                final selected = widget.themeController.mushafThemeStyle == style;
                return ListTile(
                  leading: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: mPalette.pageBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: mPalette.borderGold, width: 1.5),
                    ),
                  ),
                  title: Text(
                    mPalette.name,
                    style: TextStyle(color: appPalette.textPrimary),
                  ),
                  trailing: selected
                      ? Icon(Icons.check_circle, color: appPalette.primaryColor)
                      : null,
                  onTap: () {
                    widget.themeController.setMushafTheme(style);
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
    final appPalette = widget.themeController.appPalette;
    final mPalette = widget.themeController.mushafPalette;

    return AppGradientBackground(
      palette: appPalette,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'مصحف المدينة والختمة',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: appPalette.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _openMushafThemeDialog(appPalette),
                      icon: Icon(Icons.auto_awesome_mosaic, color: appPalette.primaryColor),
                      tooltip: 'ثيم صفحة المصحف',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: PageView.builder(
                controller: _pageController,
                itemCount: 604,
                onPageChanged: (index) {
                  final pageNumber = index + 1;
                  widget.themeController.setKhatmahPage(pageNumber);
                  _fetchPageIfNeeded(pageNumber);
                },
                itemBuilder: (context, index) {
                  final pageNumber = index + 1;
                  _fetchPageIfNeeded(pageNumber);
                  final pageData = _loadedPages[pageNumber];
                  final errorText = _errorPages[pageNumber];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: mPalette.pageBackground,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: mPalette.borderGold, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pageData?.surahHeader ?? 'القرآن الكريم',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: mPalette.headerFooterColor,
                              ),
                            ),
                            Text(
                              'الجزء ${pageData?.juzNumber ?? 1}',
                              style: TextStyle(
                                fontSize: 13,
                                color: mPalette.headerFooterColor,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: mPalette.borderGold.withOpacity(0.5)),
                        Expanded(
                          child: pageData != null
                              ? SingleChildScrollView(
                                  child: Text(
                                    pageData.quranText,
                                    textAlign: TextAlign.justify,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 22,
                                      height: 1.95,
                                      color: mPalette.quranTextColor,
                                    ),
                                  ),
                                )
                              : errorText != null
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            errorText,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: mPalette.quranTextColor),
                                          ),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () => _fetchPageIfNeeded(pageNumber),
                                            child: const Text('إعادة المحاولة'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$pageNumber',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: mPalette.headerFooterColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
