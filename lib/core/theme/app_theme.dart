import 'package:flutter/cupertino.dart';

class AppTheme {
  static CupertinoThemeData light = _buildTheme(Brightness.light);
  static CupertinoThemeData dark = _buildTheme(Brightness.dark);

  static CupertinoThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? CupertinoColors.white : CupertinoColors.black;

    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: const Color(0xFF007AFF),
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF0A0A14) : const Color(0xFFEEF2F7),
      textTheme: CupertinoTextThemeData(
        navTitleTextStyle: TextStyle(
          fontFamily: '.SF UI Text',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        navLargeTitleTextStyle: TextStyle(
          fontFamily: '.SF UI Display',
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.5,
        ),
        textStyle: TextStyle(
          fontFamily: '.SF UI Text',
          fontSize: 16,
          color: textColor,
        ),
      ),
    );
  }
}
