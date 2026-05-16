import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import '../models/game_phase.dart';
import '../utils/animations.dart';
import '../utils/haptics.dart';
import '../widgets/liquid_glass/ambient_background.dart';
import '../widgets/liquid_glass/liquid_glass_button.dart';
import '../widgets/liquid_glass/liquid_glass_container.dart';
import '../widgets/game_card.dart';
import '../widgets/player_carousel.dart';
import '../widgets/score_board.dart';
import '../widgets/spin_wheel.dart' as wheel;
import '../widgets/truth_or_dare_choice.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return AmbientBackground(
      child: BlocListener<GameBloc, GameState>(
        listenWhen: (prev, curr) =>
            prev.phase != curr.phase && curr.phase == GamePhase.completed,
        listener: (context, state) {
          Haptics.success();
          _confettiController.play();
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    CupertinoSliverNavigationBar(
                      largeTitle: Text(
                        'Раунд ${state.currentRound}',
                        style: theme.textTheme.navLargeTitleTextStyle,
                      ),
                      trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Haptics.light();
                          context.read<GameBloc>().add(const ResetGame());
                        },
                        child: const Icon(CupertinoIcons.refresh),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 24),
                        child: PlayerCarousel(
                          players: state.players,
                          activeIndex: state.spinIndex,
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          reverseDuration: const Duration(milliseconds: 250),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.08),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: _buildContent(context, state),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.15,
              shouldLoop: false,
              colors: const [
                Color(0xFF6C5DD3),
                Color(0xFF00D4AA),
                Color(0xFFFF6B6B),
                Color(0xFFFFB347),
                Color(0xFF5B8DEF),
                Color(0xFFFF6B9D),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, GameState state) {
    final theme = CupertinoTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (state.phase) {
      case GamePhase.setup:
        return const SizedBox.shrink(key: ValueKey('setup'));

      case GamePhase.spinning:
        return Column(
          key: const ValueKey('spinning'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Кто следующий?',
              style: theme.textTheme.navTitleTextStyle.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Свайпай или нажми крутить',
              style: theme.textTheme.textStyle.copyWith(
                fontSize: 15,
                color: isDark
                    ? CupertinoColors.systemGrey
                    : CupertinoColors.systemGrey2,
              ),
            ),
            const SizedBox(height: 24),
            wheel.SpinWheel(
              players: state.players,
              activeIndex: state.spinIndex,
              isSpinning: state.isSpinning,
              onSwipe: (velocity) {
                Haptics.medium();
                context.read<GameBloc>().add(SpinWheel(velocity: velocity));
              },
            ),
            const SizedBox(height: 16),
            AnimatedOpacity(
              opacity: state.isSpinning ? 0 : 1,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: AnimatedScale(
                scale: state.isSpinning ? 0.9 : 1,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: ScaleTap(
                  onTap: state.isSpinning
                      ? () {}
                      : () {
                          Haptics.medium();
                          context.read<GameBloc>().add(
                            const SpinWheel(velocity: 5000),
                          );
                        },
                  child: LiquidGlassButton(
                    text: 'Крутить',
                    icon: CupertinoIcons.arrow_2_circlepath,
                    width: double.infinity,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ],
        );

      case GamePhase.selecting:
        return Column(
          key: const ValueKey('selecting'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.currentPlayer != null)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: LiquidGlassContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  tint: CupertinoColors.systemIndigo.withValues(alpha: 0.35),
                  child: Text(
                    state.currentPlayer!.name,
                    style: theme.textTheme.navTitleTextStyle.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 14),
            Text(
              'теперь твой ход',
              style: theme.textTheme.textStyle.copyWith(
                fontSize: 17,
                color: isDark
                    ? CupertinoColors.systemGrey
                    : CupertinoColors.systemGrey2,
              ),
            ),
            const SizedBox(height: 44),
            TruthOrDareChoice(
              onTruth: () {
                Haptics.medium();
                context.read<GameBloc>().add(const SelectTruth());
              },
              onDare: () {
                Haptics.medium();
                context.read<GameBloc>().add(const SelectDare());
              },
            ),
          ],
        );

      case GamePhase.showingTruth:
      case GamePhase.showingDare:
        return Column(
          key: const ValueKey('showing'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.currentCard != null)
              GameCard(
                phase: state.phase,
                text: state.currentCard!,
                onComplete: () {
                  Haptics.success();
                  context.read<GameBloc>().add(const CompleteTask());
                },
              ),
          ],
        );

      case GamePhase.completed:
        return Column(
          key: const ValueKey('completed'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: LiquidGlassContainer(
                padding: const EdgeInsets.all(24),
                borderRadius: BorderRadius.circular(40),
                tint: CupertinoColors.systemGreen.withValues(alpha: 0.25),
                child: Icon(
                  CupertinoIcons.checkmark_alt_circle_fill,
                  size: 60,
                  color: CupertinoColors.systemGreen,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Отлично!',
              style: theme.textTheme.navTitleTextStyle.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Следующий игрок готов?',
              style: theme.textTheme.textStyle.copyWith(
                fontSize: 16,
                color: isDark
                    ? CupertinoColors.systemGrey
                    : CupertinoColors.systemGrey2,
              ),
            ),
            const SizedBox(height: 32),
            ScoreBoard(players: state.players),
            const SizedBox(height: 32),
            ScaleTap(
              onTap: () {
                Haptics.medium();
                context.read<GameBloc>().add(const SpinWheel());
              },
              child: LiquidGlassButton(
                text: 'Следующий ход',
                icon: CupertinoIcons.arrow_right,
                width: double.infinity,
                onPressed: () {},
              ),
            ),
          ],
        );
    }
  }
}
