import 'package:flutter/material.dart';
import 'package:secretsanta/pages/groupnamepage.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Secret Santa',
            style: TextStyle(color: Color.fromARGB(255, 210, 83, 83)),
          ),
          backgroundColor: const Color.fromARGB(240, 49, 29, 19),
          centerTitle: true,
        ),
        backgroundColor: const Color.fromARGB(255, 241, 233, 230),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.person,
                size: 75,
              ),
              const SizedBox(height: 50),

              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 60),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(240, 49, 29, 19),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'I\'m here to help you organize your celebration quickly and easily.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 229, 213, 231),
                        ),
                      ),
                      TextSpan(
                        text: '\n \nClick below to get started!',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 210, 83, 83),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              //create group button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 84, 145, 152),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text(
                  'Create group',
                  style: TextStyle(
                    color: Color.fromARGB(255, 229, 213, 231),
                    fontSize: 15,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroupName()),
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      );
}
