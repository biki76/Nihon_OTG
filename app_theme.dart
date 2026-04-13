import 'package:flutter/material.dart';

// ─── Colour tokens ─────────────────────────────────────────────

class AppColors {
  // Light
  static const lightBg        = Color(0xFFF9F9FB);
  static const lightCard      = Color(0xFFFFFFFF);
  static const lightBorder    = Color(0xFFE2E4E9);
  static const lightTextMain  = Color(0xFF1A1E2B);
  static const lightTextSub   = Color(0xFF5A6270);
  static const lightAccent    = Color(0xFF2A9D8F);
  static const lightError     = Color(0xFFE76F51);
  static const lightViolet    = Color(0xFF7C3AED);
  static const lightNavBg     = Color(0xF8F9F9FB);

  // Dark
  static const darkBg         = Color(0xFF12141C);
  static const darkCard       = Color(0xFF1E202A);
  static const darkBorder     = Color(0xFF2A2D3A);
  static const darkTextMain   = Color(0xFFEFF1F5);
  static const darkTextSub    = Color(0xFF8B92A8);
  static const darkAccent     = Color(0xFF4ECDC4);
  static const darkError      = Color(0xFFF4A261);
  static const darkViolet     = Color(0xFF8B5CF6);
  static const darkNavBg      = Color(0xF812141C);
}

// ─── ThemeData factories ────────────────────────────────────────

ThemeData buildLightTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBg,
  colorScheme: const ColorScheme.light(
    primary: AppColors.lightAccent,
    error:   AppColors.lightError,
    surface: AppColors.lightCard,
  ),
  cardColor: AppColors.lightCard,
  dividerColor: AppColors.lightBorder,
  textTheme: _textTheme(AppColors.lightTextMain, AppColors.lightTextSub),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightCard,
    foregroundColor: AppColors.lightTextMain,
    elevation: 0,
    scrolledUnderElevation: 1,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightNavBg,
    selectedItemColor: AppColors.lightAccent,
    unselectedItemColor: AppColors.lightTextSub,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
);

ThemeData buildDarkTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBg,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.darkAccent,
    error:   AppColors.darkError,
    surface: AppColors.darkCard,
  ),
  cardColor: AppColors.darkCard,
  dividerColor: AppColors.darkBorder,
  textTheme: _textTheme(AppColors.darkTextMain, AppColors.darkTextSub),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkCard,
    foregroundColor: AppColors.darkTextMain,
    elevation: 0,
    scrolledUnderElevation: 1,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkNavBg,
    selectedItemColor: AppColors.darkAccent,
    unselectedItemColor: AppColors.darkTextSub,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
);

TextTheme _textTheme(Color main, Color sub) => TextTheme(
  displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: main, letterSpacing: -0.5),
  headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: main, letterSpacing: -0.3),
  headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: main, letterSpacing: -0.2),
  titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: main),
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: main, height: 1.5),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: sub, height: 1.5),
  labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: sub, height: 1.4),
);

// ─── ThemeProvider ──────────────────────────────────────────────

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode;
  ThemeProvider(this._mode);

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

// ─── Context extension for quick colour access ──────────────────

extension AppColorsX on BuildContext {
  Color get bg        => isDark ? AppColors.darkBg       : AppColors.lightBg;
  Color get cardColor => isDark ? AppColors.darkCard      : AppColors.lightCard;
  Color get border    => isDark ? AppColors.darkBorder    : AppColors.lightBorder;
  Color get textMain  => isDark ? AppColors.darkTextMain  : AppColors.lightTextMain;
  Color get textSub   => isDark ? AppColors.darkTextSub   : AppColors.lightTextSub;
  Color get accent    => isDark ? AppColors.darkAccent    : AppColors.lightAccent;
  Color get accentErr => isDark ? AppColors.darkError     : AppColors.lightError;
  Color get violet    => isDark ? AppColors.darkViolet    : AppColors.lightViolet;
  Color get navBg     => isDark ? AppColors.darkNavBg     : AppColors.lightNavBg;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  BoxDecoration get cardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: border),
    boxShadow: isDark
        ? [const BoxShadow(color: Color(0x4D000000), blurRadius: 8, offset: Offset(0, 2))]
        : [const BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))],
  );
}
