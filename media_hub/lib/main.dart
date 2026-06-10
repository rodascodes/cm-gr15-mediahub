import 'package:flutter/material.dart';
import 'package:media_hub/routes.dart';
import 'utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';
import 'controllers/notification_service.dart';

/**
 * Notifier global que controla o tema da aplicação (claro/escuro).
 * Qualquer widget pode alterar o tema chamando [themeNotifier.value = ThemeMode.dark].
 */
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

/// Entry point da aplicação.
/// Inicializa o Firebase antes de lançar a app para garantir que
/// os serviços (Auth, Firestore) estão disponíveis desde o arranque.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initialize();

  runApp(const MainApp());
}

/**
 * Widget raiz da aplicação MediaHub.
 * Configura tema, roteamento e suporte a alteração de tema em tempo real.
 */
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
