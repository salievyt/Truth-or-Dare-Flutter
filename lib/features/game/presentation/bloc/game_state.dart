import 'package:equatable/equatable.dart';

import '../../domain/entities/game_phase.dart';
import '../../domain/entities/player.dart';

class GameState extends Equatable {
  final List<Player> players;
  final GamePhase phase;
  final String? currentPlayerId;
  final int spinIndex;
  final String? currentCard;
  final int currentRound;
  final bool isSpinning;

  const GameState({
    this.players = const [],
    this.phase = GamePhase.setup,
    this.currentPlayerId,
    this.spinIndex = 0,
    this.currentCard,
    this.currentRound = 1,
    this.isSpinning = false,
  });

  GameState copyWith({
    List<Player>? players,
    GamePhase? phase,
    String? currentPlayerId,
    int? spinIndex,
    String? currentCard,
    int? currentRound,
    bool? isSpinning,
  }) {
    return GameState(
      players: players ?? this.players,
      phase: phase ?? this.phase,
      currentPlayerId: currentPlayerId ?? this.currentPlayerId,
      spinIndex: spinIndex ?? this.spinIndex,
      currentCard: currentCard ?? this.currentCard,
      currentRound: currentRound ?? this.currentRound,
      isSpinning: isSpinning ?? this.isSpinning,
    );
  }

  Player? get currentPlayer {
    if (currentPlayerId == null) return null;
    try {
      return players.firstWhere((p) => p.id == currentPlayerId);
    } catch (_) {
      return null;
    }
  }

  bool get canStart => players.length >= 2;

  @override
  List<Object?> get props => [
        players,
        phase,
        currentPlayerId,
        spinIndex,
        currentCard,
        currentRound,
        isSpinning,
      ];
}
