import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretsanta/components/drawer.dart';
import 'package:secretsanta/pages/prof_page.dart';

class MyInbox extends StatefulWidget {
  const MyInbox({super.key});

  @override
  State<MyInbox> createState() => _MyInbox();
}

class _MyInbox extends State<MyInbox> {
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

        // body
        body: Center(child: Text('Inbox screen')));
  }
}
