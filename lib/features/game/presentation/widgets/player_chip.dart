import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../domain/entities/player.dart';

class PlayerChip extends StatelessWidget {
  final Player player;
  final VoidCallback? onRemove;
  final bool isActive;

  const PlayerChip({
    super.key,
    required this.player,
    this.onRemove,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isActive
                    ? CupertinoColors.systemIndigo.withValues(alpha: 0.4)
                    : (isDark
                        ? CupertinoColors.systemGrey6.withValues(alpha: 0.25)
                        : CupertinoColors.white.withValues(alpha: 0.35)),
                isActive
                    ? CupertinoColors.systemIndigo.withValues(alpha: 0.3)
                    : (isDark
                        ? CupertinoColors.systemGrey6.withValues(alpha: 0.15)
                        : CupertinoColors.white.withValues(alpha: 0.22)),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isActive
                  ? CupertinoColors.white.withValues(alpha: 0.45)
                  : CupertinoColors.white.withValues(alpha: 0.28),
              width: 0.7,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                player.name,
                style: theme.textTheme.textStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? CupertinoColors.white
                      : (isDark ? CupertinoColors.white : CupertinoColors.black),
                ),
              ),
              if (onRemove != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    CupertinoIcons.xmark,
                    size: 16,
                    color: isDark
                        ? CupertinoColors.systemGrey
                        : CupertinoColors.systemGrey2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
