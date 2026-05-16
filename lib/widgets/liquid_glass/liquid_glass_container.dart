import 'dart:ui';

import 'package:flutter/cupertino.dart';

class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final Color? tint;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final double? width;
  final double? height;
  final bool showGloss;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 24,
    this.tint,
    this.borderWidth = 0.6,
    this.shadows,
    this.width,
    this.height,
    this.showGloss = true,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;

    final defaultTint = isDark
        ? CupertinoColors.systemBackground.withValues(alpha: 0.12)
        : CupertinoColors.white.withValues(alpha: 0.28);

    final borderColor = isDark
        ? CupertinoColors.white.withValues(alpha: 0.18)
        : CupertinoColors.white.withValues(alpha: 0.5);

    final effectiveRadius = borderRadius ?? BorderRadius.circular(28);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: shadows ?? [
          BoxShadow(
            color: isDark
                ? CupertinoColors.black.withValues(alpha: 0.35)
                : CupertinoColors.black.withValues(alpha: 0.06),
            blurRadius: 32,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (tint ?? defaultTint).withValues(
                    alpha: (tint ?? defaultTint).a + 0.04,
                  ),
                  tint ?? defaultTint,
                ],
              ),
              borderRadius: effectiveRadius,
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            child: Stack(
              children: [
                if (showGloss)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: effectiveRadius.topLeft.y * 0.6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            CupertinoColors.white.withValues(alpha: 0.25),
                            CupertinoColors.white.withValues(alpha: 0),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: effectiveRadius.topLeft,
                          topRight: effectiveRadius.topRight,
                        ),
                      ),
                    ),
                  ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
