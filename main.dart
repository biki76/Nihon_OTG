import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restore saved theme
  final prefs  = await SharedPreferences.getInstance();
  final saved  = prefs.getString('theme') ?? 'system';
  final initial = saved == 'dark'
      ? ThemeMode.dark
      : saved == 'light'
          ? ThemeMode.light
          : ThemeMode.system;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(initial)
        ..addListener(() {
          // Persist toggle
          prefs.setString('theme', initial == ThemeMode.dark ? 'dark' : 'light');
        }),
      child: const N5App(),
    ),
  );
}

class N5App extends StatelessWidget {
  const N5App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      title: 'ビキ先生 N5',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.mode,
      theme:     buildLightTheme(),
      darkTheme: buildDarkTheme(),
      routerConfig: router,
    );
  }
}
