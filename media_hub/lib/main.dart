import 'package:flutter/material.dart';
import 'package:media_hub/routes.dart';
import 'util/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initialize();
  
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
