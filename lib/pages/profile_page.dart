import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromARGB(255, 248, 248, 248),
        body: SafeArea(
          child: Center(
            child: Column(children: [
              SizedBox(height: 50),
              Icon(
                Icons.person,
                size: 75,
              ),

              SizedBox(height: 15),

              // welcome message
              Text('Signed in as:',
                  style: TextStyle(
                    color: Color.fromARGB(255, 45, 210, 4),
                    fontSize: 16,
                  )),

              SizedBox(height: 15),
            ]),
          ),
        ));
  }
}
