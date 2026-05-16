import '../../domain/entities/player.dart';

class GameLocalDataSource {
  final List<Player> _players = [];

  List<Player> get players => List.unmodifiable(_players);

  void addPlayer(String name) {
    _players.add(Player(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
    ));
  }

  void removePlayer(String playerId) {
    _players.removeWhere((p) => p.id == playerId);
  }

  void reset() => _players.clear();
}
