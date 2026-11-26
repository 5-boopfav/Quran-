import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/widgets/glass_components.dart';
import '../../data/adhkar/adhkar_repository.dart';

class AdhkarScreen extends StatefulWidget {
  final ThemeController themeController;
  final String? initialCategory;

  const AdhkarScreen({
    super.key,
    required this.themeController,
    this.initialCategory,
  });

  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  late String _selectedCategory;
  final Map<String, int> _remainingCounts = {};

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? AdhkarRepository.categories.first;
    for (final item in AdhkarRepository.items) {
      _remainingCounts[item.id] = item.repeatCount;
    }
  }

  @override
  void didUpdateWidget(covariant AdhkarScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != null &&
        widget.initialCategory != oldWidget.initialCategory) {
      setState(() => _selectedCategory = widget.initialCategory!);
    }
  }

  void _decrementItem(DhikrItem item) {
    final current = _remainingCounts[item.id] ?? item.repeatCount;
    if (current > 0) {
      setState(() => _remainingCounts[item.id] = current - 1);
    }
  }

  void _resetItem(DhikrItem item) {
    setState(() => _remainingCounts[item.id] = item.repeatCount);
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.themeController.appPalette;
    final categoryItems = AdhkarRepository.byCategory(_selectedCategory);

    return AppGradientBackground(
      palette: palette,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'الأذكار وحصن المسلم والسبحة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GlassSurfaceCard(
            palette: palette,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'السبحة الإلكترونية',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'العداد الحالي: ${widget.themeController.tasbeehCount}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: palette.primaryColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => widget.themeController.resetTasbeeh(),
                      icon: Icon(Icons.refresh, color: palette.textSecondary),
                      tooltip: 'تصفير السبحة',
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette.primaryColor,
                        foregroundColor: Colors.white,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(18),
                      ),
                      onPressed: () => widget.themeController.incrementTasbeeh(),
                      child: const Icon(Icons.add, size: 24),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AdhkarRepository.categories.map((cat) {
                final selected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    selectedColor: palette.primaryColor,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : palette.textPrimary,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          ...categoryItems.map((item) {
            final remaining = _remainingCounts[item.id] ?? item.repeatCount;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassSurfaceCard(
                palette: palette,
                onTap: () => _decrementItem(item),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.text,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.8,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.referenceNote ?? item.category,
                          style: TextStyle(fontSize: 12, color: palette.textSecondary),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _resetItem(item),
                              icon: Icon(Icons.replay, size: 18, color: palette.textSecondary),
                              tooltip: 'إعادة عداد الذكر',
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: remaining == 0
                                    ? Colors.green.withValues(alpha: 0.18)
                                    : palette.primaryColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                remaining == 0 ? 'مكتمل ✓' : 'المتبقي: $remaining',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: remaining == 0 ? Colors.green : palette.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
