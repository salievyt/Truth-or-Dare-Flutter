import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../models/player.dart';

class PlayerCarousel extends StatefulWidget {
  final List<Player> players;
  final int activeIndex;

  const PlayerCarousel({
    super.key,
    required this.players,
    required this.activeIndex,
  });

  @override
  State<PlayerCarousel> createState() => _PlayerCarouselState();
}

class _PlayerCarouselState extends State<PlayerCarousel> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.38,
      initialPage: widget.activeIndex,
    );
  }

  @override
  void didUpdateWidget(covariant PlayerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeIndex != widget.activeIndex &&
        _pageController.hasClients) {
      _pageController.animateToPage(
        widget.activeIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 76,
      child: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.players.length,
        itemBuilder: (context, index) {
          final player = widget.players[index];
          final isActive = index == widget.activeIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: isActive ? 32 : 20,
                  sigmaY: isActive ? 32 : 20,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        isActive
                            ? CupertinoColors.systemIndigo
                                .withValues(alpha: 0.55)
                            : (isDark
                                ? CupertinoColors.systemGrey6
                                    .withValues(alpha: 0.22)
                                : CupertinoColors.white
                                    .withValues(alpha: 0.3)),
                        isActive
                            ? CupertinoColors.systemIndigo
                                .withValues(alpha: 0.4)
                            : (isDark
                                ? CupertinoColors.systemGrey6
                                    .withValues(alpha: 0.15)
                                : CupertinoColors.white
                                    .withValues(alpha: 0.2)),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive
                          ? CupertinoColors.white.withValues(alpha: 0.45)
                          : CupertinoColors.white.withValues(alpha: 0.22),
                      width: 0.7,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: CupertinoColors.systemIndigo
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: -2,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      style: theme.textTheme.textStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? CupertinoColors.white
                            : (isDark
                                ? CupertinoColors.systemGrey
                                : CupertinoColors.systemGrey2),
                        fontSize: isActive ? 17 : 15,
                      ),
                      child: Text(player.name),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
