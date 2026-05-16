import 'package:flutter/cupertino.dart';

import '../../../../core/widgets/liquid_glass/liquid_glass_button.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass_container.dart';
import '../../domain/entities/game_phase.dart';

class GameCard extends StatelessWidget {
  final GamePhase phase;
  final String text;
  final VoidCallback onComplete;

  const GameCard({
    super.key,
    required this.phase,
    required this.text,
    required this.onComplete,
  });

  Color _getColor() {
    if (phase == GamePhase.showingTruth) return CupertinoColors.systemTeal;
    if (phase == GamePhase.showingDare) return CupertinoColors.systemOrange;
    return CupertinoColors.systemIndigo;
  }

  String get _label {
    if (phase == GamePhase.showingTruth) return 'ПРАВДА';
    if (phase == GamePhase.showingDare) return 'ДЕЙСТВИЕ';
    return '';
  }

  IconData get _icon {
    if (phase == GamePhase.showingTruth) return CupertinoIcons.chat_bubble_2_fill;
    return CupertinoIcons.bolt_fill;
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final color = _getColor();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LiquidGlassContainer(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            borderRadius: BorderRadius.circular(32),
            blur: 28,
            tint: color.withValues(alpha: 0.14),
            child: Column(
              children: [
                LiquidGlassContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 7,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  blur: 14,
                  tint: color.withValues(alpha: 0.25),
                  showGloss: false,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_icon, size: 15, color: color),
                      const SizedBox(width: 7),
                      Text(
                        _label,
                        style: theme.textTheme.textStyle.copyWith(
                          color: color,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.navTitleTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          LiquidGlassButton(
            text: 'Выполнил!',
            icon: CupertinoIcons.check_mark_circled,
            width: double.infinity,
            onPressed: onComplete,
          ),
        ],
      ),
    );
  }
}
