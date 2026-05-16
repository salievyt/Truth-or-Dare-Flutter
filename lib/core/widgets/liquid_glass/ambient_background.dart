import 'dart:math' show pi;

import 'package:flutter/cupertino.dart';

class AmbientBackground extends StatelessWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0A0A14),
                  const Color(0xFF12122A),
                  const Color(0xFF0F1629),
                ]
              : [
                  const Color(0xFFEEF2F7),
                  const Color(0xFFE8EDF3),
                  const Color(0xFFF3F0F8),
                ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: _Blob(
              size: 380,
              color: isDark
                  ? const Color(0xFF6C5DD3).withValues(alpha: 0.28)
                  : const Color(0xFF8B7EE6).withValues(alpha: 0.22),
            ),
          ),
          Positioned(
            top: 100,
            right: -100,
            child: _Blob(
              size: 300,
              color: isDark
                  ? const Color(0xFF00D4AA).withValues(alpha: 0.18)
                  : const Color(0xFF00C9A7).withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            bottom: -60,
            left: 20,
            child: _Blob(
              size: 340,
              color: isDark
                  ? const Color(0xFFFF6B6B).withValues(alpha: 0.15)
                  : const Color(0xFFFF8E72).withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: 200,
            right: -60,
            child: _Blob(
              size: 260,
              color: isDark
                  ? const Color(0xFFFFB347).withValues(alpha: 0.12)
                  : const Color(0xFFFFD93D).withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            top: 400,
            left: -40,
            child: _Blob(
              size: 200,
              color: isDark
                  ? const Color(0xFF5B8DEF).withValues(alpha: 0.12)
                  : const Color(0xFF7BA4F0).withValues(alpha: 0.10),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;

  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 6,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
