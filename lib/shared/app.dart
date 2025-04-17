import 'package:docorganizer/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

final class App extends StatelessWidget {
  static ThemeData _theme(Brightness brightness) => ThemeData.from(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
      seedColor: const Color(0xFF808080),
    ),
  );

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
