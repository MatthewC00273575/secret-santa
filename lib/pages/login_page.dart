import 'package:flutter/material.dart';
import 'package:secretsanta/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 211, 210, 210),
        body: SafeArea(
          child: Center(
            child: Column(children: [
              const SizedBox(height: 50),
              // logo
              const Icon(Icons.lock, size: 100), // icon

              const SizedBox(height: 50),

              // welcome message
              const Text('Welcome back To Santa\'s little helper',
                  style: TextStyle(
                    color: Color.fromARGB(255, 64, 216, 5),
                    fontSize: 16,
                  )),

              const SizedBox(height: 25),

              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ), // Textfield

              const SizedBox(height: 10),

              MyTextField(
                controller: passwordController,
                hintText: 'password',
                obscureText: true,
              ), // TextField
              //username
            ]),
          ),
        ));
  }
}
