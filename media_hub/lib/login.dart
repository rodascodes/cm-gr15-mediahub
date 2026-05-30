import 'package:flutter/material.dart';
import 'package:media_hub/main.dart';
import 'package:go_router/go_router.dart';
import '../util/text_fields.dart'; 
import '../util/app_validators.dart';

class _LoginFields extends StatelessWidget {
  const _LoginFields();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SizedBox(
            width: 180, 
            height: 100, 
            child: Image.asset("assets/images/logo_T.png"),
          ),
        ),
        
        const SizedBox(height: 32),

        TextFields(
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: AppValidators.validateEmail,
        ),

        const SizedBox(height: 16),

        TextFields(
          hintText: 'Password',
          prefixIcon: Icons.lock_outlined,
          isPassword: true,
          //Login doesn't require the same password complexity as registration, so we only check if it's not empty
          validator: AppValidators.validateNonEmptyPassword,
        ),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              if (Form.of(context).validate()) {
                context.go('/home');
              }
            },
            child: const Text('Login'),
          ),
        ),
        
        Center(
          child: GestureDetector(
            onTap: () => context.go('/register'),
            child: Text(
              "Don't have an account yet? Register here", 
              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.primary),
            ),
          ), 
        )
      ],
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();
  
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: const _LoginFields(), 
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))), 
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const _LoginForm(),
          ),
        ),
      ),
    );
  }
}