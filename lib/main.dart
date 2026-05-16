import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/game_bloc.dart';
import 'router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = GameBloc();

    return BlocProvider.value(
      value: bloc,
      child: CupertinoApp.router(
        title: 'Правда или действие',
        debugShowCheckedModeBanner: false,
        theme: _buildCupertinoTheme(Brightness.light),
        routerConfig: createRouter(bloc),
      ),
    );
  }

  CupertinoThemeData _buildCupertinoTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? CupertinoColors.white : CupertinoColors.black;

    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: const Color(0xFF007AFF),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0F0F1B)
          : const Color(0xFFF0F4F8),
      textTheme: CupertinoTextThemeData(
        navTitleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        navLargeTitleTextStyle: GoogleFonts.inter(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          color: textColor,
        ),
      ),
    );
  }
}

