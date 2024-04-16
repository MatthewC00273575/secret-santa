import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secretsanta/components/drawer.dart';
import 'package:secretsanta/pages/prof_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final String userProfileDeepLink =
      'https://secretsanta.flutter.com/user-groups';

  Future<void> copyLinkToClipboard() async {
    await Clipboard.setData(ClipboardData(text: userProfileDeepLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard!')),
    );
  }

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
        title: const Text(
          'Secret Santa',
          style: TextStyle(color: Colors.white),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              "LOGGED IN AS: ${user.email!}",
              style: const TextStyle(fontSize: 12),
            ),
          ),
          ElevatedButton(
            onPressed: copyLinkToClipboard,
            child: const Text('Copy Link'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome to the app!',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
