import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/questions.dart';
import '../models/game_phase.dart';
import '../models/player.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final Random _random = Random();

  GameBloc() : super(const GameState()) {
    on<AddPlayer>(_onAddPlayer);
    on<RemovePlayer>(_onRemovePlayer);
    on<StartGame>(_onStartGame);
    on<SpinWheel>(_onSpinWheel);
    on<SelectTruth>(_onSelectTruth);
    on<SelectDare>(_onSelectDare);
    on<CompleteTask>(_onCompleteTask);
    on<ResetGame>(_onResetGame);
  }

  void _onAddPlayer(AddPlayer event, Emitter<GameState> emit) {
    final newPlayer = Player(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: event.name.trim(),
    );
    emit(state.copyWith(players: [...state.players, newPlayer]));
  }

  void _onRemovePlayer(RemovePlayer event, Emitter<GameState> emit) {
    final updated = state.players.where((p) => p.id != event.playerId).toList();
    emit(state.copyWith(players: updated));
  }

  void _onStartGame(StartGame event, Emitter<GameState> emit) {
    if (state.players.isEmpty) return;
    emit(state.copyWith(
      phase: GamePhase.spinning,
      currentPlayerId: state.players.first.id,
      currentRound: 1,
    ));
  }

  void _onSpinWheel(SpinWheel event, Emitter<GameState> emit) async {
    if (state.players.isEmpty || state.isSpinning) return;

    emit(state.copyWith(isSpinning: true));

    // Базовые спины + бонус от velocity свайпа
    int baseSpins = 12;
    if (event.velocity != null) {
      baseSpins += (event.velocity!.abs() / 800).toInt().clamp(0, 25);
    }
    final int totalSpins = baseSpins + _random.nextInt(8);
    final int selectedIndex = _random.nextInt(state.players.length);

    // Физика: ускорение -> постоянная скорость -> замедление
    final int accelEnd = (totalSpins * 0.15).toInt();
    final int decelStart = (totalSpins * 0.65).toInt();

    for (int i = 0; i < totalSpins; i++) {
      int delayMs;
      if (i < accelEnd) {
        // Ускорение: от 180мс до 60мс
        final progress = i / accelEnd;
        delayMs = (180 - progress * 120).toInt();
      } else if (i < decelStart) {
        // Постоянная скорость
        delayMs = 55;
      } else {
        // Замедление: от 60мс до 350мс
        final progress = (i - decelStart) / (totalSpins - decelStart);
        delayMs = (60 + progress * progress * 350).toInt();
      }

      await Future.delayed(Duration(milliseconds: delayMs));
      emit(state.copyWith(spinIndex: i % state.players.length));
    }

    await Future.delayed(const Duration(milliseconds: 400));

    final selectedPlayer = state.players[selectedIndex];
    emit(state.copyWith(
      phase: GamePhase.selecting,
      currentPlayerId: selectedPlayer.id,
      spinIndex: selectedIndex,
      isSpinning: false,
    ));
  }

  void _onSelectTruth(SelectTruth event, Emitter<GameState> emit) {
    final question = truthQuestions[_random.nextInt(truthQuestions.length)];
    emit(state.copyWith(
      phase: GamePhase.showingTruth,
      currentCard: question,
    ));
  }

  void _onSelectDare(SelectDare event, Emitter<GameState> emit) {
    final dare = dareActions[_random.nextInt(dareActions.length)];
    emit(state.copyWith(
      phase: GamePhase.showingDare,
      currentCard: dare,
    ));
  }

  void _onCompleteTask(CompleteTask event, Emitter<GameState> emit) {
    final updatedPlayers = state.players.map((p) {
      if (p.id == state.currentPlayerId) {
        if (state.phase == GamePhase.showingTruth) {
          return p.copyWith(truthCount: p.truthCount + 1);
        } else if (state.phase == GamePhase.showingDare) {
          return p.copyWith(dareCount: p.dareCount + 1);
        }
      }
      return p;
    }).toList();

    emit(state.copyWith(
      players: updatedPlayers,
      phase: GamePhase.completed,
      currentCard: null,
    ));
  }

  void _onResetGame(ResetGame event, Emitter<GameState> emit) {
    emit(const GameState());
  }
}
