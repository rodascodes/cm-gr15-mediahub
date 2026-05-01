//file for everything that's login related
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//go router deve de estar num ficheiro à parte como static

class LoginFields extends StatelessWidget{
  const LoginFields({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: SizedBox(width: 180, height: 100, child: Image.asset("assets/images/logo_T.png"))),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Email'),
          //here will be a validator but since now its only UI impl validator won't be filled for now:
          /* From the official flutter api website:
          validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          */
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Password')
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () { 
              context.go('/home');
            },
            child: const Text('Login'),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () => context.go('/register'),
            child: Text("Don't have an account yet? Register here", style: TextStyle(fontSize: 8, color: Color.from(alpha: 1, red: 0, green: 0, blue: 64), ))), 
          )
          
      ],
    );
  }
}

//https://api.flutter.dev/flutter/widgets/Form-class.html
class LoginForm extends StatefulWidget{
  const LoginForm({super.key});
  
  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>{
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: LoginFields(),
    );
  }
}

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: LoginForm(),
      ),
    );
  }
  
}