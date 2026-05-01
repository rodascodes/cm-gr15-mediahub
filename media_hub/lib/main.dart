import 'package:flutter/material.dart';
import 'package:media_hub/login.dart';
import 'package:media_hub/routes.dart';

void main() {
  runApp(const MainApp());
  //runApp(const LoginScreen());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    /*return const MaterialApp(
      title: "Media Hub",
      
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );*/
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
