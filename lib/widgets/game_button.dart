import 'package:flutter/cupertino.dart';

import 'liquid_glass/liquid_glass_container.dart';

class GameButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final bool isOutlined;
  final double? width;

  const GameButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.isOutlined = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBg = isDark
        ? CupertinoColors.systemGrey6
        : CupertinoColors.white;
    final defaultFg = isDark
        ? CupertinoColors.white
        : CupertinoColors.black;

    return GestureDetector(
      onTap: onPressed,
      child: LiquidGlassContainer(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        borderRadius: BorderRadius.circular(16),
        tint: isOutlined
            ? (backgroundColor ?? defaultBg).withValues(alpha: 0.1)
            : (backgroundColor ?? defaultBg).withValues(alpha: 0.35),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: foregroundColor ?? defaultFg,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? defaultFg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
