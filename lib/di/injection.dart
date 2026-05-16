import 'package:get_it/get_it.dart';

import '../features/game/data/datasources/game_local_datasource.dart';
import '../features/game/data/datasources/questions_local_datasource.dart';
import '../features/game/data/repositories/game_repository_impl.dart';
import '../features/game/domain/repositories/game_repository.dart';
import '../features/game/presentation/bloc/game_bloc.dart';

final getIt = GetIt.instance;

void initDependencies() {
  // Data sources
  getIt.registerLazySingleton<GameLocalDataSource>(
    () => GameLocalDataSource(),
  );
  getIt.registerLazySingleton<QuestionsLocalDataSource>(
    () => QuestionsLocalDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(getIt()),
  );

  // BLoC
  getIt.registerFactory<GameBloc>(
    () => GameBloc(getIt(), getIt()),
  );
}
