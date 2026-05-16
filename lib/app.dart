import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'di/injection.dart';
import 'features/game/presentation/bloc/game_bloc.dart';
import 'router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt<GameBloc>();

    return BlocProvider.value(
      value: bloc,
      child: CupertinoApp.router(
        title: 'Правда или действие',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: createRouter(bloc),
      ),
    );
  }
}
