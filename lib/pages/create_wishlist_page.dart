import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretsanta/components/drawer.dart';
import 'package:secretsanta/pages/prof_page.dart';
import 'package:secretsanta/pages/wish_page.dart';
import 'package:secretsanta/theme/colours.dart';

class CreateWish extends StatefulWidget {
  const CreateWish({super.key});

  @override
  State<CreateWish> createState() => _CreateWishState();
}

class _CreateWishState extends State<CreateWish> {
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
      appBar: AppBar(
        title: const Text(
          'Festive Exchange',
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

      backgroundColor: accentsColour,
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate to another page when the tile is clicked
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyWishlist()),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "My Wishlist",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Icon(Icons.add),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
