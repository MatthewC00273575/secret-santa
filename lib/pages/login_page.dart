import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretsanta/components/my_button.dart';
import 'package:secretsanta/components/my_textfield.dart';
import 'package:secretsanta/components/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
        body: SafeArea(
          child: Center(
            child: Column(children: [
              const SizedBox(height: 10),
              // logo
              Image.asset('lib/images/christmas-icon-png-17.jpg',
                  height: 150), // logo

              const SizedBox(height: 30),

              // welcome message
              const Text('Welcome back To Santa\'s little helper!',
                  style: TextStyle(
                    color: Color.fromARGB(255, 45, 210, 4),
                    fontSize: 16,
                  )),

              const SizedBox(height: 25),

              MyTextField(
                controller: emailController,
                hintText: 'email',
                obscureText: false,
              ), // Textfield //username

              const SizedBox(height: 10),

              MyTextField(
                controller: passwordController,
                hintText: 'password',
                obscureText: true,
              ), // TextField // Password

              const SizedBox(height: 10),

              // forgot password?
              const Text(
                'Forgot Password?',
                style: TextStyle(color: Color.fromARGB(255, 112, 111, 111)),
              ),

              const SizedBox(height: 25),

              MyButton(onTap: signUserIn), // MyButton

              const SizedBox(height: 25),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Color.fromARGB(255, 158, 158, 158),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // google + facebook sign in buttons
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //google button
                  SquareTile(
                      imagePath:
                          'lib/images/google-icon-logo-png-transparent_53892.png'),

                  SizedBox(width: 10),

                  //facebook button
                  SquareTile(
                      imagePath: 'lib/images/downloading-facebook-icon-10.jpg'),
                ],
              ),

              const SizedBox(height: 15),

              // not a member? REGISTER!!
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Register now',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ]),
          ),
        ));
  }
}
