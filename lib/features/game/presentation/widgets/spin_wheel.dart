import 'dart:math' show pi;

import 'package:flutter/cupertino.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass_container.dart';
import '../../domain/entities/player.dart';

class SpinWheel extends StatefulWidget {
  final List<Player> players;
  final int activeIndex;
  final bool isSpinning;
  final ValueChanged<double>? onSwipe;

  const SpinWheel({
    super.key,
    required this.players,
    required this.activeIndex,
    this.isSpinning = false,
    this.onSwipe,
  });

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  double _dragStartOffset = 0;
  double _dragCurrentOffset = 0;
  bool _isDragging = false;

  double get _cardWidth => 140;
  double get _cardHeight => 200;
  double get _cardGap => 32;
  double get _itemExtent => _cardWidth + _cardGap;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant SpinWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeIndex != widget.activeIndex &&
        !_isDragging &&
        widget.isSpinning) {
      _animateToIndex(widget.activeIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _animateToIndex(int index) {
    if (!_scrollController.hasClients) return;
    final target = index * _itemExtent;
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 80),
      curve: Curves.linear,
    );
  }

  void _startSpin(double velocity) {
    widget.onSwipe?.call(velocity);
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final r = Responsive(context);

    if (widget.players.isEmpty) return const SizedBox.shrink();

    final displayPlayers = [
      ...widget.players,
      ...widget.players,
      ...widget.players,
      ...widget.players,
      ...widget.players,
    ];

    final centerOffset = r.width / 2 - _cardWidth / 2;

    return SizedBox(
      height: r.scale(360, 400, 440),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: widget.isSpinning
            ? null
            : (details) {
                _isDragging = true;
                _dragStartOffset = _scrollController.offset;
                _dragCurrentOffset = _dragStartOffset;
              },
        onHorizontalDragUpdate: widget.isSpinning
            ? null
            : (details) {
                _dragCurrentOffset -= details.delta.dx * 1.2;
                _scrollController.jumpTo(_dragCurrentOffset.clamp(
                  0,
                  _scrollController.position.maxScrollExtent,
                ));
              },
        onHorizontalDragEnd: widget.isSpinning
            ? null
            : (details) {
                _isDragging = false;
                final velocity = details.velocity.pixelsPerSecond.dx;
                if (velocity.abs() > 200) {
                  _startSpin(velocity);
                } else {
                  final nearestIndex =
                      (_scrollController.offset / _itemExtent).round();
                  _scrollController.animateTo(
                    nearestIndex * _itemExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  );
                }
              },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: centerOffset,
                right: centerOffset,
              ),
              itemCount: displayPlayers.length,
              itemBuilder: (context, index) {
                final player = displayPlayers[index];
                final actualIndex = index % widget.players.length;
                final isActive = actualIndex == widget.activeIndex;

                return _Card(
                  player: player,
                  isActive: isActive,
                  cardWidth: _cardWidth,
                  cardHeight: _cardHeight,
                );
              },
            ),
            if (!widget.isSpinning)
              Positioned(
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: widget.isSpinning ? 0 : 0.6,
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.chevron_left,
                        size: 14,
                        color: isDark
                            ? CupertinoColors.systemGrey
                            : CupertinoColors.systemGrey2,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Свайпай или жми крутить',
                        style: theme.textTheme.textStyle.copyWith(
                          fontSize: 13,
                          color: isDark
                              ? CupertinoColors.systemGrey
                              : CupertinoColors.systemGrey2,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        CupertinoIcons.chevron_right,
                        size: 14,
                        color: isDark
                            ? CupertinoColors.systemGrey
                            : CupertinoColors.systemGrey2,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Player player;
  final bool isActive;
  final double cardWidth;
  final double cardHeight;

  const _Card({
    required this.player,
    required this.isActive,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      width: cardWidth + 32,
      height: cardHeight + 32,
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: pi / 4,
        alignment: Alignment.center,
        child: AnimatedScale(
          scale: isActive ? 1.08 : 0.92,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: cardWidth,
            height: cardHeight,
            child: LiquidGlassContainer(
              padding: const EdgeInsets.all(20),
              borderRadius: BorderRadius.circular(24),
              blur: isActive ? 32 : 20,
              tint: isActive
                  ? CupertinoColors.systemIndigo.withValues(alpha: 0.45)
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.person_fill,
                    size: 40,
                    color: isActive
                        ? CupertinoColors.white
                        : CupertinoColors.systemGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    player.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.textStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? CupertinoColors.white
                          : CupertinoColors.systemGrey2,
                    ),
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: CupertinoColors.systemGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
