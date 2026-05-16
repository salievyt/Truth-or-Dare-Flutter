import 'dart:ui';

import 'package:flutter/cupertino.dart';

class LiquidGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? tint;
  final Color? textColor;
  final double? width;

  const LiquidGlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.tint,
    this.textColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;

    final defaultTint = isDark
        ? CupertinoColors.systemBlue.withValues(alpha: 0.35)
        : CupertinoColors.systemBlue.withValues(alpha: 0.75);

    final defaultTextColor = isDark
        ? CupertinoColors.white
        : CupertinoColors.white;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: (tint ?? defaultTint).withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: CupertinoColors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (tint ?? defaultTint).withValues(
                      alpha: (tint ?? defaultTint).a + 0.06,
                    ),
                    tint ?? defaultTint,
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: CupertinoColors.white.withValues(alpha: 0.35),
                  width: 0.7,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 22,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            CupertinoColors.white.withValues(alpha: 0.2),
                            CupertinoColors.white.withValues(alpha: 0),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            size: 18,
                            color: textColor ?? defaultTextColor,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor ?? defaultTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
