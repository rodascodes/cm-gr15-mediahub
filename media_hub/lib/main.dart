import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'page_info.dart';

void main() {
  runApp(const MainApp());
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MoviePage(),
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
