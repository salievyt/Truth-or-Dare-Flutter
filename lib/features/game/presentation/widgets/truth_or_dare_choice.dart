import 'package:flutter/cupertino.dart';

import '../../../../core/widgets/liquid_glass/liquid_glass_button.dart';

class TruthOrDareChoice extends StatelessWidget {
  final VoidCallback onTruth;
  final VoidCallback onDare;

  const TruthOrDareChoice({
    super.key,
    required this.onTruth,
    required this.onDare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Выбирай!',
          style: theme.textTheme.navTitleTextStyle.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Правда или действие?',
          style: theme.textTheme.textStyle.copyWith(
            fontSize: 16,
            color: isDark
                ? CupertinoColors.systemGrey
                : CupertinoColors.systemGrey2,
          ),
        ),
        const SizedBox(height: 36),
        Row(
          children: [
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.9, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: LiquidGlassButton(
                  text: 'Правда',
                  icon: CupertinoIcons.chat_bubble_2_fill,
                  tint: CupertinoColors.systemTeal.withValues(alpha: 0.65),
                  onPressed: onTruth,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.9, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: LiquidGlassButton(
                  text: 'Действие',
                  icon: CupertinoIcons.bolt_fill,
                  tint: CupertinoColors.systemOrange.withValues(alpha: 0.65),
                  onPressed: onDare,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
