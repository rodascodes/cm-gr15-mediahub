import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Text("REGISTAR"), ElevatedButton(onPressed: () => context.go('/login'), child: Text("back"))],)
    );
  }

}