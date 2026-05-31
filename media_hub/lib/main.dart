import 'package:flutter/material.dart';
import 'package:media_hub/routes.dart';
import 'util/app_colors.dart';

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
            colorSchemeSeed: AppColors.primary, 
            scaffoldBackgroundColor: AppColors.lightBackground,
            cardColor: AppColors.lightSurface,                 
            
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: AppColors.lightBackground,
              selectedItemColor: AppColors.primary,
            ),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: AppColors.primary, 
            scaffoldBackgroundColor: AppColors.darkBackground, 
            cardColor: AppColors.darkSurface,                  
            
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: AppColors.darkBackground,
              selectedItemColor: AppColors.primary,
            ),
          ),
          
          routerConfig: router, 
        );
      },
    );
  }
}
