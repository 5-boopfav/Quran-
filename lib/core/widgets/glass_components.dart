import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/theme_models.dart';

class AppGradientBackground extends StatelessWidget {
  final AppThemePalette palette;
  final Widget child;

  const AppGradientBackground({
    super.key,
    required this.palette,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            palette.backgroundStart,
            palette.backgroundEnd,
          ],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}

class GlassSurfaceCard extends StatelessWidget {
  final AppThemePalette palette;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;

  const GlassSurfaceCard({
    super.key,
    required this.palette,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 22,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: palette.glassFill,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: palette.glassBorder,
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(palette.isDark ? 0.25 : 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
