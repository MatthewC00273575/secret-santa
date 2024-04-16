import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretsanta/components/drawer.dart';
import 'package:secretsanta/pages/create_group_details.dart';
import 'package:secretsanta/pages/prof_page.dart';

class MeProfile extends StatefulWidget {
  const MeProfile({super.key});

  @override
  State<MeProfile> createState() => _MeProfile();
}

class _MeProfile extends State<MeProfile> {
  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // navigate to profile page
  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 75.0),
          child: Text(
            'Secret Santa',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Side menu
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignout: signUserOut,
      ),

      // Main body
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
                  MaterialPageRoute(
                      builder: (context) => const CreateGroupDetails()),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
