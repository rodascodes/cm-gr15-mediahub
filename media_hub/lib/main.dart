import 'package:flutter/material.dart';
import 'package:media_hub/routes.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp.router(
          title: 'MainApp',
          themeMode: currentMode, 
          
          theme: ThemeData(
            brightness: Brightness.light,
            colorSchemeSeed: const Color.fromARGB(255, 119, 0, 255),
            scaffoldBackgroundColor: Colors.white, 
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 119, 0, 255), 
              foregroundColor: Colors.white,
            ),
          ),
          
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: const Color.fromARGB(255, 119, 0, 255),
            scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 20), 
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 40, 0, 80), 
              foregroundColor: Colors.white,
            ),
          ),
          
          routerConfig: router, 
        );
      },
    );
  }
}
