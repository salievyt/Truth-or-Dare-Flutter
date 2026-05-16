import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../models/player.dart';
import 'liquid_glass/liquid_glass_container.dart';

class ScoreBoard extends StatelessWidget {
  final List<Player> players;

  const ScoreBoard({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: LiquidGlassContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        borderRadius: BorderRadius.circular(26),
        blur: 26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Счёт',
              style: theme.textTheme.textStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 14),
            ...players.map((player) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        player.name,
                        style: theme.textTheme.textStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _Badge(
                      icon: CupertinoIcons.chat_bubble_2_fill,
                      count: player.truthCount,
                      color: CupertinoColors.systemTeal,
                    ),
                    const SizedBox(width: 8),
                    _Badge(
                      icon: CupertinoIcons.bolt_fill,
                      count: player.dareCount,
                      color: CupertinoColors.systemOrange,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;

  const _Badge({required this.icon, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withValues(alpha: 0.25),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
