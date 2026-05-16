import '../../domain/entities/player.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_local_datasource.dart';

class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource _dataSource;

  GameRepositoryImpl(this._dataSource);

  @override
  List<Player> get players => _dataSource.players;

  @override
  void addPlayer(String name) => _dataSource.addPlayer(name);

  @override
  void removePlayer(String playerId) => _dataSource.removePlayer(playerId);

  @override
  void reset() => _dataSource.reset();
}
