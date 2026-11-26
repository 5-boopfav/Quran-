import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/theme_controller.dart';
import 'features/home/home_screen.dart';
import 'features/mushaf/mushaf_screen.dart';
import 'features/adhkar/adhkar_screen.dart';
import 'features/prayer/prayer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = ThemeController();
  await themeController.loadSavedPreferences();
  runApp(IslamicCompanionApp(themeController: themeController));
}

class IslamicCompanionApp extends StatelessWidget {
  final ThemeController themeController;

  const IslamicCompanionApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        final palette = themeController.appPalette;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'زاد المسلم',
          locale: const Locale('ar', 'SA'),
          supportedLocales: const [Locale('ar', 'SA')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            brightness: palette.isDark ? Brightness.dark : Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: palette.primaryColor,
              brightness: palette.isDark ? Brightness.dark : Brightness.light,
              primary: palette.primaryColor,
              secondary: palette.accentGold,
            ),
          ),
          home: MainShell(themeController: themeController),
        );
      },
    );
  }
}

class MainShell extends StatefulWidget {
  final ThemeController themeController;

  const MainShell({super.key, required this.themeController});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  String? _adhkarCategory;

  void _navigateToTab(int index, {String? adhkarCategory}) {
    setState(() {
      _currentIndex = index;
      if (adhkarCategory != null) {
        _adhkarCategory = adhkarCategory;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.themeController.appPalette;

    final screens = [
      HomeScreen(
        themeController: widget.themeController,
        onNavigateTab: _navigateToTab,
      ),
      MushafScreen(themeController: widget.themeController),
      AdhkarScreen(
        themeController: widget.themeController,
        initialCategory: _adhkarCategory,
      ),
      PrayerScreen(themeController: widget.themeController),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: palette.isDark ? const Color(0xFF101D27) : Colors.white,
        indicatorColor: palette.primaryColor.withOpacity(0.16),
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'المصحف',
          ),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism_outlined),
            selectedIcon: Icon(Icons.volunteer_activism),
            label: 'الأذكار',
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time_outlined),
            selectedIcon: Icon(Icons.access_time_filled),
            label: 'الأذان',
          ),
        ],
      ),
    );
  }
}
