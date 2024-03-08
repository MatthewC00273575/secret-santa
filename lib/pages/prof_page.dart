import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretsanta/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // edit field
  Future<void> editField(String field) async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // tiltle
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 75.0),
          child: Text(
            'Profile page',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),

      // Main body
      body: ListView(
        children: [
          const SizedBox(height: 10),
          // Profile pic
          const Icon(
            Icons.person,
            size: 72,
          ),

          const SizedBox(height: 10),

          // user email
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color.fromARGB(255, 110, 110, 110)),
          ),

          const SizedBox(height: 40),

          // user details
          const Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: Text(
              'My Details',
              style: TextStyle(color: Color.fromARGB(255, 110, 110, 110)),
            ),
          ),

          // username
          MyTextBox(
            text: 'matt',
            sectionName: 'username',
            onPressed: () => editField('username'),
          ),

          // bio
          MyTextBox(
            text: 'empty bio',
            sectionName: 'bio',
            onPressed: () => editField('bio'),
          ),
          const SizedBox(height: 40),

          // user posts
          const Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: Text(
              'My Groups',
              style: TextStyle(color: Color.fromARGB(255, 110, 110, 110)),
            ),
          ),
        ],
      ),
    );
  }
}
