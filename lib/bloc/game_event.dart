import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class AddPlayer extends GameEvent {
  final String name;

  const AddPlayer(this.name);

  @override
  List<Object?> get props => [name];
}

class RemovePlayer extends GameEvent {
  final String playerId;

  const RemovePlayer(this.playerId);

  @override
  List<Object?> get props => [playerId];
}

class StartGame extends GameEvent {
  const StartGame();
}

class SpinWheel extends GameEvent {
  final double? velocity;

  const SpinWheel({this.velocity});

  @override
  List<Object?> get props => [velocity];
}

class SelectTruth extends GameEvent {
  const SelectTruth();
}

class SelectDare extends GameEvent {
  const SelectDare();
}

class CompleteTask extends GameEvent {
  const CompleteTask();
}

class ResetGame extends GameEvent {
  const ResetGame();
}
