import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_hub/main.dart';
import 'package:media_hub/services/auth_service.dart';
import '../util/text_fields.dart';
import '../util/app_validators.dart';

class _RegisterFields extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const _RegisterFields({required this.usernameController, required this.nameController, required this.emailController, required this.passwordController});

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
          hintText: 'Username',
          controller: usernameController,
          prefixIcon: Icons.person_outline,
          validator: AppValidators.validateUsername,
        ),

        const SizedBox(height: 16),

        TextFields(
          hintText: 'Name (optional)',
          controller: nameController,
          prefixIcon: Icons.badge_outlined,
        ),

        const SizedBox(height: 16),

        TextFields(
          hintText: 'Email',
          controller: emailController,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: AppValidators.validateEmail,
        ),

        const SizedBox(height: 16),

        TextFields(
          hintText: 'Password',
          prefixIcon: Icons.lock_outlined,
          isPassword: true, 
          controller: passwordController,
          validator: AppValidators.validatePassword,
        ),

        const SizedBox(height: 16),

        TextFields(
          hintText: 'Confirm your password',
          prefixIcon: Icons.lock_reset_outlined, 
          isPassword: true,
          validator: (value) => AppValidators.validateConfirmPassword(value, passwordController.text),
        ),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () async { 

              if (Form.of(context).validate()) {
                try {
                  await AuthService().register(usernameController.text, nameController.text, emailController.text, passwordController.text);
                  if(!context.mounted) return; //if this widget was for some reason removed from the widget tree, returns. this can happen if the widget has been disposed during the async operation (putting this here avoids warnings)
                  context.go('/home');
                }
                catch (e)
                {
                  if(!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration error: $e')));
                }
              }
            },
            child: const Text('Register'),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () => context.go('/login'),
            child: Text(
              "Already have an account? Login", 
              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.primary),
            ),
          ), 
        )
      ],
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();
  
  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: _RegisterFields(usernameController: _usernameController, nameController: _nameController, emailController: _emailController, passwordController: _passwordController), 
    );
  }
}
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register", style: TextStyle(color: Colors.white)), 
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
            child: const _RegisterForm(),
          ),
        ),
      ),
    );
  }
}