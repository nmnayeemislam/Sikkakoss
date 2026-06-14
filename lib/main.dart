import 'dart:async';

import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
import 'screens/splash_screen.dart';
import 'services/audio_service.dart';
import 'services/progress_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressService.init();
  await AudioService.instance.init();
  runApp(const KidsLearningApp());
}

class KidsLearningApp extends StatefulWidget {
  const KidsLearningApp({super.key});

  @override
  State<KidsLearningApp> createState() => _KidsLearningAppState();
}

class _KidsLearningAppState extends State<KidsLearningApp>
    with WidgetsBindingObserver {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isDarkMode = ProgressService.isDarkMode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(AudioService.instance.dispose());
    super.dispose();
  }

  void _handleThemeChanged(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AudioService.instance.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: SplashScreen(onThemeChanged: _handleThemeChanged),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.coral,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF101828)
          : AppColors.cream,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        centerTitle: false,
        foregroundColor: isDark ? Colors.white : AppColors.ink,
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : AppColors.ink,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
      cardTheme: const CardThemeData(margin: EdgeInsets.zero),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
