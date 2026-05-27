import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../util/text_fields.dart'; 

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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Insert your email';
            }
            if (!value.contains('@')) {
              return 'Insert a valid email';
            }
            return null; 
          },
        ),

        const SizedBox(height: 16),

        TextFields(
          hintText: 'Password',
          prefixIcon: Icons.lock_outlined,
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          }, 
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
            child: const Text(
              "Don't have an account yet? Register here", 
              style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 0, 0, 64)),
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
      child: const _LoginFields(), 
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Colors.white)), 
        backgroundColor: const Color.fromARGB(255, 119, 0, 255),
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