import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../bloc/game_bloc.dart';
import '../bloc/game_state.dart';
import '../models/game_phase.dart';
import '../screens/game_screen.dart';
import '../screens/setup_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(GameBloc bloc) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: _BlocListenable(bloc),
    redirect: (context, state) {
      final gameState = bloc.state;
      final isSetup = gameState.phase == GamePhase.setup;
      final atSetup = state.matchedLocation == '/';

      if (isSetup && !atSetup) return '/';
      if (!isSetup && atSetup) return '/game';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const CupertinoPage(
          child: SetupScreen(),
        ),
      ),
      GoRoute(
        path: '/game',
        pageBuilder: (context, state) => const CupertinoPage(
          child: GameScreen(),
        ),
      ),
    ],
  );
}

class _BlocListenable extends ChangeNotifier {
  late final GameBloc _bloc;
  late GameState _state;

  _BlocListenable(this._bloc) {
    _state = _bloc.state;
    _bloc.stream.listen((newState) {
      if (_state.phase != newState.phase) {
        _state = newState;
        notifyListeners();
      }
    });
  }
}
