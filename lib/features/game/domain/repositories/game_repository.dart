import '../entities/player.dart';

abstract class GameRepository {
  List<Player> get players;
  void addPlayer(String name);
  void removePlayer(String playerId);
  void reset();
}
