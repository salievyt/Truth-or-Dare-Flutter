import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/animations.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/liquid_glass/ambient_background.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass_button.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass_container.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import '../widgets/add_player_dialog.dart';
import '../widgets/player_chip.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final r = Responsive(context);

    return AmbientBackground(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: r.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.all(r.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: r.scale(20, 28, 36)),
                FadeIn(
                  child: SlideUp(
                    child: Text(
                      'Правда или\nдействие',
                      style: theme.textTheme.navLargeTitleTextStyle.copyWith(
                        fontSize: r.scale(40, 48, 56),
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeIn(
                  duration: const Duration(milliseconds: 600),
                  child: SlideUp(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      'Добавь игроков и начни веселье',
                      style: theme.textTheme.textStyle.copyWith(
                        fontSize: r.scale(16, 17, 18),
                        color: isDark
                            ? CupertinoColors.systemGrey
                            : CupertinoColors.systemGrey2,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: r.scale(32, 36, 40)),
                FadeIn(
                  duration: const Duration(milliseconds: 700),
                  child: SlideUp(
                    delay: const Duration(milliseconds: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Игроки',
                          style: theme.textTheme.textStyle.copyWith(
                            fontSize: r.scale(20, 22, 24),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Haptics.light();
                            _addPlayer(context);
                          },
                          child: LiquidGlassContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            blur: 16,
                            showGloss: false,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.add,
                                  size: 16,
                                  color: isDark
                                      ? CupertinoColors.white
                                      : CupertinoColors.black,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Добавить',
                                  style: theme.textTheme.textStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<GameBloc, GameState>(
                    builder: (context, state) {
                      if (state.players.isEmpty) {
                        return FadeIn(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.person_2,
                                  size: r.scale(64, 72, 80),
                                  color: isDark
                                      ? CupertinoColors.systemGrey
                                          .withValues(alpha: 0.5)
                                      : CupertinoColors.systemGrey3
                                          .withValues(alpha: 0.6),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Пока никого нет',
                                  style: theme.textTheme.textStyle.copyWith(
                                    fontSize: r.scale(16, 17, 18),
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? CupertinoColors.systemGrey
                                        : CupertinoColors.systemGrey2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Добавь минимум 2 игрока',
                                  style: theme.textTheme.textStyle.copyWith(
                                    fontSize: 14,
                                    color: isDark
                                        ? CupertinoColors.systemGrey
                                        : CupertinoColors.systemGrey2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Wrap(
                          key: ValueKey(state.players.length),
                          spacing: 10,
                          runSpacing: 10,
                          children: state.players.map((player) {
                            return PlayerChip(
                              player: player,
                              onRemove: () {
                                Haptics.light();
                                context
                                    .read<GameBloc>()
                                    .add(RemovePlayer(player.id));
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<GameBloc, GameState>(
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: state.canStart
                          ? ScaleTap(
                              key: const ValueKey('ready'),
                              onTap: () {
                                Haptics.medium();
                                context.read<GameBloc>().add(const StartGame());
                              },
                              child: LiquidGlassButton(
                                text: 'Начать игру',
                                icon: CupertinoIcons.play_fill,
                                width: double.infinity,
                                onPressed: () {},
                              ),
                            )
                          : ScaleTap(
                              key: const ValueKey('disabled'),
                              onTap: () => Haptics.light(),
                              child: LiquidGlassContainer(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                borderRadius: BorderRadius.circular(18),
                                blur: 16,
                                tint: isDark
                                    ? CupertinoColors.systemGrey6
                                        .withValues(alpha: 0.15)
                                    : CupertinoColors.white
                                        .withValues(alpha: 0.15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.lock_fill,
                                      size: 16,
                                      color: isDark
                                          ? CupertinoColors.systemGrey
                                          : CupertinoColors.systemGrey3,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Нужно минимум 2 игрока',
                                      style:
                                          theme.textTheme.textStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? CupertinoColors.systemGrey
                                            : CupertinoColors.systemGrey3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addPlayer(BuildContext context) async {
    final name = await showCupertinoDialog<String>(
      context: context,
      builder: (_) => const AddPlayerDialog(),
    );
    if (name != null && name.isNotEmpty && context.mounted) {
      Haptics.success();
      context.read<GameBloc>().add(AddPlayer(name));
    }
  }
}
