import 'package:flutter/material.dart';
import 'package:media_hub/main.dart';
import 'package:go_router/go_router.dart';
import '../util/text_fields.dart'; 
import '../util/app_validators.dart';
import '../services/auth_service.dart';

/**
 * Widget que constrói os campos do formulário de login.
 * Inclui campos de email e password.
 */
class _LoginFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  
  const _LoginFields({required this.emailController, required this.passwordController});

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
          controller: emailController,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: AppValidators.validateEmail,
        ),

        const SizedBox(height: 16),

        TextFields(
          controller: passwordController,
          hintText: 'Password',
          prefixIcon: Icons.lock_outlined,
          isPassword: true,
          validator: AppValidators.validateNonEmptyPassword,
        ),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () async {
              if (Form.of(context).validate()) {
                try {
                  await AuthService().login(emailController.text, passwordController.text);
                  if(!context.mounted) return;
                  context.go('/home');
                }
                catch (e)
                {
                  if(!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login error: $e')));
                }
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

/**
 * Formulário de login encapsulado em StatefulWidget.
 * Gerencia validacão e estado do formulário.
 */
class _LoginForm extends StatefulWidget {
  const _LoginForm();
  
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

/**
 * Estado do formulário de login.
 * Gerencia os controladores de texto e a validação.
 */
class _LoginFormState extends State<_LoginForm> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: _LoginFields(
        emailController: _emailController,
        passwordController: _passwordController,
      ),
    );
  }
}

/**
 * Ecrã de login da aplicação.
 * Exibe formulário de autenticação com suporte a tema claro/escuro.
 */
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