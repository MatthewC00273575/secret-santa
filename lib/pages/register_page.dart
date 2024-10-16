import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretsanta/components/my_button.dart';
import 'package:secretsanta/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    //try sign up
    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        // after creating new user, create new document in cloud firestore called users
        FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.email)
            .set({
          'username': emailController.text.split('@')[0], // initial name
          'bio': 'Empty bio..' //iniatlly empty
        });
      } else {
        //show error, if passwords dont match
        showErrorMessage("passwords dont macth!");
      }
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // show error message
      showErrorMessage(e.code);
    }
  }

  // wrong email message popup
  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
                child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 10),
                // logo
                Image.asset('lib/images/christmas-icon-png-17.jpg',
                    height: 200), // logo

                const SizedBox(height: 30),

                // welcome message
                const Text('Lets get you set up Santa\'s little helper!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 45, 210, 4),
                      fontSize: 16,
                    )),

                const SizedBox(height: 25),

                // Textfield //username
                MyTextField(
                  controller: emailController,
                  hintText: 'email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // TextField // Password
                MyTextField(
                  controller: passwordController,
                  hintText: 'password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // TextField // confirm Password
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign up button
                MyButton(text: "Sign up", onTap: signUserUp), // MyButton

                const SizedBox(height: 25),

                // already got an account? return to log in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ]),
            ),
          ),
        ));
  }
}
