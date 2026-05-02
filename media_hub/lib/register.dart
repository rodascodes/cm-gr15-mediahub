import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _RegisterFields extends StatelessWidget {
  const _RegisterFields();

  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: SizedBox(width: 180, height: 100, child: Image.asset("assets/images/logo_T.png"))),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Insert your username'),
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Insert your email'),
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Insert your password')
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Confirm your password')
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () { 
              context.go('/home');
            },
            child: const Text('Register'),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () => context.go('/login'),
            child: Text("Already have an account? Login", style: TextStyle(fontSize: 8, color: Color.from(alpha: 1, red: 0, green: 0, blue: 64), ))), 
          )
          
      ],
    );
  }
}

class _RegisterForm extends StatefulWidget{
  const _RegisterForm();
  
  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm>{
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child: _RegisterFields(),
    );
  }
}

class RegisterScreen extends StatelessWidget{
  const RegisterScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register", style: TextStyle(color: Colors.white),), backgroundColor: Color.fromARGB(255, 119, 0, 255),),
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